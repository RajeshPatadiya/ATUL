<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
class Atul_Utility {

	/** Takes a comma, space, tab, CRLF, or newline-separated list and returns
	/* a cleaned-up comma-separated list.  Can also take an array of other delimiters,
	/* rather than the default list above (except comma).
	 *
	 */
	public static function listToArray($string, $delimiters = array("\r\n","\n","\t"," ")) {
		foreach ($delimiters as $delimiter) {
			$string = str_replace($delimiter, ",", $string);
		}
		$temparray = split(',', $string);
		foreach ($temparray as $key => $value) {
			$value = trim($value);
			if ($value != '') {
				$result[] = $value;
			}
		}
		return ($result);
	}

	/** returns a short format, sortable date with optional 24 hour time, given any date which php
	/* can interpret using strtotime.
	 *
	 */
	public static function AtulDate($date, $withTime = false, $UTCOffset = 0) {
		$date = preg_replace("[\..*$]", '', $date);
		if ($date != '') {
			$date = strtotime($date) - ($UTCOffset * 3600);
			// 3600 is the number of seconds in an hour
			if ($withTime) {
				$date = strftime("%Y/%m/%d %I:%M:%S %p", $date);
			} else {
				$date = strftime("%Y/%m/%d", $date);
			}
		}
		return $date;
	}

	/**
	 * Check to see if a value is null or an empty string of text
	 *
	 */
	public static function isNullOrEmpty($value) {
		if (trim($value) == '' || $value === null) {
			return true;
		}
		return false;
	}

	/**
	 * Parse an array (as returned by an auto-interpreting soap client) back into
	 * proper Soap-formatted XML
	 */
	public static function arrayToSimpleXML($data, $rootNodeName = 'data', $xml = null) {
		// turn off compatibility mode as simple xml throws a wobbly if you don't.
		if (ini_get('zend.ze1_compatibility_mode') == 1) {
			ini_set('zend.ze1_compatibility_mode', 0);
		}

		if ($xml == null) {
			$xml = simplexml_load_string("<?xml version='1.0' encoding='utf-8'?><$rootNodeName />");
		}

		// loop through the data passed in.
		foreach ($data as $key => $value) {
			// replace anything not alpha numeric
			$key = preg_replace('/[^a-z]/i', '', $key);

			// if there is another array found recrusively call this function
			if (is_array($value)) {
				if (self::isArrayAssociative($value)) {
					$node = $xml -> addChild($key);
					// recursive call.
					self::arrayToSimpleXML($value, $rootNodeName, $node);
				} else {
					foreach ($value as $repeatNode) {
						$node = $xml -> addChild($key);
						// recursive call.
						self::arrayToSimpleXML($repeatNode, $rootNodeName, $node);
					}
				}
			} else {
				// add single node.
				$value = htmlentities($value);
				$xml -> addChild($key, $value);
			}

		}
		return $xml;
	}
	/**
	* Return an empty string if the parameter is not set, or the parameter if it is
	*
	*/
	public static function indexNotSetEmptyString($array, $index)
	{
		if (!isset($array[$index])){
			return '';
		}
		return $array[$index];
	}
	/**
	 * Check to see if an array is associative by verifying its keys
	 *
	 */
	public static function isArrayAssociative($arr) {
    	return array_keys($arr) !== range(0, count($arr) - 1);
	}

	/**
	 * convert any line terminators to html breaks, utf8_decode, and json_decode a string and return the object/array
	 *
	 */
	public static function fancyJsonDecode($json) {
		return json_decode(utf8_decode(str_replace(array("\r", "\r\n", "\n"), '<br>', $json)));
	}

	public static function startsWith($haystack, $needle) {
		$length = strlen($needle);
		return (substr($haystack, 0, $length) === $needle);
	}

	public static function setIfNotSet($array, $index, $value){
		if (!isset($array[$index])){
			$array[$index] = $value;
		}
		return $array;
	}
}
?>
