<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class Scheduler
{
	private $_days;
	private $_startDate;
	private $_repeat;
	private $_times;
	private $_interval;
	private $_serial;
	private $_cron;
	private $_dayLookup;
	
	public function __construct($startDate = null, $times = null, $repeat = null, $days = null, $interval = null, $timeZone = null)
	{
		$this->_days = $days;
		if ($startDate != null) 
			$this->_startDate = New DateTime($startDate.' '.$times[0]);
		$this->_repeat = $repeat;
		$this->_times = array();
		if ($times != null) {
			foreach ($times as $time) {
				$split = explode(' ', $time);
				$am_pm = $split[1];
				$timeparts = explode(':', $split[0]);
				$hours = $timeparts[0];
				$minutes = $timeparts[1];
				if ($am_pm == 'pm' && $hours != 12) {
					$hours += 12;
				} elseif ($am_pm == 'am' && $hours == 12) {
					$hours = 0;
				}
				$t = array('hours' => $hours, 'minutes' => $minutes);
				$this->_times[] = $t;
			}
		}
		$this->_interval = $interval;
		$this->_dayLookup = array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
			'Friday', 'Saturday');
	}
	
	/**
	 * Get the start date in whichever format specified
	 * @param string $format
	 */
	public function getStartDate($format)
	{
		return $this->_startDate->format($format);
	}
	
	/**
	 * Will create a 'cron-inspired' string representing repeat timestamps.
	 * Since Cron has no facility for exact timesets eg: 2:15, 3:25 and 7:42...nor does
	 * Cron have facilities for actual bi-weekly or x-weekly/x-monthly repetition, I have
	 * created extensions to standard Cron (not extended Cron as we don't need to worry about year).
	 * ([0 0],[0 0]) 0 0 0 0 0 - where minute and hour have been combined into timesets each marked by
	 * braces and separated from the rest of the cron string by parentheses for easy parsing.  The
	 * rest of the columns are as follows: Day of the Month, Month of the Year, Day of the Week... and
	 * the last two collumns are the number of weeks to skip between and the number of months to skip,
	 * respectively.  Since we will have different specific use cases some of these will be exclusive.  For 
	 * example, number of weeks and number of months to skip will never be used together. 
	 * 
	 * Example string: ([3 30],[5 22]) 1 * * 0 2  -  this will run at 3:30 and 5:22 on the first
	 * 					of the month, skipping 2 months in between.
	 * Example 2     : ([12 00]) * * 1,2,3 3 0    -  this will run at noon on Monday, Tuesday and
	 * 					Wednesday, every three weeks
	 */
	public function getCronSchedule()
	{
		$cstr = "";
		switch ($this->_repeat) {
			case 'daily':
				$cstr = '(';
				$tx = array();
				foreach ($this->_times as $t) {
					$tx[] = '['.$t['minutes'].' '.$t['hours'].']';
				}
				$cstr .= implode(',', $tx);
				$cstr .= ') * * 1,2,3,4,5 0 0';
				break;
			case 'weekly':
				$cstr = '(';
				$tx = array();
				foreach ($this->_times as $t) {
					$tx[] = '['.$t['minutes'].' '.$t['hours'].']';
				}
				$cstr .= implode(',', $tx);
				$cstr .= ') * * '.$this->_startDate->format('w').' 0 0';
				break;
			case 'biweekly':
				$cstr = '(';
				$tx = array();
				foreach ($this->_times as $t) {
					$tx[] = '['.$t['minutes'].' '.$t['hours'].']';
				}
				$cstr .= implode(',', $tx);
				$cstr .= ') * * '.$this->_startDate->format('w'). ' 1 0';
				break;
			case 'days':
				$cstr = '(';
				$tx = array();
				foreach ($this->_times as $t) {
					$tx[] = '['.$t['minutes'].' '.$t['hours'].']';
				}
				$cstr .= implode(',', $tx);
				$cstr .= ') * * ';
				$cstr .= implode(',', $this->_days).' 0 0';
				break;
			case 'dates':
				$cstr = '(';
				$tx = array();
				foreach ($this->_times as $t) {
					$tx[] = '['.$t['minutes'].' '.$t['hours'].']';
				}
				$cstr .= implode(',', $tx);
				$cstr .= ') ';
				$cstr .= implode(',', $this->_days);
				$cstr .= ' * * 0 0'; 
				break;
			case 'xweeks':
				$cstr = '(';
				$tx = array();
				foreach ($this->_times as $t) {
					$tx[] = '['.$t['minutes'].' '.$t['hours'].']';
				}
				$cstr .= implode(',', $tx);
				$cstr .= ') * * '.$this->_startDate->format('w'). ' '.($this->_interval - 1).' 0';
				break;
			case 'xmonths':
				$cstr = '(';
				$tx = array();
				foreach ($this->_times as $t) {
					$tx[] = '['.$t['minutes'].' '.$t['hours'].']';
				}
				$cstr .= implode(',', $tx);
				$cstr .= ') '.$this->_startDate->format('j').' * * 0 '.($this->_interval - 1);
				break;
			default:
				break;
		}
		return $cstr;
	}
	
	public function loadCronSchedule($cron)
	{
		$this->_cron = $cron;
	}
	
	public function getScheduleText()
	{
		$this->parseCron();
		$scheduleStr = 'Scheduled to repeat ';
		switch($this->_repeat) {
			case 'xmonths':
				$scheduleStr .= 'every '.$this->_interval.' months';
				break;
			case 'xweeks':
				$scheduleStr .= 'every '.$this->_interval.' weeks';
				break;
			case 'dates':
				$scheduleStr .= 'each month on the '.implode(', ', $this->_days).' of the month';
				break;
			case 'weekly':
				$scheduleStr .= 'weekly on '.$this->_dayLookup[$this->_days[0]];
				break;
			case 'days':
				$d = array();
				foreach ($this->_days as $day) {
					$d[] = $this->_dayLookup[$day];
				}
				$scheduleStr .= 'on '.implode(', ', $d);
				break;
			case 'daily':
				$scheduleStr .= 'weekdays';
				break;
			case 'none':
				return "";
				break;
		}
		$t = array();
		foreach ($this->_times as $time) {
			$t[] = Scheduler::parseTime($time);
		}
		$scheduleStr .= ' at '.implode(', ', $t);
		return $scheduleStr;
	}
	
	public static function parseTime($t)
	{
		if ($t['hours'] < 12) {
			if ($t['hours'] == 0) {
				return '12:'.$t['minutes'].' am';
			} else {
				return $t['hours'].':'.$t['minutes'].' am';
			}
		} else {
			if ($t['hours'] == 12) {
				return $t['hours'].':'.$t['minutes'].' pm';
			} else {
				$tx = $t['hours'] - 12;
				return $tx.':'.$t['minutes'].' pm';
			}
		}
	}
	
	public function parseCron()
	{
		if ($this->_cron != "" && $this->_cron != null) {
			$parts = explode(')', $this->_cron);
			$timeStrings = trim($parts[0],'(');
			$timeSets = explode(',', $timeStrings);
			$this->_times = array();
			foreach($timeSets as $t) {
				$t = trim($t, '[]');
				$tx = explode(' ', $t);
				$time = array('hours' => $tx[1], 'minutes' => $tx[0]);
				$this->_times[] = $time;
			}
			$scheduleParts = explode(' ', trim($parts[1]));
			if ($scheduleParts[4] != 0) {
				$this->_repeat = 'xmonths';
				$this->_interval = $scheduleParts[4] + 1;
				$this->_days = explode(',',$scheduleParts[2]);
			} elseif ($scheduleParts[3] != 0) {
				$this->_repeat = 'xweeks';
				$this->_interval = $scheduleParts[3] + 1;
				$this->_days = explode(',', $scheduleParts[2]);
			} elseif ($scheduleParts[0] != '*') {
				$this->_repeat = 'dates';
				$this->_days = explode(',', $scheduleParts[0]);
			} elseif ($scheduleParts[2] != '*') {
				$this->_days = explode(',', $scheduleParts[2]);
				if (count($this->_days) == 1) {
					$this->_repeat = 'weekly';
				} elseif (count($this->_days) == 5 && !in_array(0, $this->_days) && !in_array(6, $this->_days)) {
					$this->_repeat = 'daily';	
				} else { 
					$this->_repeat = 'days';
				}
			}
		} else {
			$this->_repeat = 'none';
		}
	}
	
	public static function parseDate($str)
	{
		$d = new DateTime($str);
		return $d->format('m-d-Y g:i a');
	}
	
	public function getSerial($userId)
	{
		if ($this->_serial == null) {
			$this->_serial = $this->generateSerial($userId);
		}
		return $this->_serial;
	}
	
	public function generateSerial($userId)
	{
		return $userId.'-'.time().'-'.mt_rand().'-'.substr($_SERVER['SERVER_NAME'], -2);
	}
	
	public function getTime($i)
	{
		return $this->_times[$i]['hours'].':'.$this->_times[$i]['minutes'];
	}
	
}
?>