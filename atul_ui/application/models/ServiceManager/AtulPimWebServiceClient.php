<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class ServiceManager_AtulPimWebServiceClient extends ServiceManager_Abstract {

	/**
	 * Call web service method to complete a checklist step
	 */

	private static function Login() {
		// Set up connection to Web Service
		$config = Zend_Registry::get('config');
		$wsdl = $config -> atulapi -> wsdl;
		// get wsdl from config or somewhere
		$soapOptions = array('user' => $config -> ldap -> user, 'pass' => $config -> ldap -> password);
		return self::setupWebService($wsdl, ServiceManager::SVC_AUTH_NTLM, $soapOptions);
		// this service is NTLM authenticated

	}

	public static function GetInstanceDetail($AtulInstanceProcessID) {
		$api = self::Login();
		$params = array('AtulInstanceProcessID' => $AtulInstanceProcessID);

		$result = $api -> GetInstanceDetail($params);
		if (isset($result['GetInstanceDetailResult'])) {
			//var_dump($result['GetInstanceDetailResult']);
			return json_decode(utf8_decode($result['GetInstanceDetailResult']));
		}
		return false;
	}

	public static function InstanceProcessActivityComplete($AtulInstanceProcessActivityID, $statusBit, $ModifiedBy = 1) {
		$api = self::Login();
		$params = array('AtulInstanceProcessActivityID' => $AtulInstanceProcessActivityID, 'statusBit' => $statusBit, 'ModifiedBy' => $ModifiedBy);
		$result = $api -> InstanceProcessActivityComplete($params);
		//return $AtulInstanceProcessID;
		if ($result) {
			return json_decode($result['InstanceProcessActivityCompleteResult']);
		}
		return false;
	}

	public static function UpdateInstanceOwner($instanceId, $newOwner, $modifiedBy) {
		if ($instance = self::GetInstanceDetail($instanceId)) {
			if (isset($instance -> Instance -> atultblInstanceProcess)) {
				$i = $instance -> Instance -> atultblInstanceProcess;

				$sum = null;
				if (isset($i -> SubjectSummary)) {
					$sum = $i -> SubjectSummary;
				}
				$identifier = null;
				if (isset($i -> SubjectIdentifier)) {
					$identifier = $i -> SubjectIdentifier;
				}
				$id = '';
				if (isset($i -> SubjectServiceProviderID)) {
					$id = $i -> SubjectServiceProviderID;
				}
				return ServiceManager_AtulWebServiceClient::UpdateInstanceProcess($i -> AtulInstanceProcessID, $i -> AtulProcessID, $modifiedBy, $newOwner, $i -> AtulProcessStatusID, $identifier, $sum, $id);
			}
		}
		return false;
	}

}
