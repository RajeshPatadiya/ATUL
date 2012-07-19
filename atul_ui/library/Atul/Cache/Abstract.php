<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
abstract class Atul_Cache_Abstract 
{
	protected $type = null;
	
	/**
	 * Wrapper method for function which will be used for retrieving
	 * an object from the cache by key 
	 */
	abstract public function getFromCache($item);
	
	/**
	 * Wrapper method for whichever function will be used for adding an
	 * object to the cache
	 */
	abstract public function setToCache($item, $value, $time = null);
	
	/**
	 * Internal method called by constructor to set the type property
	 */
	abstract protected function setType();
	
	/**
	 * Wrapper method to remove an individual object from cache
	 */
	abstract public function unsetFromCache($item);
	
	/**
	 * Wrapper object to verify than an item exists by key in the cache
	 */
	abstract public function exists($item);
	
	/**
	 * Wrapper method to clear the cache
	 */
	abstract public function clear();

	/**
	 * Set the type based on the protected settype method
	 */
	public function __construct()
	{
		$this->setType();
	}
	
	/**
	 * Magic setters to set cached objects as if they were properties
	 * of the cache itself, default value of expiration time
	 * Calls required method setToCache which can also be called directly
	 */
	public function __set($item, $value)
	{
		$this->setToCache($item, $value, 1800);
	}
	
	/**
	 * Magic getter to retrieve cached objects as if they were
	 * properties of the cache itself
	 * Calls required method getFromCache which can also be called directly
	 */
	public function __get($item)
	{
		if ($this->exists($item)) {
			return $this->getFromCache($item);
		} else {
			throw new Exception("Item does not exist in cache.  Check using exists() before calling.");
		}
	}
	
	/**
	 * Magic method unset to allow unset(cache->property)
	 * Calls required method unsetFromCache, which can also be called directly
	 */
	public function __unset($item)
	{
		$this->unsetFromCache($item);
	}
	
	/**
	 * Method to retrieve the type value to identify which caching type is being used
	 */
	public function getType()
	{
		return $this->type;
	}
}
?>