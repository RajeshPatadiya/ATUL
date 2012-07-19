<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class ServiceManager_Atul extends ServiceManager_Abstract {
	/**
	 * 
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
	 * Get a list of config variables by their scriptName
	 * @param unknown_type $scriptName
	 */
	public static function GetConfigVariablesByScriptName($scriptName)
	{
		$api = self::Login();
		$params = array('ScriptName' => $scriptName);
		$result = $api->GetConfigVariablesByScriptName($params); 
		
		if (isset($result['GetConfigVariablesByScriptNameResult'])) {
			$tempObject = Atul_Utility::fancyJsonDecode($result['GetConfigVariablesByScriptNameResult']);
			if(is_object($tempObject)){
				return $tempObject;
			}
		}
		return false;
	}

	/**
	* Get a simple list of config variables by their scriptName
	* @param unknown_type $scriptName
	*/
	public static function GetSimpleConfigVariablesByScriptName($scriptName)
	{
		$temp = self::GetConfigVariablesByScriptName($scriptName);
		$output = array();
		foreach ($temp->atulConfigVars as $var){
			$output[$var->ConfigVariableName] = $var->ConfigVariableValue;
		}
		return $output;
	}
}
