<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class Atul_Debugger 
{
	const DEBUG_INFO = 100;
	const DEBUG_SQL = 75;
	const DEBUG_WARNING = 50;
	const DEBUG_ERROR = 25;
	const DEBUG_CRITICAL = 10;
	
	/**
	 * Static method to add messages to the debugging class's storage, can optionally
	 * supply a key as well as debugging level to determine whether the message will 
	 * be displayed if over a certain critical threshold.
	 * @param $data the message to store
	 * @param $key (optional) the key to use to store message
	 * @param $debugLevel the level of importance of the message
	 */
	public static function debug($data, $key = null, $debugLevel = Atul_Debugger::DEBUG_INFO)
	{
		$debugData = new Zend_Session_Namespace('debugData');
		$config = Zend_Registry::get('config');
		if ($debugLevel <= $config->debug->level) {
			$debugData->$key = $data;
		}
		
	}
	
	/**
	 * Wrapper to print the debug data, and then clear the session debug data
	 */
	public static function debugPrint() 
	{
		$debugData = new Zend_Session_Namespace('debugData');
		echo self::printArray($debugData);
		
	}
	
	/**
	 * Method which does the actual printing of the debug data, prints out a table
	 * of data, and if arrays of information are included in any of the messages, will
	 * add sub-tables recursively to keep the organized data structure when displaying
	 * @param $var the variable of information to display, basically $_SESSION['debugData']
	 * @param $title boolean, whether to print the titles of messages
	 * @return string the message data to print
	 */
	public static function printArray($var, $title = true)
	{
		$string = '<table border="1">';
		if ($title) {
			$string .= "<tr><td><strong>Identifier</strong></td>
				<td><strong>Details</strong></td></tr>\n";
		}
			foreach($var as $key => $value) {
				$string .= "<tr><td><strong>$key</strong></td><td>";
				
				if (is_array($value)) {
					$string .= self::printArray($value, false);
				} elseif (gettype($value) == 'object') {
					$string .= "Object of class " . get_class($value);
				} else {
					$string .= "$value";
				}
				$string .= "</td></tr>\n";
				unset($var->$key);
			}
		
		$string .= "</table>\n";
		return $string;
	}
}
?>