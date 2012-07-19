<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
require_once('nusoap/lib/nusoap.php');

class NTLMSoapClient {

	private $wsdl;
	private $client;
	private $service;
	
	public function __construct($url, $user, $pass) 
	{
		$this->wsdl = $url;
		$this->client = new nusoap_client($this->wsdl, true);
		$err = $this->client->getError();
		if ($err) {
			$message = "Error connecting to SoapClient:\n".$err;
			throw new Exception($message);
		}
		//$this->client->setCredentials('', '', 'ntlm');		
		$this->client->setUseCurl(true);	
		$this->client->useHTTPPersistentConnection();
		$this->client->setCurlOption(CURLOPT_HTTPAUTH, CURLAUTH_ANY);
		$this->client->setCurlOption(CURLOPT_USERPWD, "$user:$pass");
		$this->client->setCurlOption(CURLOPT_CONNECTTIMEOUT, ini_get('max_execution_time'));
		
		$this->service = $this->client->getProxy();
		if (!is_object($this->service)) {
			die("Fatal Error: cannot get proxy for WS Client - ".$url);
		}
		$this->service->timeout = ini_get('max_execution_time');
		$this->service->response_timeout = ini_get('max_execution_time');
	}
	
	public function __call($method, $args) 
	{
		return $this->service->$method($args[0]);
		return $this->client->call($method, $args);
	}
}

?>