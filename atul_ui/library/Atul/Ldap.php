<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class Atul_Ldap
{
	protected $_link = null;
	
	protected $_bound = false;
	
	protected $_entries = null;
	
	protected $_result = null;
	
	protected $_params = null;
	
	/**
	 * Constructor takes an array of parameters to bind to
	 * the Ldap server
	 * 
	 * @param array $params
	 */
	public function __construct($params)
	{
		if ($params != null && is_array($params)) {
			$this->_params = $params;
		} else {
			throw new Exception("Invalid parameters passed to Atul_Ldap");
		}
		
		$this->connect();
	}
	
	/**
	 * Connect to the Ldap server using the parameters passed in
	 * the constructor
	 * 
	 * @return bool whether the connection was successful
	 */
	public function connect()
	{
		$this->_link = ldap_connect($this->_params['servers']);
		return $this->isConnected();
	}
	
	/**
	 * Bind to a particular username and password.  If user and password
	 * aren't supplied, will attempt to use user and password supplied in 
	 * constructor parameters
	 * 
	 * @param string $username
	 * @param string $password
	 * @return bool whether binding was successful
	 */
	public function bind($username = null, $password = null)
	{		
		if ($username== null) {
			$username = $this->_params['username'];
		} 
		if ($password == null) {
			$password = $this->_params['password'];
		}
		$this->_bound = @ldap_bind($this->_link, $username, $password);
		return $this->isBound();
	}
	
	/**
	 * Search given the dn, filter and attributes.  If dn isn't provided, will
	 * use default from contructor parameters
	 * 
	 * @param $dn the dn to bind against.
	 * @param $filter the search filter
	 * @param $attributes the desired attributes to return
	 * @param $attrsOnly whether to get attrs, values, or both, default 0 means both
	 * @param $sizeLimit number to limit results to, default 0 means no limit
	 * @param $timeLimit timeout limit on search, default 0 means no limit
	 * @param $deref whether to dereference ldap aliases.  Overriding PHP default to always dereference
	 * @return ldap result
	 */
	public function search($dn = null, $filter = null, $attributes = null, $attrsOnly = 0, $sizeLimit = 0, $timeLimit = 0, $deref = LDAP_DEREF_ALWAYS)
	{
		if ($dn == null) {
			$dn = $this->_params['baseDn'];
		}
		if ($this->_result != null) {
			ldap_free_result($this->_result);
		}
		$this->_result = ldap_search($this->_link, $dn, $filter, $attributes, $attrsOnly, $sizeLimit, $timeLimit);
		return $this->_result;
	}
	
	/**
	 * Compare the DN value of a particular attribute against a passed value
	 * 
	 * @param $dn the dn to bind against.
	 * @param $attribute the attribute to compare values with
	 * @param $value the value to compare against
	 * @return bool whether the value matched the attribute
	 */
	public function compare($dn, $attribute, $value)
	{
		if ($dn == null) {
			$dn = $this->_params['baseDn'];
		}
		return ldap_compare($this->_link, $dn, $attribute, $value);
	}
	
	/**
	 * close the ldap connection, setting the isbound property to false.
	 * 
	 */
	public function close()
	{
		if (is_resource($this->_link)) {
			$this->_bound = ldap_unbind($this->_link);
		}
		return !$this->isBound();
	}
	
	/**
	 * Retrieve a list of entries from the ldap search result
	 * 
	 * @return array $entries
	 */
	public function getEntries()
	{
		if ($this->_entries == null) {
			$this->_entries = ldap_get_entries($this->_link, $this->_result);
		}
		return $this->_entries;
	}
	
	/**
	 * Destructor calls the close method to close out the connection
	 */
	public function __destruct()
	{
		$this->close();
	}
	
	/**
	 * Return a boolean to determine whether the server was successfully connected
	 * 
	 * @return bool whether the server is connected
	 */
	public function isConnected()
	{
		if (is_resource($this->_link)) {
			return true;
		}
		return false;
	}
	
	/**
	 * Return a boolean to determine whether the server was successfully bound
	 * 
	 * @return bool whether the server is bound
	 */
	public function isBound()
	{
		return $this->_bound;
	}
	
	public function freeResult()
	{
		ldap_free_result($this->_result);
	}
}
?>