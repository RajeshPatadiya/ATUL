<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class Atul_Auth_Ldap implements Atul_Auth_Interface
{
	protected static $_instance = null;

	protected $_storage = null;

	protected $_params = null;

	protected $_ldap = null;

	/**
	 * Constructor takes an array of parameters
	 *
	 * @param unknown_type $params
	 * @return unknown_type
	 */
	public function __construct($params)
	{
		if (is_array($params)) {
			$this->_params = $params;
		} else {
			throw new Exception("Invalid Parameters passed to Atul_Auth");
		}
	}

	/**
	 * Allow singelton-like handling of a single instance to save memory.  Passes
	 * parameters to constructor. Not required.
	 *
	 * @param $params an array of parameters
	 * @return Atul_Auth_Ldap an instance of self
	 */
	public static function getInstance($params)
	{
		if (null === self::$_instance) {
			self::$_instance = new self($params);
		}

		return self::$_instance;
	}

	/**
	 * Retrieve username info to set default user object with proper
	 * group permissions and identification properties
	 *
	 * @param string $username
	 */
	public function authenticate($username = null)
	{
		$config = Zend_Registry::get('config');
		if($username == null) {
			$username = $this->username;
		}

		Atul_Debugger::debug($username, 'username');

		if (Atul_Cache::getCache()->exists($username)) {
			$user = Atul_Cache::getCache()->$username;
			if (isset($_GET['debug'])) {
				Atul_Debugger::debug("Yes", "Cached User");
			}
		} else {
			$dn = $this->_params['baseDn'];
			$attributes = array('displayname', 'samaccountname', 'distinguishedname');
				
			$this->setupLdap();

			// Call Atul_Ldap class's wrapping methods to handle the binding and searching
			if($this->_ldap->bind($this->_params['accountDomainNameShort'].'\\'.$this->_params['user'], $this->_params['password'])) {
				try {
					@$this->_ldap->search($dn, "(samaccountname=$username)", $attributes, false);
				}
				catch (Exception $e) {
					return false;
				}

				if (@$entries = $this->_ldap->getEntries()) {
					$properties = array();
					$groups = array();
					if (count($entries) > 0) {
						@$properties['name'] = $entries[0]['displayname'][0];
						$properties['username'] = $username;
						@$properties['distinguishedName'] = $entries[0]['distinguishedname'][0];
						$userid = 0;
						$userinfo = DataManager_User::GetUserByLogin($properties['username']);
						if (isset($userinfo) && $userinfo != null) {
							foreach ($userinfo as $key => $value) {
								$properties[$key] = $value;
							}
							$properties['UserID'] = $properties['AtulUserID'];
						}
						
						// create default user object
						@$user = new Atul_User($properties['UserID'], $properties);

						if ($username != null && trim($username) != '') {
							Atul_Cache::getCache()->setToCache($username, $user, $config->cache->length);
						}
						if (isset($_GET['debug'])) {
							Atul_Debugger::debug("No", "Cached User");
						}
					}
				} else {
					return false;
				}
			}
		}
		if (isset($_GET['debug'])) {
			Atul_Debugger::debug($user->getRoles(), "User Roles");
		}

		// save user object in storage for easy retrieval and use anywhere in the script
		$this->getStorage()->write($user);

		return true;

	}

	/**
	 * Retrieve the list of groups to which a person belongs from active directory.
	 */
	public function getGroups($distinguishedName)
	{
		$groups = array();
		$dn = $this->_params['baseDn'];
		$attributes = array('samaccountname');
		$this->setupLdap();
		if ($this->_ldap->isBound()) {
			$this->_ldap->close();
		}
		$ldap = new Atul_Ldap($this->_params);
		// Call Atul_Ldap class's wrapping methods to handle the binding and searching
		if($ldap->bind($this->_params['accountDomainNameShort'].'\\'.$this->_params['username'], $this->_params['password'])) {
			try {
				/* the number string after member: is a search modifier for active directory
				 LDAP_MATCHING_RULE_IN_CHAIN which looks at the ancestry of the object up to the document
				 root.  In this case flattening the hierarchy for us to get recursive list of groups */
				@$ldap->search($dn, "(member:1.2.840.113556.1.4.1941:=$distinguishedName)", $attributes);
			}
			catch (Exception $e) {
				return false;
			}
			if (@$entries = $ldap->getEntries()) {
				foreach ($entries as $entry) {
					if ($entry['samaccountname'][0] != null && $entry['samaccountname'][0] != "") {
						$parts = explode(',', $entry['dn'], 2);				
						$groups[] = $entry['samaccountname'][0];						
					}
				}
			}
		}
		return $groups;
	}

	/**
	 * Helper function to setup the Ldap connection using the Atul_Ldap wrapper
	 * passing along the parameters used in construction.  Sets the class ldap handler if
	 * not already set and also returns the ldap handler for immediate use
	 *
	 * @return Atul_Ldap the Ldap wrapper for immediate use
	 *
	 */
	public function setupLdap()
	{
		if ($this->_ldap == null) {
			$this->_ldap = new Atul_Ldap($this->_params);
		}
		return $this->_ldap;
	}

	public function hasIdentity()
	{
		return !$this->getStorage()->isEmpty();
	}

	/**
	 * Returns the identity from storage or null if no identity is available
	 *
	 * @return mixed|null
	 */
	public function getIdentity()
	{
		$storage = $this->getStorage();

		if ($storage->isEmpty()) {
			return null;
		}

		return $storage->read();
	}

	/**
	 * Clears the identity from persistent storage
	 *
	 * @return void
	 */
	public function clearIdentity()
	{
		$this->getStorage()->clear();
	}

	/**
	 * Returns the persistent storage handler
	 *
	 * Session storage is used by default unless a different storage adapter has been set.
	 *
	 * @return Zend_Auth_Storage_Interface
	 */
	public function getStorage()
	{
		if (null === $this->_storage) {
			/**
			 * @see Zend_Auth_Storage_Session
			 */
			require_once 'Zend/Auth/Storage/Session.php';
			 
			$this->setStorage(new Zend_Auth_Storage_Session());


		}

		return $this->_storage;
	}

	/**
	 * Sets the persistent storage handler
	 *
	 * @param  Zend_Auth_Storage_Interface $storage
	 * @return Zend_Auth Provides a fluent interface
	 */
	public function setStorage(Zend_Auth_Storage_Interface $storage)
	{
		$this->_storage = $storage;
		return $this;
	}
}
?>