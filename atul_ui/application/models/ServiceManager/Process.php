<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class ServiceManager_Process extends ServiceManager_Abstract {
	/**
	 * Call web service method to complete a checklist step
	 */

	private static function Login() {
		// Set up connection to Web Service
		$config = Zend_Registry::get('config');
		$wsdl = $config -> atulapi -> wsdl;
		// get wsdl from config or somewhere
		$soapOptions = array('user' => $config -> ldap -> user, 'pass' => $config -> ldap -> password);
		return self::setupWebService($wsdl, ServiceManager::SVC_AUTH_NTLM, $soapOptions);
		// this service is NTLM authenticated

	}

	/**
	 *
	 * Create a new Activity for Process Definition
	 * @param unknown_type $processID
	 * @param unknown_type $subProcessID
	 * @param unknown_type $ActivityDescription
	 * @param unknown_type $ActivitySummary
	 * @param unknown_type $ActivityProcedure
	 * @param unknown_type $deadlineResultsInMissed
	 * @param unknown_type $AtulActivitySortOrder
	 * @param unknown_type $CreatedBy
	 * @param unknown_type $OwnedBy
	 * @param unknown_type $deadline
	 * @param unknown_type $deadlineTypeID
	 */
	public static function CreateActivity($processID, $subProcessID, $ActivityDescription, $ActivitySummary, $ActivityProcedure, $deadlineResultsInMissed, $AtulActivitySortOrder, $CreatedBy, $OwnedBy, $deadline, $deadlineTypeID) {
		$api = self::Login();

		$params = array('processID' => $processID, 'subProcessID' => $subProcessID, 'ActivityDescription' => $ActivityDescription, 'ActivitySummary' => $ActivitySummary, 'ActivityProcedure' => $ActivityProcedure, 'deadlineResultsInMissed' => $deadlineResultsInMissed, 'AtulActivitySortOrder' => $AtulActivitySortOrder, 'CreatedBy' => $CreatedBy, 'OwnedBy' => $OwnedBy, 'deadline' => $deadline, 'deadlineTypeID' => $deadlineTypeID);
		$result = $api -> CreateActivity($params);
		if ($result) {
			return $result['CreateActivityResult'];
		}
		return false;
	}

	/**
	 * Create the Process
	 * @param unknown_type $ProcessDescription
	 * @param unknown_type $ProcessSummary
	 * @param unknown_type $CreatedBy
	 * @param unknown_type $OwnedBy
	 * @param unknown_type $AtulProcessStatusID
	 * @param unknown_type $DeadLineOffset
	 */
	public static function CreateProcess($ProcessDescription, $ProcessSummary, $CreatedBy, $OwnedBy, $AtulProcessStatusID, $DeadLineOffset) {
		$api = self::Login();
		$params = array('ProcessDescription' => $ProcessDescription, 'ProcessSummary' => $ProcessSummary, 'CreatedBy' => $CreatedBy, 'OwnedBy' => $OwnedBy, 'AtulProcessStatusID' => $AtulProcessStatusID, 'DeadLineOffset' => $DeadLineOffset);
		$result = $api -> CreateProcess($params);
		if ($result) {
			return $result['CreateProcessResult'];
		}
		return false;
	}

	/**
	 * Create SubProcess
	 * @param unknown_type $AtulProcessID
	 * @param unknown_type $summary
	 * @param unknown_type $description
	 * @param unknown_type $sortOrder
	 * @param unknown_type $NotificationIdentifier
	 * @param unknown_type $ResponsibilityOf
	 * @param unknown_type $DeadlineOffset
	 * @param unknown_type $CreatedBy
	 * @param unknown_type $OwnedBy
	 */
	public static function CreateSubProcess($AtulProcessID, $summary, $description, $sortOrder, $NotificationIdentifier, $ResponsibilityOf, $DeadlineOffset, $CreatedBy, $OwnedBy) {
		$api = self::Login();
		$params = array('AtulProcessID' => $AtulProcessID, 'summary' => $summary, 'description' => $description, 'sortOrder' => $sortOrder, 'NotificationIdentifier' => $NotificationIdentifier, 'ResponsibilityOf' => $ResponsibilityOf, 'DeadlineOffset' => $DeadlineOffset, 'CreatedBy' => $CreatedBy, 'OwnedBy' => $OwnedBy);
		$result = $api -> CreateSubProcess($params);
		if ($result) {
			return $result['CreateSubProcessResult'];
		}
		return false;
	}

	/**
	 * Delete Activity
	 * @param unknown_type $activityId
	 * @param unknown_type $ModifiedBy
	 */
	public static function DeleteActivity($activityId, $ModifiedBy) {
		$api = self::Login();
		$params = array('ActivityID' => $activityId, 'ModifiedBy' => $ModifiedBy);
		$result = $api -> DeleteActivity($params);
		if ($result) {
			return (bool)$result['DeleteActivityResult'];
		}
		return false;
	}

	/**
	 * Delete Process
	 * @param unknown_type $AtulProcessID
	 * @param unknown_type $ModifiedBy
	 */
	public static function DeleteProcess($AtulProcessID, $ModifiedBy) {
		$api = self::Login();
		$params = array('AtulProcessID' => $AtulProcessID, 'ModifiedBy' => $ModifiedBy);
		$result = $api -> DeleteProcess($params);
		if ($result) {
			return (bool)$result['DeleteProcessResult'];
		}
		return false;
	}

	/**
	 * Delete SubProcess
	 * @param unknown_type $AtulSubProcessID
	 * @param unknown_type $ModifiedBy
	 */
	public static function DeleteSubProcess($AtulSubProcessID, $ModifiedBy) {
		$api = self::Login();
		$params = array('SubProcessID' => $AtulSubProcessID, 'ModifiedBy' => $ModifiedBy);
		$result = $api -> DeleteSubProcess($params);
		if ($result) {
			return (bool)$result['DeleteSubProcessResult'];
		}
		return false;
	}

	/**
	 * Update Process
	 * @param unknown_type $processID
	 * @param unknown_type $ProcessDescription
	 * @param unknown_type $ProcessSummary
	 * @param unknown_type $ModifiedBy
	 * @param unknown_type $OwnedBy
	 * @param unknown_type $AtulProcessStatusID
	 * @param unknown_type $DeadLineOffset
	 */
	public static function UpdateProcess($processID, $ProcessDescription, $ProcessSummary, $ModifiedBy, $OwnedBy, $AtulProcessStatusID, $DeadLineOffset, $SubjectServiceProviderID, $scope) {
		$api = self::Login();
		$params = array('ProcessID' => $processID, 'ProcessDescription' => $ProcessDescription, 'ProcessSummary' => $ProcessSummary, 'ModifiedBy' => $ModifiedBy, 'OwnedBy' => $OwnedBy, 'AtulProcessStatusID' => $AtulProcessStatusID, 'DeadLineOffset' => $DeadLineOffset, 'SubjectServiceProviderID' => $SubjectServiceProviderID, 'ScopeID' => $scope);

		$result = $api -> UpdateProcess($params);
		if ($result) {
			if ($result['UpdateProcessResult'] == 'true') {
				return true;
			}
		}
		return false;
	}

	/**
	 * Update SubProcess
	 * @param unknown_type $subProcessID
	 * @param unknown_type $description
	 * @param unknown_type $summary
	 * @param unknown_type $ModifiedBy
	 * @param unknown_type $OwnedBy
	 */
	public static function UpdateSubProcess($subProcessID, $description, $summary, $ModifiedBy, $OwnedBy) {
		$api = self::Login();
		$params = array('SubProcessID' => $subProcessID, 'SubProcessDescription' => $description, 'SubProcessSummary' => $summary, 'ModifiedBy' => $ModifiedBy, 'OwnedBy' => $OwnedBy);
		$result = $api -> UpdateSubProcess($params);
		if ($result) {
			return (bool)$result['UpdateSubProcessResult'];
		}
		return false;
	}

	/**
	 * Update Activity
	 * @param unknown_type $activityID
	 * @param unknown_type $subProcessID
	 * @param unknown_type $description
	 * @param unknown_type $summary
	 * @param unknown_type $procedure
	 * @param unknown_type $sort
	 * @param unknown_type $modifiedBy
	 * @param unknown_type $ownedBy
	 */
	public static function UpdateActivity($activityID, $subProcessID, $description, $summary, $procedure, $sort, $modifiedBy, $ownedBy) {
		$api = self::Login();
		$params = array('ActivityID' => $activityID, 'SubProcessID' => $subProcessID, 'ActivityDescription' => $description, 'ActivitySummary' => $summary, 'ActivityProcedure' => $procedure, 'AtulActivitySortOrder' => $sort, 'ModifiedBy' => $modifiedBy, 'OwnedBy' => $ownedBy);
		$result = $api -> UpdateActivity($params);
		if ($result) {
			return (bool)$result['UpdateActivityResult'];
		}
		return false;
	}

	public static function UpdateProcessActivity($processActivityId, $processId, $activityId, $sort, $deadlineResultsInMissed, $deadlineType, $deadline, $modifiedBy, $AutomationServiceProviderID) {
		$api = self::Login();
		$params = array('ProcessActivityID' => $processActivityId, 'ProcessID' => $processId, 'ActivityID' => $activityId, 'sort' => $sort, 'deadlineResultsInMissed' => $deadlineResultsInMissed, 'deadlineType' => $deadlineType, 'deadline' => $deadline, 'ModifiedBy' => $modifiedBy, 'AutomationServiceProviderID' => $AutomationServiceProviderID);
		$result = $api -> UpdateProcessActivity($params);
		if ($result) {
			return (bool)$result['UpdateProcessActivityResult'];
		}
		return false;
	}

	/**
	 * Update Activity Sort
	 * @param unknown_type $activityId
	 * @param unknown_type $sort
	 * @param unknown_type $modifiedBy
	 */

	public static function UpdateActivitySort($activityId, $sort, $modifiedBy) {
		$api = self::Login();
		$params = array('ActivityID' => $activityId, 'Sort' => $sort, 'ModifiedBy' => $modifiedBy);
		$result = $api -> UpdateActivitySort($params);
		if ($result) {
			return (bool)$result['UpdateActivitySortResult'];
		}
		return false;
	}

	/**
	 * Update ProcessSubProcessSort
	 * @param unknown_type $processSubProcessId
	 * @param unknown_type $sort
	 * @param unknown_type $modifiedBy
	 */
	public static function UpdateProcessSubProcessSort($processSubProcessId, $sort, $modifiedBy) {
		$api = self::Login();
		$params = array('ProcessSubProcessID' => $processSubProcessId, 'Sort' => $sort, 'ModifiedBy' => $modifiedBy);
		$result = $api -> UpdateProcessSubProcessSort($params);
		if ($result) {
			return (bool)$result['UpdateProcessSubProcessSortResult'];
		}
		return false;
	}

	/**
	 * Get a list of all status
	 */
	public static function GetAllStatus() {
		$api = self::Login();
		$params = array();
		$result = $api -> GetAllProcessStatus($params);
		if ($result) {
			return          json_decode($result['GetAllProcessStatusResult']) -> statusList;

		}
		return false;
	}

	/**
	 * Get a list of all deadline types
	 */
	public static function GetAllDeadlineType() {
		$api = self::Login();
		$params = array();
		$result = $api -> GetAllDeadlineType($params);
		if ($result) {
			return          json_decode($result['GetAllDeadlineTypeResult']) -> deadlineTypeList;
		}
		return false;

	}

	/**
	 * Get Activity
	 * @param unknown_type $activityId
	 */
	public static function GetActivityByID($activityId) {
		$api = self::Login();
		$params = array('ActivityID' => $activityId);
		$result = $api -> GetActivityByID($params);
		if ($result) {
			return Atul_Utility::fancyJsonDecode($result['GetActivityByIDResult']) -> Activity[0];
		}
		return false;
	}

	/**
	 * Get SubProcess
	 * @param unknown_type $subProcessID
	 */
	public static function GetSubProcessByID($subProcessID) {
		$api = self::Login();
		$params = array('SubProcessID' => $subProcessID);
		$result = $api -> GetSubProcessByID($params);
		if ($result) {
			return Atul_Utility::fancyJsonDecode($result['GetSubProcessByIDResult']) -> SubProcess[0];
		}
		return false;
	}

	/**
	 * Get ProcessActivity
	 * @param unknown_type $processId
	 * @param unknown_type $activityId
	 */
	public static function GetProcessActivityByProcessIDActivityID($processId, $activityId) {
		$api = self::Login();
		$params = array('ProcessID' => $processId, 'ActivityID' => $activityId);
		$result = $api -> GetProcessActivityByProcessIDActivityID($params);
		if ($result) {
			return Atul_Utility::fancyJsonDecode($result['GetProcessActivityByProcessIDActivityIDResult']) -> ProcessActivity[0];
		}
		return false;
	}

	/**
	 *
	 * Get ProcessSubProcess
	 * @param unknown_type $processId
	 * @param unknown_type $subProcessId
	 */
	public static function GetProcessSubProcessByProcessIDSubProcessID($processId, $subProcessId) {
		$api = self::Login();
		$params = array('ProcessID' => $processId, 'SubProcessID' => $subProcessId);
		$result = $api -> GetProcessSubProcessByProcessIDSubProcessID($params);
		if ($result) {
			return Atul_Utility::fancyJsonDecode($result['GetProcessSubProcessByProcessIDSubProcessIDResult']) -> ProcessSubProcess[0];
		}
		return false;
	}

	/**
	 * Update ProcessSubProcess
	 * @param unknown_type $ProcessSubProcessID
	 * @param unknown_type $ProcessID
	 * @param unknown_type $SubProcessID
	 * @param unknown_type $sort
	 * @param unknown_type $responsibilityOf
	 * @param unknown_type $DeadlineOffset
	 * @param unknown_type $ModifiedBy
	 */
	public static function UpdateProcessSubProcess($ProcessSubProcessID, $ProcessID, $SubProcessID, $sort, $responsibilityOf, $DeadlineOffset, $ModifiedBy, $NotificationServiceProviderID) {
		$api = self::Login();
		$params = array('ProcessSubProcessID' => $ProcessSubProcessID, 'ProcessID' => 
			$ProcessID, 'SubProcessID' => $SubProcessID, 'sort' => (int)$sort, 'responsibilityOf' => (int)$responsibilityOf, 
			'DeadlineOffset' => (int)$DeadlineOffset, 'ModifiedBy' => (int)$ModifiedBy, 
			'NotificationServiceProviderID' => $NotificationServiceProviderID);
		$result = $api -> UpdateProcessSubProcess($params);		
		if ($result) {
			return (bool)$result['UpdateProcessSubProcessResult'];
		}
		return false;
	}

	/**
	 * Get Process
	 * @param unknown_type $AtulProcessID
	 */
	public static function GetProcessByID($AtulProcessID) {
		$api = self::Login();
		$params = array('AtulProcessID' => $AtulProcessID);
		$result = $api -> GetProcessByID($params);
		if ($result) {
			return Atul_Utility::fancyJsonDecode($result['GetProcessByIDResult']) -> Process[0];
		}
		return false;
	}

	/**
	 * Get All Process
	 */
	public static function GetAllProcess() {
		$api = self::Login();
		$params = array();
		$result = $api -> GetAllProcess($params);
		if ($result) {
			return Atul_Utility::fancyJsonDecode($result['GetAllProcessResult']);
		}
		return false;
	}

	/**
	 * Get a list of SubProcesses for a given Process
	 * @param unknown_type $processID
	 */
	public static function GetSubProcessesByProcessID($processID) {
		$api = self::Login();
		$params = array('ProcessID' => $processID);
		$result = $api -> GetAllSubProcessByProcessID($params);
		if ($result) {
			$tempObject = Atul_Utility::fancyJsonDecode($result['GetAllSubProcessByProcessIDResult']);
			if (is_object($tempObject)) {
				return $tempObject -> SubProcesses;
			}
		}
		return false;
	}

	/**
	 * Get a list of Activities belonging to a given SubProcess
	 * @param unknown_type $subProcessID
	 */
	public static function GetActivitiesBySubProcessID($subProcessID) {
		$api = self::Login();
		$params = array('SubProcessID' => $subProcessID);
		$result = $api -> GetAllActivityBySubProcessID($params);

		if ($result) {
			$tempObject = Atul_Utility::fancyJsonDecode($result['GetAllActivityBySubProcessIDResult']);
			if (is_object($tempObject)) {
				return $tempObject -> Activites;
			}
		}
		return false;
	}

	public static function GetProviders() {
		$api = self::Login();
		$params = array();
		$result = $api -> GetProviders($params);

		if ($result) {
			//return json_decode(utf8_decode(str_replace(array("\r", "\r\n", "\n"), '<br>', $result['GetProvidersResult'])));
			return       json_decode(utf8_decode(str_replace(array("\r", "\r\n", "\n"), '<br>', $result['GetProvidersResult']))) -> providers -> providers;
		}
		return false;
	}

	public static function UpdateProvider($AtulServiceProviderID, $ServiceProviderName, $ServiceProviderDescription, $AtulServiceProviderClassID, $WSDL, $DSN, $verb, $ModifiedBy, $ServiceProviderXML) {
		$api = self::Login();
		$params = array('AtulServiceProviderID' => $AtulServiceProviderID, 'ServiceProviderName' => $ServiceProviderName, 'ServiceProviderDescription' => $ServiceProviderName, 'AtulServiceProviderClassID' => $AtulServiceProviderClassID, 'WSDL' => $WSDL, 'DSN' => $DSN, 'verb' => $verb, 'ModifiedBy' => $ModifiedBy, 'ServiceProviderXML' => $ServiceProviderXML);
		$result = $api -> UpdateProvider($params);

		if ($result) {
			print_r($result);
			return $result['UpdateProviderResult'];
		}
		return false;
	}

	public static function InsertProvider($ServiceProviderName, $ServiceProviderDescription, $AtulServiceProviderClassID, $WSDL, $DSN, $CreatedBy, $verb, $ServiceProviderXML) {
		$api = self::Login();
		$params = array('ServiceProviderName' => $ServiceProviderName, 'ServiceProviderDescription' => $ServiceProviderName, 'AtulServiceProviderClassID' => $AtulServiceProviderClassID, 'WSDL' => $WSDL, 'DSN' => $DSN, 'CreatedBy' => $CreatedBy, 'verb' => $verb, 'ServiceProviderXML' => $ServiceProviderXML);
		$result = $api -> InsertProvider($params);

		if ($result) {
			return       json_decode(utf8_decode(str_replace(array("\r", "\r\n", "\n"), '<br>', $result['InsertProviderResult']))) -> providers -> providers;
		}
		return false;
	}

	public static function ScheduleProcess($processId, $scheduleVersion, $startDate, $scheduleRepeat, $userIdList) {
		$api = self::Login();
		$params = array('ProcessID' => $processId, 'scheduleVersion' => $scheduleVersion, 'nextScheduled' => $startDate, 'repeatSchedule' => $scheduleRepeat, 'instantiatedUsers' => $userIdList);
		$result = $api -> CreateProcessSchedule($params);
		if ($result) {
			return $result['CreateProcessScheduleResult'];
		}
	}

	public static function GetProcessScheduleByProcessID($processId) {
		$api = self::Login();
		$params = array('ProcessID' => $processId);
		$result = $api -> GetProcessScheduleByProcessID($params);
		if ($result) {
			return $result['GetProcessScheduleByProcessIDResult'];
		}
	}

	public static function GetProcessScheduleByID($scheduleID) {
		$api = self::Login();
		$params = array('ScheduleID' => $scheduleID);
		$result = $api -> GetProcessScheduleByID($params);
		if ($result) {
			return $result['GetProcessScheduleByIDResult'];
		}
	}

	public static function UpdateProcessSchedule($processId, $scheduleVersion, $nextScheduled, $scheduleRepeat, $userIdList) {
		$api = self::Login();
		$params = array('ProcessID' => $processId, 'scheduleVersion' => $scheduleVersion, 'nextScheduled' => $nextScheduled, 'repeatSchedule' => $scheduleRepeat, 'instantiatedUsers' => $userIdList);
		$result = $api -> UpdateProcessScheduleByProcessID($params);
		if ($result) {
			return (bool)$result['UpdateProcessScheduleByProcessIDResult'];
		}
	}

	public static function DeleteProcessSchedule($processScheduleID) {
		$api = self::Login();
		$params = array('ProcessScheduleID' => $processScheduleID);
		$result = $api -> DeleteProcessSchedule($params);
		if ($result) {
			return $result['DeleteProcessScheduleResult'];
		}
	}

	public static function UpdateUserForProcess($processId, $newOwner, $modifiedBy) {
		if ($process = self::GetProcessByID($processId)) {
			$sid = '';
			if (isset($process -> SubjectServiceProviderID)) {
				$sid = $process -> SubjectServiceProviderID;
			}
			$result = self::UpdateProcess($processId, $process -> ProcessDescription, $process -> ProcessSummary, $modifiedBy, $newOwner, $process -> AtulProcessStatusID, $process -> DeadLineOffset, $sid, $process->SubjectScopeIdentifier);
			return $result;
		}
		return false;
	}

	public static function FilterUserProcesses($processes, $userId) {
		$userProcesses = array();
		foreach ($processes as $process) {

			if ($process -> OwnedBy == $userId) {
				$userProcesses[] = $process;
			}
		}
		return $userProcesses;
	}

	public static function FilterUserGroupProcesses($user, $processes) {
		$groupProcesses = array();
		foreach ($processes as $process) {
			if ($user -> hasGroupID($process -> OwnedBy)) {
				$groupProcesses[] = $process;
			}
		}
		return $groupProcesses;
	}

	public static function FilterProcessesForUser($user, $processes) {
		foreach ($processes as &$process) {
			if ($user -> AtulUserID == $process -> OwnedBy) {
				$process -> ProcessSummary = 'My Processes.' . $process -> ProcessSummary;
			} elseif ($user -> hasGroupID($process -> OwnedBy)) {
				$process -> ProcessSummary = 'My Groups\' Processes.' . $process -> ProcessSummary;
			} else {
				$process -> ProcessSummary = 'Other Processes.' . $process -> ProcessSummary;
			}
		}
	}

	public static function GetProcessBySummary($summary) {
		$api = self::Login();
		$params = array('ProcessSummary' => $summary);
		$result = $api -> GetProcessBySummary($params);
		if ($result) {
			return $result['GetProcessBySummaryResult'];
		}
		return null;
	}

	public static function GetDeletedProcesses($daysBack) {
		$api = self::Login();
		$params = array('daysBack' => $daysBack);
		$result = $api -> ProcessGetDeleted($params);
		if ($result) {
			$processes = new Atul_Collection();
			if ($result['ProcessGetDeletedResult'] != '' && $result['ProcessGetDeletedResult'] != null) {

				if (isset($result['ProcessGetDeletedResult']['Process'][0])) {
					$l = $result['ProcessGetDeletedResult']['Process'];
				} else {
					$l = array();
					$l[] = $result['ProcessGetDeletedResult']['Process'];
				}
				foreach ($l as $item) {
					$p = new Atul_MagicObject($item);
					$processes -> addItem($p, $item['AtulProcessID']);
				}
			}
			return $processes;
		}
		return false;
	}

	public static function UndeleteProcess($processId, $user) {
		$api = self::Login();
		$params = array('ProcessID' => $processId, 'ModifiedBy' => $user);
		$result = $api -> UndeleteProcess($params);
		if ($result) {
			return $result['UndeleteProcessResult'];
		}
	}

	public static function FlexFieldInsert($TokenName, $IsRequired, $CreatedBy, $AtulProcessID, $AtulSubProcessID, $AtulActivityID) {
		$api = self::Login();
		$params = array('TokenName' => (string)$TokenName, 'IsRequired' => (int)$IsRequired, 'CreatedBy' => (string)$CreatedBy, 'AtulProcessID' => (string)$AtulProcessID, 'AtulSubProcessID' => (string)$AtulSubProcessID, 'AtulActivityID' => (string)$AtulActivityID);
		$result = $api -> FlexFieldInsert($params);
		if ($result) {
			return $result;
		}
	}

	public static function FlexFieldUpsert($TokenName, $IsRequired, $CreatedBy, $AtulProcessID, $AtulSubProcessID, $AtulActivityID, $DefaultTokenValue, $FriendlyName, $ToolTip, $IsParameter) {
		$api = self::Login();
		$params = array('TokenName' => (string)$TokenName, 'IsRequired' => (int)$IsRequired, 'CreatedBy' => (string)$CreatedBy, 'AtulProcessID' => (string)$AtulProcessID, 'AtulSubProcessID' => (string)$AtulSubProcessID, 'AtulActivityID' => (string)$AtulActivityID, 'DefaultTokenValue' => (string)$DefaultTokenValue, 'FriendlyName' => (string)$FriendlyName, 'ToolTip' => (string)$ToolTip, 'IsParameter' => (int)$IsParameter);

		$result = $api -> FlexFieldUpsert($params);
		if ($result) {
			return $result;
		}
	}

	public static function FlexFieldDelete($AtulFlexFieldID, $ModifiedBy) {
		$api = self::Login();
		$params = array('AtulFlexFieldID' => $AtulFlexFieldID, 'ModifiedBy' => $ModifiedBy);
		$result = $api -> FlexFieldDelete($params);
		if ($result) {
			return $result;
		}
	}

	public static function FlexFieldUpdate($AtulFlexFieldID, $TokenName, $IsRequired, $ModifiedBy, $AtulProcessID, $AtulSubProcessID, $AtulActivityID) {
		$api = self::Login();
		$params = array('AtulFlexFieldID' => $AtulFlexFieldID, 'TokenName' => $TokenName, 'IsRequired' => $IsRequired, 'ModifiedBy' => $ModifiedBy, 'AtulProcessID' => $AtulProcessID, 'AtulSubProcessID' => $AtulSubProcessID, 'AtulActivityID' => $AtulActivityID);

		$result = $api -> FlexFieldUpdate($params);
		if ($result) {
			return $result['FlexFieldUpdateResult'];
		}
	}

	public static function FlexFieldGetBySearch($AtulProcessID, $AtulSubProcessID, $AtulActivityID) {
		$api = self::Login();
		$params = array('AtulProcessID' => $AtulProcessID, 'AtulSubProcessID' => $AtulSubProcessID, 'AtulActivityID' => $AtulActivityID);
		$result = $api -> FlexFieldGetBySearch($params);
		if ($result) {
			return Atul_Utility::fancyJsonDecode($result['FlexFieldGetBySearchResult']);
		}
	}

	public static function FlexFieldStorageInsert($AtulInstanceProcessID, $AtulFlexFieldID, $tokenValue, $CreatedBy) {
		$api = self::Login();
		$params = array('AtulInstanceProcessID' => $AtulInstanceProcessID, 'AtulFlexFieldID' => $AtulFlexFieldID, 'tokenValue' => $tokenValue, 'CreatedBy' => $CreatedBy);
		$result = $api -> FlexFieldStorageInsert($params);
		if ($result) {
			return $result;
		}
	}

	public static function FlexFieldsGetByProcessID($AtulProcessId) {

		$api = self::Login();
		$params = array('AtulProcessID' => $AtulProcessId);

		$result = $api -> FlexFieldsGetByProcessID($params);
		if ($result) {
			return json_decode($result['FlexFieldsGetByProcessIDResult']);
		}
		return false;
	}

	public static function GetProviderParameters($providerId, $verb) {
		$api = self::Login();
		$params = array(
			'providerId' => $providerId, 
			'verb' => $verb);
		$result = $api -> GetProviderParameters($params);
		if ($result) {
			return json_decode($result['GetProviderParametersResult']);
		}
		return false;
	}

}
