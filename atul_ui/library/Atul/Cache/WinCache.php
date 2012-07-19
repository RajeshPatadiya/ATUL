<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class Atul_Cache_WinCache extends Atul_Cache_Abstract
{
	/**
	 * Required method to add an item to the object cache, with 
	 * optional expiration time
	 */
	public function setToCache($item, $value, $time = null)
	{
		try {
			@wincache_ucache_set($item, $value, $time);
		} catch (Exception $e) {
			$message = "Key: ".$item.", value: ".print_r($value).".\n";
			$message .= $e->getMessage();
		}
	}
	
	/**
	 * Required method to retrieve an object from cache
	 */
	public function getFromCache($item)
	{
		return wincache_ucache_get($item);
	}
	
	/**
	 * Required method to check if an item exists in the cache by key
	 */
	public function exists($item)
	{
		return wincache_ucache_exists($item);
	}
	
	/**
	 * Required method called internally to set the type property
	 */
	protected function setType()
	{
		$this->type = "WinCache";
	}
	
	/**
	 * Required method to clear the entire cache
	 */
	public function clear()
	{
		wincache_ucache_clear();
	}
	
	/**
	 * Required method to remove an individual item from the cache
	 */
	public function unsetFromCache($item)
	{
		wincache_ucache_delete($item);
	}
}
?>