<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class Atul_Cache 
{
	/** Cache object holds the instance of whichever Cache_Abstract child we use */
	protected static $_cache = null;
	
	/**
	 * Factory method creates the cache of whichever supported type is requested
	 */
	public static function setupCache($type)
	{
		$type = 'Atul_Cache_'.$type; // prepend our namespace
		// if type exists and extends Cache_Abstract
		if (class_exists($type) && is_subclass_of($type, 'Atul_Cache_Abstract')) {
			self::$_cache = new $type();
		} else {
			throw new Exception($type.' is not a valid cache type');
		}
	}
	
	/**
	 * Return the previously created instance of cache object 
	 */
	public static function getCache()
	{
		if (self::$_cache != null) {
			return self::$_cache;
		} else {
			throw new Exception("Cache has not been set up");
		}
	}
}
?>