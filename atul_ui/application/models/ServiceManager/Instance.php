<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class ServiceManager_Instance extends ServiceManager_Abstract {
	/**
	 * Call web service method to complete a checklist step
	 */

	private static function Login() {
		// Set up connection to Web Service
		$config = Zend_Registry::get('config');
		$wsdl = $config->atulapi->wsdl;
		// get wsdl from config or somewhere
		$soapOptions = array('user' => $config -> ldap -> user, 'pass' => $config -> ldap -> password);
		return self::setupWebService($wsdl, ServiceManager::SVC_AUTH_NTLM, $soapOptions);
		// this service is NTLM authenticated

	}

	
	/**
	 * Get a list of Instances by their ProcessID
	 * @param unknown_type $processID
	 */
	public static function GetInstanceProcessByProcessID($processId)
	{
		$api = self::Login();
		$params = array('AtulProcessID' => $processId);
		$result = $api->GetInstanceProcessByProcessID($params); 

		if (isset($result['GetInstanceProcessByProcessIDResult'])) {
			$tempObject = Atul_Utility::fancyJsonDecode($result['GetInstanceProcessByProcessIDResult']);
			if(is_object($tempObject)){
				return $tempObject->atultblInstanceProcess;
			}
		}
		return false;
	}
	public static function GetCurrentInstanceSubProcess($AtulInstanceProcessID)
	{
		$api = self::Login();
		$params = array('AtulInstanceProcessID' => $AtulInstanceProcessID);
		$result = $api->GetCurrentInstanceSubProcess($params);

		if (isset($result['GetCurrentInstanceSubProcessResult'])) {
			$tempObject = Atul_Utility::fancyJsonDecode($result['GetCurrentInstanceSubProcessResult']);
			if(is_object($tempObject)){
				return $tempObject->atulinstanceSubProcess;
			}
		}
		return false;
	}
	public static function GetDeletedInstances($daysBack)
	{
		$api = self::Login();
		$params = array('daysBack' => $daysBack);
		$result = $api->InstanceProcessGetDeleted($params);
		$instances = new Atul_Collection();
		if ($result) {
			if ($result['InstanceProcessGetDeletedResult'] != '' && $result['InstanceProcessGetDeletedResult'] != null) {
				if (isset($result['InstanceProcessGetDeletedResult']['ProcessInstance'][0])) {
					$l = $result['InstanceProcessGetDeletedResult']['ProcessInstance'];
				} else {
					$l = array();
					$l[] = $result['InstanceProcessGetDeletedResult']['ProcessInstance'];
				}
				foreach($l as $item) {
					$p = $instances->makeChild($item['AtulProcessID'], 'Atul_Collection', array('ProcessSummary' => $item['ProcessSummary'], 'AtulProcessID' => $item['AtulProcessID']));
					$i = new Atul_MagicObject($item);
					$p->addItem($i, $item['AtulInstanceProcessID']);
				}
			}
			return $instances;
		}
		return false;
	}
	
	public static function UndeleteInstance($instanceId, $user)
	{
	$api = self::Login();
		$params = array('InstanceID' => $instanceId, 'ModifiedBy' => $user);
		$result = $api->UndeleteInstanceProcess($params);
		if ($result) {
			return $result['UndeleteInstanceProcessResult'];
		}
	}

}
