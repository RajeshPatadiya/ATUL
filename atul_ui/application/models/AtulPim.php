<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class AtulPim {

	public static function GetInstanceToolTip($instanceObj, $offset) {

		$instanceTitle = "
			Creator: " . $instanceObj -> Instance -> atultblInstanceProcess -> CreatedByName . "<br/>
			Last ModifiedBy: " . $instanceObj -> Instance -> atultblInstanceProcess -> ModifiedByName . "<br/>
			Last ModifiedDate: " . Atul_Utility::AtulDate($instanceObj -> Instance -> atultblInstanceProcess -> ModifiedDate, true, $offset) . "<br/>
			Owner: " . $instanceObj -> Instance -> atultblInstanceProcess -> OwnedByName . "<br/>
			InstanceID: " . $instanceObj -> Instance -> atultblInstanceProcess -> AtulInstanceProcessID . "<br/>
			ProcessID: " . $instanceObj -> Instance -> atultblInstanceProcess -> AtulProcessID;
		return $instanceTitle;
	}

	public static function GetTimeRemaining($now, $deadline) {
		$unit = "mins.";
		$to_time = strtotime($deadline);
		$from_time = strtotime($now);
		$minTime = round(($to_time - $from_time) / 60, 2);
		if ($minTime > 120) {
			$unit = "hrs.";
			$minTime = round($minTime / 60, 2);
			if ($minTime > 72) {
				$unit = "days";
				$minTime = round($minTime / 24, 2);
			}
		}
		if (0 > $minTime) {
			return '-';
		}
		return $minTime . " " . $unit;
	}

}
?>