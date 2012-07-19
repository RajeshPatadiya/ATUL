<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class Atul_User
{
	private $id;
	private $username;
	private $name;
	private $rolesloaded = false;
	
	private $_groups;
	private $_roles = array();
	protected $_data = array();

	/**
	 * Optionally provide the id of the user on instantiation, an array of properties,
	 * and an array of user roles/groups
	 * @param $id (optional) the user id
	 * @param $params (optional) an array of initial parameters
	 * @param $groups (optional) a list of groups/roles the user belongs to
	 */
	public function __construct($id = NULL, $params = NULL, $groups = NULL)
	{
		if ($id != NULL) {
			$this->setId($id);
		}

		if ($params != NULL) {
			foreach($params as $name => $param) {
				if ($name == 'name') {
					$this->name = $param;
				} else if ($name == 'username') {
					$this->username = $param;
				} else {
					$this->_data[$name] = $param;
				}
			}
		}

		if ($groups != NULL) {
			$this->rolesloaded = true;
			$this->_roles = $groups;
		}
	}

	/**
	 * Set the name of the current user
	 * @param $name the name of the user
	 */
	public function setName($name)
	{
		$this->name = $name;
	}

	/**
	 * Return the name of the current user
	 * @return string the name
	 */
	public function getName()
	{
		return $this->name;
	}

	/**
	 * get the username of the user
	 * @return string the username
	 */
	public function getLogin()
	{
		return $this->login;
	}

	/**
	 * Set the username of this user item
	 * @param $login the user's login name
	 */
	public function setLogin($login)
	{
		$this->login = $login;
	}

	/**
	 * Get the id of this user
	 * @return int the user's id
	 */
	public function getId()
	{
		return $this->id;
	}

	/**
	 * Set the id of the user
	 * @param $id the user's id
	 */
	public function setId($id)
	{
		if(is_numeric($id)) {
			$this->id = $id;
		}
	}

	/**
	 * Check to see if a user is part of a particular role or group,
	 * if roles have not been loaded yet, retrieve list from active directory
	 * @param $role
	 * @return bool whether the role is part of this user
	 */
	public function hasRole($role)
	{
		///TODO: hijack this and pipe through groups to use service desk
		if (!$this->rolesloaded) {
			$this->loadRoles();
		}
		foreach($this->_roles as $r) {
			if (strtolower($r) == strtolower($role)) {
				return true;
			}
		}
		return false;
	}
	
	public function hasGroup($group)
	{
		$this->loadGroups();
		foreach($this->_groups as $g) {
			if ($g['DisplayName'] == $group) {
				return true;
			}
		}
		return false;
	}
	
	public function hasGroupID($groupId)
	{
		$this->loadGroups();
		foreach($this->_groups as $g) {
			if ($g['AtulUserID'] == $groupId) {
				return true;
			}
		}
		return false;
	}
	
	public function isAuthorized($owner)
	{
		if ($owner == $this->AtulUserID) {
			return true;
		}
		return $this->hasGroupID($owner);
	}
	
	public function getGroups()
	{
		$this->loadGroups();
		return $this->_groups;
	}
	
	private function loadGroups()
	{
	
		if ($this->_groups == null) {
			$this->_groups = DataManager_User::GetGroupsForUser($this->username);
		}
	}
	
	public function isValid() 
	{
		return (isset($this->id) && $this->id != null && $this->id != '');
	}
	
	/**
	 * Call out to active directory to retrieve a list of roles to which a 
	 * user belongs.  Once we've done this, we need to reset the 
	 * user object in cache
	 */
	public function loadRoles()
	{
		$ldapoptions = Zend_Registry::get('ldapoptions');
		$auth = Atul_Auth_Ldap::getInstance($ldapoptions);
		$this->_roles = $auth->getGroups($this->distinguishedName);
		$this->rolesloaded = true;
		Atul_Debugger::debug('yes', 'roleslazyloaded');
		Atul_Cache::getCache()->setToCache($this->username, $this);
	}

	/**
	 * Provide access to set additional properties held within the
	 * _data array
	 */
	public function __set($value, $name)
	{
		$this->_data[$name] = $value;
	}

	/**
	 * Provide access to retrieve additional properties held within the
	 * _data array
	 */
	public function __get($name)
	{
		if (isset ($this->$name)) {
			return $this->$name;
		}
		if (isset($this->_data[$name])){
			return $this->_data[$name];
		}
		return null;
	}
	
	/**
	 * Will retrieve list of roles, optionally retrieving from
	 * active directory if the roles have not already been loaded
	 */
	public function getRoles()
	{
		if (!$this->rolesloaded) {
			$this->loadRoles();
		}
		return $this->_roles;
	}
}
?>