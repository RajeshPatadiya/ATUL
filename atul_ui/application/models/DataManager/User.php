<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class DataManager_User extends DataManager_Abstract
{
	protected static $_groups;
	protected static $_groupsloaded = false;
	protected static $_users;
	
	public static function GetUserByLogin($username)
	{
		self::setupDatabase();
		$config = Zend_Registry::get('config');
		$query = "exec dbo.Atul_UserGetByLogin_sp ?, ?";
		$statement = self::$_connection->prepare($query);
		$params = array($username, $config->user->remotesystemid);
		$statement->execute($params);
		if ($userinfo = $statement->fetch(PDO::FETCH_ASSOC)) {
			return $userinfo;
		}
		return false;
	}
	
	public static function GetAllGroups()
	{
		if (self::$_groupsloaded == false) {
			self::GetAllUsers();
			self::setupDatabase();
			$query = "exec dbo.Atul_CASDGroupGetAll_sp";
			$statement = self::$_connection->prepare($query);
			$statement->execute(array());
			if ($result = $statement->fetchAll(PDO::FETCH_ASSOC)) {
				//fields: [GroupID][GroupName][GroupEmail][SupNTLoginID][SupFirstName][SupMiddleName][SupLastName]
				foreach ($result as $item) {
					if (!isset(self::$_groups[$item['GroupID']])) {
						if (self::AddUser(2, $item['GroupID'], 2, $item['GroupName'], $item['GroupEmail'])) {
							self::$_groups[$item['GroupID']] = self::GetUserByLogin($item['GroupName']);
						}
					} else {
						self::$_groups[$item['GroupID']]['SupNTLoginID'] = $item['SupNTLoginID'];
						self::$_groups[$item['GroupID']]['SupLastName'] = $item['SupLastName'];
						self::$_groups[$item['GroupID']]['SupFirstName'] = $item['SupFirstName'];
					}
				}
			}
			self::$_groupsloaded = true;
		}
		uasort(self::$_groups, function($a, $b) { return strcasecmp($a['DisplayName'], $b['DisplayName']); });
		return self::$_groups;
	}
	
	public static function GetUsersInGroup($group) 
	{
		self::setupDatabase();
		$groupUsers = array();
		$query = "exec dbo.Atul_CASDGroupMemberGetByGroupName_sp ?";
		$statement = self::$_connection->prepare($query);
		$params = array($group);
		$statement->execute($params);
		if ($result = $statement->fetchAll(PDO::FETCH_ASSOC)) {
			foreach ($result as $item) {
				$groupUsers[] = self::GetUserByLogin(strtolower($item['NTLoginID']));
			}
		}
		return $groupUsers;
	}
	
	public static function GetUsersInGroupList($groupList)
	{
		self::setupDatabase();
		$users = array();
		
		foreach ($groupList as $group) {
			$groupUsers = self::GetUsersInGroup($group);
			 
			foreach($groupUsers as $user) {
				
				if (!isset($users[strtolower($user['RemoteSystemLoginID'])])) {
					$users[strtolower($user['RemoteSystemLoginID'])] = $user;
				}
			}
		}
		return $users;
	}
	
	public static function GetGroupsForUser($user)
	{
		self::setupDatabase();
		self::GetAllGroups();
		$query = "exec dbo.Atul_CASDGroupMembershipGetByADID_sp ?";
		$statement = self::$_connection->prepare($query);
		$params = array($user);
		$statement->execute($params);
		$userGroups = array();
		if ($result = $statement->fetchAll(PDO::FETCH_ASSOC)) {
			foreach ($result as $item) {
				$userGroups[$item['GroupID']] = self::$_groups[$item['GroupID']];
			}
		}
		return $userGroups;
	}
	
	public static function GetAllUsers()
	{
		if (self::$_users == null) {
			self::$_users = array();
			self::$_groups = array();
			self::setupDatabase();
			$query = "exec dbo.Atul_UserGet_sp";
			$statement = self::$_connection->prepare($query);
			$statement->execute(array());
			if ($result = $statement->fetchAll(PDO::FETCH_ASSOC)) {
				foreach ($result as $item) {
					if (strtolower($item['UserTypeName']) == 'user') {
						self::$_users[$item['RemoteSystemLoginID']] = $item;
					} elseif (strtolower($item['UserTypeName']) == 'group') {
						self::$_groups[$item['RemoteSystemLoginID']] = $item;
					}
				}
			}
		}
		ksort(self::$_users); //uasort(self::$_users, function($a, $b) { return strcasecmp($a['DisplayName'], $b['DisplayName']); });
		uasort(self::$_groups, function($a, $b) { return strcasecmp($a['DisplayName'], $b['DisplayName']); });
		return self::$_users;
	}
	
	public static function AddUser($remoteSystemID, $remoteSystemLoginID, $type, $displayName, $email = null)
	{
		self::setupDatabase();
		$query = "exec dbo.Atul_UserInsert_sp ?, ?, ?, ?, ?";
		$statement = self::$_connection->prepare($query);
		$params = array($remoteSystemID, $type, $remoteSystemLoginID, $displayName, $email);
		if ($statement->execute($params)) {
			return true;
		} 
		return false;
		
	}
}
?>