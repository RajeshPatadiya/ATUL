<?php
/**
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
	public function __construct($app)
	{
		parent::__construct($app);

		// set up autoloader
		$loader = Zend_Loader_Autoloader::getInstance();
		$loader->registerNamespace('Atul_');
		$loader->setFallbackAutoloader(true);

		// initialize view and setup view helpers
		$this->bootstrap('view');
		$view = $this->getResource('view');
		$view->addHelperPath('views/helpers', 'Atul_View_Helper');

		// set default doctype
		$doctypeHelper = new Zend_View_Helper_Doctype();
		$doctypeHelper->doctype('HTML5');

		// Load configuration
		$env = isset($_SERVER['PLACE_CONFIG']) ?	$_SERVER['PLACE_CONFIG'] : 'dev';
		Zend_Registry::set('environment', $env);
		$config = new Zend_Config_Ini(ROOT_DIR . '/application/config.ini', $env);
		Zend_Registry::set('config', $config);

		// set default timezone for later php versions to shut them up
		date_default_timezone_set($config->date_default_timezone);

		// setup the default cache
		Atul_Cache::setupCache($config->cache->type);
		
		$dboptions = $config->db->toArray();
		
		// set up default database and store
		$db = Zend_Db::factory('Sqlsrv', $dboptions);
		Zend_Db_Table_Abstract::setDefaultAdapter($db);
		Zend_Registry::set('dboptions', $dboptions);
		Zend_Registry::set('db', $db);

		// get user's local offset from UTC (set by common.js)
		if (isset($_COOKIE['UTCOffset'])){
			$UTCOffset = intval($_COOKIE['UTCOffset']);
		} else {
			$UTCOffset = 0;
		}
		Zend_Registry::set('UTCOffset', $UTCOffset);
		
		// auth using ldap
		if (isset($_SERVER['AUTH_USER'])) { // if we're not on command line
			$username = $_SERVER['AUTH_USER'];
			$ldapoptions = $config->ldap->toArray();

			// pull the DNS_SRV records and compose a string with all valid LDAP servers
			$ldap_servers = dns_get_record($ldapoptions['host'], DNS_SRV);

			$ldapoptions['servers'] = implode( ',',array_map(
				function($server) {
					return $server['target'];
				}, $ldap_servers)
			);
			Zend_Registry::set('ldapoptions', $ldapoptions);
			$auth = Atul_Auth_Ldap::getInstance($ldapoptions);
			$authresult = $auth->authenticate($username);
		}

		// include server in footer for debug
		if(isset($_GET['debug']) && $auth->getIdentity()->hasGroup($config->roles->general->debug)) {

			Atul_Debugger::debug($_SERVER['COMPUTERNAME'], 'Server');
		}
	}

}
