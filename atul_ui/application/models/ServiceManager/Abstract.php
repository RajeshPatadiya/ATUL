<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

abstract class ServiceManager_Abstract
{	

	//Web Service connection instances, keyed by wsdl
	protected static $_webServices = array();

	/** 
	 * Helper function sets up the web service connection, 
	 * returns a new connection if it hasn't already been created
	 */
	protected static function setupWebService($wsdl, $type = ServiceManager::SVC_AUTH_NORMAL, $options = null)
	{
		if (!isset(self::$_webServices[$wsdl]) || self::$_webServices[$wsdl] == NULL) {
			switch($type) {
				case ServiceManager::SVC_AUTH_CALLBACK:
					self::$_webServices[$wsdl] = new CallbackSoapClient($wsdl, $options);
					break;
				case ServiceManager::SVC_AUTH_NTLM:
					$user = $options['user'];
					$pass = $options['pass'];
					self::$_webServices[$wsdl] = new NTLMSoapClient($wsdl, $user, $pass);
					break;
				case ServiceManager::SVC_NTLM_ENDPOINT:
					$config = Zend_Registry::get('config');
					$wsInfo['user_id'] = $config->ntlm->user;
					$wsInfo['password'] = $config->ntlm->pass;
					self::$_webServices[$wsdl] = new NTLMSoapClient($wsdl, $wsInfo['user_id'], $wsInfo['password']);
					break;
				case ServiceManager::SVC_AUTH_NORMAL:
					// fall through
				default:
				self::$_webServices[$wsdl] = new SoapClient($wsdl);
					break;
			}
		} 
		return self::$_webServices[$wsdl];
	}
}
?>