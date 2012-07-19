<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class ServiceManager_AtulWebServiceClient extends ServiceManager_Abstract {
	/**
	 * Call web service method to complete a checklist step
	 */

	private static function Login() {
		// Set up connection to Web Service
		$config = Zend_Registry::get('config');
		$wsdl = $config->atulapi->wsdl;
		// get wsdl from config or somewhere
		$soapOptions = array('user' => $config->ldap->user, 'pass' => $config->ldap->password);
		return self::setupWebService($wsdl, ServiceManager::SVC_AUTH_NTLM, $soapOptions);
		// this service is NTLM authenticated

	}
	// <summary>
	// Adds the activity to activity group.
	// </summary>
	// <param name="AtulActivityGroupID">The atul activity group ID.</param>
	// <param name="AtulActivityID">The atul activity ID.</param>
	// <param name="CreatedBy">The created by ID.</param>
	public static function AddActivityToActivityGroup($AtulActivityGroupID, $AtulActivityID, $CreatedBy) {
		$api = self::Login();
		$params = array('AtulActivityGroupID' => $AtulActivityGroupID, 'AtulActivityID' => $AtulActivityID, 'CreatedBy' => $CreatedBy);
		$result = $api->AddActivityToActivityGroup($params);
		if ($result) {
			return json_decode($result['AddActivityToActivityGroupResult']);
		}
		return false;
	}

	// <summary>
	// Adds a process manager.
	// A process can have more than one manager.
	// This method is intended to create a manager, but is generic since the typeId will change
	// The typeid should be set in the webconfig and retreived in the logic layer
	// </summary>
	// <param name="AtulRemoteSystemID">The atul remote system ID.</param>
	// <param name="AtulUserTypeID">The atul user type ID.</param>
	// <param name="RemoteSystemLoginID">The remote system login ID.</param>
	// <param name="DisplayName">The display name.</param>
	public static function AddProcessManager($AtulRemoteSystemID, $AtulUserTypeID, $RemoteSystemLoginID, $DisplayName) {
		$api = self::Login();
		$params = array('AtulRemoteSystemID' => $AtulRemoteSystemID, 'AtulUserTypeID' => $AtulUserTypeID, 'RemoteSystemLoginID' => $RemoteSystemLoginID, 'DisplayName' => $DisplayName);
		$result = $api->AddProcessManager($params);
		if ($result) {
			return json_decode($result['AddProcessManagerResult']);
		}
		return false;
	}

	// <summary>
	// Creates the activity.
	// </summary>
	// <param name="AtulSubProcessID">The atul sub process ID.</param>
	// <param name="ActivityDescription">The activity description.</param>
	// <param name="ActivitySummary">The activity summary.</param>
	// <param name="ActivityProcedure">The activity procedure.</param>
	// <param name="AtulActivitySortOrder">The atul activity sort order.</param>
	// <param name="CreatedBy">The created by ID.</param>
	// <param name="OwnedBy">The owned by ID.</param>
	public static function CreateActivity($processID, $subProcessID, $ActivityDescription, $ActivitySummary, $ActivityProcedure, $deadlineResultsInMissed, $AtulActivitySortOrder, $CreatedBy, $OwnedBy, $deadline, $deadlineTypeID) {
		$api = self::Login();

		$params = array('processID' => $processID, 'subProcessID' => $subProcessID, 'ActivityDescription' => $ActivityDescription, 'ActivitySummary' => $ActivitySummary, 'ActivityProcedure' => $ActivityProcedure, 'deadlineResultsInMissed' => $deadlineResultsInMissed, 'AtulActivitySortOrder' => $AtulActivitySortOrder, 'CreatedBy' => $CreatedBy, 'OwnedBy' => $OwnedBy, 'deadline' => $deadline, 'deadlineTypeID' => $deadlineTypeID);
		$result = $api->CreateActivity($params);
		if ($result) {
			return $result['CreateActivityResult'];
		}
		return false;

	}

	// <summary>
	// Creates the activity group.
	// </summary>
	// <param name="AtulActivityGroupPurposeID">The atul activity group purpose ID.</param>
	// <param name="ActivityGroupDescription">The activity group description.</param>
	// <param name="ActivityGroupSummary">The activity group summary.</param>
	// <param name="CreatedBy">The created by ID.</param>
	public static function CreateActivityGroup($AtulActivityGroupPurposeID, $ActivityGroupDescription, $ActivityGroupSummary, $CreatedBy) {
		$api = self::Login();
		$params = array('AtulActivityGroupPurposeID' => $AtulActivityGroupPurposeID, 'ActivityGroupDescription' => $ActivityGroupDescription, 'ActivityGroupSummary' => $ActivityGroupSummary, 'CreatedBy' => $CreatedBy);
		$result = $api->CreateActivityGroup($params);
		if ($result) {
			return json_decode($result['CreateActivityGroupResult']);
		}
		return false;
	}

	// <summary>
	// Creates the instance process.
	// </summary>
	// <param name="AtulProcessID">The atul process ID.</param>
	// <param name="CreatedBy">The created by ID.</param>
	// <param name="OwnedBy">The owned by ID.</param>
	// <param name="AtulProcessStatusID">The atul process status ID.</param>
	public static function CreateInstanceProcess($AtulProcessID, $CreatedBy, $OwnedBy, $AtulProcessStatusID, $SubjectIdentifier = '', $SubjectSummary = '') {
		$api = self::Login();
		$params = array('AtulProcessID' => $AtulProcessID, 'CreatedBy' => $CreatedBy, 'OwnedBy' => $OwnedBy, 'AtulProcessStatusID' => $AtulProcessStatusID, 'SubjectIdentifier' => $SubjectIdentifier, 'SubjectSummary' => $SubjectSummary);
		$result = $api->CreateInstanceProcess($params);
		if (is_array($result)) {
			return $result['CreateInstanceProcessResult'];
		}
		return false;
	}

	// <summary>
	// Creates the process.
	// </summary>
	// <param name="ProcessDescription">The process description.</param>
	// <param name="ProcessSummary">The process summary.</param>
	// <param name="CreatedBy">The created by.</param>
	// <param name="OwnedBy">The owned by.</param>
	// <param name="AtulProcessStatusID">The atul process status ID.</param>
	// <param name="AtulUserDefinedAttributeID">The atul user defined attribute ID.</param>
	// <param name="DeadLineOffset">The dead line offset.</param>
	public static function CreateProcess($ProcessDescription, $ProcessSummary, $CreatedBy, $OwnedBy, $AtulProcessStatusID, $DeadLineOffset) {
		$api = self::Login();
		$params = array('ProcessDescription' => $ProcessDescription, 'ProcessSummary' => $ProcessSummary, 'CreatedBy' => $CreatedBy, 'OwnedBy' => $OwnedBy, 'AtulProcessStatusID' => $AtulProcessStatusID, 'DeadLineOffset' => $DeadLineOffset);
		$result = $api->CreateProcess($params);
		if ($result) {
			return $result['CreateProcessResult'];
		}
		return false;
	}

	// <summary>
	// Creates the sub process.
	// </summary>
	// <param name="AtulProcessID">The atul process ID.</param>
	// <param name="AtulSubProcessID">The atul sub process ID.</param>
	// <param name="ProcessSubprocessSortOrder">The process subprocess sort order.</param>
	// <param name="NotificationServiceProvideID">The notification service provide ID.</param>
	// <param name="NotificationIdentifier">The notification identifier.</param>
	// <param name="ResponsibilityOf">The responsibility of ID.</param>
	// <param name="DeadlineOffset">The deadline offset.</param>
	// <param name="CreatedBy">The created by ID.</param>
	public static function CreateSubProcess($AtulProcessID, $summary, $description, $sortOrder, $NotificationIdentifier, $ResponsibilityOf, $DeadlineOffset, $CreatedBy, $OwnedBy) {
		$api = self::Login();
		$params = array('AtulProcessID' => $AtulProcessID, 'summary' => $summary, 'description' => $description, 'sortOrder' => $sortOrder, 'NotificationIdentifier' => $NotificationIdentifier, 'ResponsibilityOf' => $ResponsibilityOf, 'DeadlineOffset' => $DeadlineOffset, 'CreatedBy' => $CreatedBy, 'OwnedBy' => $OwnedBy);
		$result = $api->CreateSubProcess($params);
		if ($result) {
			return $result['CreateSubProcessResult'];
		}
		return false;
	}

	// <summary>
	// Deletes the activity.
	// </summary>
	// <param name="AtulProcessID">The atul process ID.</param>
	// <param name="ModifiedBy">The modified by.</param>
	public static function DeleteActivity($activityId, $ModifiedBy) {
		$api = self::Login();
		$params = array('ActivityID' => $activityId, 'ModifiedBy' => $ModifiedBy);
		$result = $api->DeleteActivity($params);
		if ($result) {
			return (bool)$result['DeleteActivityResult'];
		}
		return false;
	}

	// <summary>
	// Deletes the activity group.
	// </summary>
	// <param name="AtulActivityGroupID">The atul activity group ID.</param>
	// <param name="ModifiedBy">The modified by.</param>
	public static function DeleteActivityGroup($AtulActivityGroupID, $ModifiedBy) {
		$api = self::Login();
		$params = array('AtulActivityGroupID' => $AtulActivityGroupID, 'ModifiedBy' => $ModifiedBy);
		$result = $api->DeleteActivityGroup($params);
		if ($result) {
			return json_decode($result['DeleteActivityGroupResult']);
		}
		return false;
	}

	// <summary>
	// Deletes the instance process.
	// </summary>
	public static function DeleteInstanceProcess($AtulInstanceProcessID, $ModifiedBy) {
		$api = self::Login();
		$params = array('AtulInstanceProcessID' => $AtulInstanceProcessID, 'ModifiedBy' => $ModifiedBy);
		$result = $api->DeleteInstanceProcess($params);
		if ($result) {
			return json_decode($result['DeleteInstanceProcessResult']);
		}
		return false;
	}

	// <summary>
	// Deletes the process.
	// </summary>
	// <param name="AtulProcessID">The atul process ID.</param>
	// <param name="ModifiedBy">The modified by.</param>
	public static function DeleteProcess($AtulProcessID, $ModifiedBy) {
		$api = self::Login();
		$params = array('AtulProcessID' => $AtulProcessID, 'ModifiedBy' => $ModifiedBy);
		$result = $api->DeleteProcess($params);
		if ($result) {
			return json_decode($result['DeleteProcessResult']);
		}
		return false;
	}

	// <summary>
	// Deletes the sub process.
	// </summary>
	// <param name="AtulSubProcessID">The atul sub process ID.</param>
	// <param name="ModifiedBy">The modified by.</param>
	public static function DeleteSubProcess($AtulSubProcessID, $ModifiedBy) {
		$api = self::Login();
		$params = array('SubProcessID' => $AtulSubProcessID, 'ModifiedBy' => $ModifiedBy);
		$result = $api->DeleteSubProcess($params);
		if ($result) {
			return (bool)$result['DeleteSubProcessResult'];
		}
		return false;
	}
	
	public static function GetProviderByID($providerID){
		$api = self::Login();
		$params = array('ProviderID' => $providerID);
		$result = $api->GetProviderByID ($params);
		return $result['GetProviderByIDResult'];
	}
	
	public static function GetSubjectProviderScope($providerID, $timeoutSeconds){
		$config = Zend_Registry::get('config');
		// first get some provider details
		$providerResult = Atul_Utility::fancyJsonDecode(self::GetProviderByID($providerID));
		$provider = $providerResult->providers[0];
		$result = self::SendToQueueWithReply($provider->ESBQueue, $provider->ServiceProviderName, '', 'GETSCOPE', $config->queue->return->webgui);
		return $result;
	}
	
	public static function SendToQueueWithReply($queue, $provider, $body, $verb, $returnQueue, $timeoutSeconds = 10)
	{
		$headers = 'PROVIDER:'.$provider.',VERB:'.$verb.',RETURNQUEUE:'.$returnQueue;
		
		$result = self::SendToQueue($queue, $body, $headers);
		$api = self::Login();
		if ($result !== false) {
			$pollMessageParams = array(
				'queue' => $returnQueue,
				'correlationID' => $verb.'_'.$result);
			$startTime = time();
			$timeNow = time();
			
			while (intval($timeoutSeconds) > ($timeNow - $startTime)){
				sleep(1);
				$timeNow = time();
				
				
				$msgResult = $api->GetQueueMessageByCorrelationID($pollMessageParams);
				
				if ($msgResult['GetQueueMessageByCorrelationIDResult'] != ''){
					break;
				}
			}
			
			return $msgResult['GetQueueMessageByCorrelationIDResult'];
		}
		return false;
	}
	
	public static function SendToQueue($queue, $body, $headers)
	{
		$api = self::Login();
		$params = array(
			'queue' => $queue, 
			'body' => $body, 
			'headers' => $headers);
		$result = $api->PushToQueue ($params);
		
		if (isset($result['PushToQueueResult'])) {
			
			return $result['PushToQueueResult'];
		}
		return false;
	}
	
	public  static function GetSubjectProviderEntites($providerID, $scope, $timeoutSeconds = 10)
	{
		$config = Zend_Registry::get('config');
		// first get some provider details
		$providerResult = Atul_Utility::fancyJsonDecode(self::GetProviderByID($providerID));
		$provider = $providerResult->providers[0];
		$body = '<servicerequest>
  			<verb>GETENTITIES</verb>
  			<parameter>
    				<name>scopeid</name>
    				<value>'.$scope.'</value>
  			</parameter>
  		</servicerequest>';
		
		$result = self::SendToQueueWithReply($provider->ESBQueue, $provider->ServiceProviderName, $body, 'GETENTITIES', $config->queue->return->webgui);
		return $result;
	}
	
	public static function DescribeActor($queue) {
		$api = self::Login();
		$params = array('queuename' => $queue);
		$result = $api->DescribeActor($params);
		if ($result && isset($result['DescribeActorResult'])) {
			return (bool) $result['DescribeActorResult'];
		}
		return false;
	}

	public static function UpdateProcess($processID, $ProcessDescription, $ProcessSummary, $ModifiedBy, $OwnedBy, $AtulProcessStatusID, $DeadLineOffset) {
		$api = self::Login();
		$params = array('ProcessID' => $processID, 'ProcessDescription' => $ProcessDescription, 'ProcessSummary' => $ProcessSummary, 'ModifiedBy' => $ModifiedBy, 'OwnedBy' => $OwnedBy, 'AtulProcessStatusID' => $AtulProcessStatusID, 'DeadLineOffset' => $DeadLineOffset);
		$result = $api->UpdateProcess($params);
		if ($result) {
			return (bool)$result['UpdateProcessResult'];
		}
		return false;
	}

	public static function UpdateSubProcess($subProcessID, $description, $summary, $ModifiedBy, $OwnedBy) {
		$api = self::Login();
		$params = array('SubProcessID' => $subProcessID, 'SubProcessDescription' => $description, 'SubProcessSummary' => $summary, 'ModifiedBy' => $ModifiedBy, 'OwnedBy' => $OwnedBy);
		$result = $api->UpdateSubProcess($params);
		if ($result) {
			return (bool)$result['UpdateSubProcessResult'];
		}
		return false;
	}

	public static function UpdateActivity($activityID, $subProcessID, $description, $summary, $procedure, $sort, $modifiedBy, $ownedBy) {
		$api = self::Login();
		$params = array('ActivityID' => $activityID, 'SubProcessID' => $subProcessID, 'ActivityDescription' => $description, 'ActivitySummary' => $summary, 'ActivityProcedure' => $procedure, 'AtulActivitySortOrder' => $sort, 'ModifiedBy' => $modifiedBy, 'OwnedBy' => $ownedBy);
		$result = $api->UpdateActivity($params);
		if ($result) {
			return (bool)$result['UpdateActivityResult'];
		}
		return false;
	}

	public static function UpdateActivitySort($activityId, $sort, $modifiedBy) {
		$api = self::Login();
		$params = array('ActivityID' => $activityId, 'Sort' => $sort, 'ModifiedBy' => $modifiedBy);
		$result = $api->UpdateActivitySort($params);
		if ($result) {
			return (bool)$result['UpdateActivitySortResult'];
		}
		return false;
	}

	public static function UpdateProcessSubProcessSort($processSubProcessId, $sort, $modifiedBy) {
		$api = self::Login();
		$params = array('ProcessSubProcessID' => $processSubProcessId, 'Sort' => $sort, 'ModifiedBy' => $modifiedBy);
		$result = $api->UpdateProcessSubProcessSort($params);
		if ($result) {
			return (bool)$result['UpdateProcessSubProcessSortResult'];
		}
		return false;
	}

	// <summary>
	// Deletes the instance process activity.
	// </summary>
	public static function DeleteInstanceProcessActivity($AtulSubProcessID, $ModifiedBy) {
		$api = self::Login();
		$params = array('AtulSubProcessID' => $AtulSubProcessID, 'ModifiedBy' => $ModifiedBy);
		$result = $api->DeleteInstanceProcessActivity($params);
		if ($result) {
			return json_decode($result['DeleteInstanceProcessActivityResult']);
		}
		return false;
	}

	// <summary>
	// Deletes the process manager.
	// TODO: [This is invalid, we would need to specify the process, usertypeID and the userID. Probably need a new proc]
	// </summary>
	// <param name="AtulUserID">The atul user ID.</param>
	public static function DeleteProcessManager($AtulUserID) {
		$api = self::Login();
		$params = array('AtulUserID' => $AtulUserID);
		$result = $api->DeleteProcessManager($params);
		if ($result) {
			return json_decode($result['DeleteProcessManagerResult']);
		}
		return false;
	}

	// <summary>
	// Enables the activity automation.
	// TODO: Find/Define appliciable attribute
	// </summary>
	public static function EnableActivityAutomation() {
		$api = self::Login();
		$params = array();
		$result = $api->EnableActivityAutomation($params);
		if ($result) {
			return json_decode($result['EnableActivityAutomationResult']);
		}
		return false;
	}

	public static function GetAllStatus() {
		$api = self::Login();
		$params = array();
		$result = $api->GetAllProcessStatus($params);
		if ($result) {
			return   json_decode($result['GetAllProcessStatusResult'])->statusList;

		}
		return false;
	}

	public static function GetAllDeadlineType() {
		$api = self::Login();
		$params = array();
		$result = $api->GetAllDeadlineType($params);
		if ($result) {
			return   json_decode($result['GetAllDeadlineTypeResult'])->deadlineTypeList;
		}
		return false;

	}

	// <summary>
	// Gets all activity.
	// </summary>
	public static function GetAllActivity() {
		$api = self::Login();
		$params = array();
		$result = $api->GetAllActivity($params);
		if ($result) {
			return json_decode($result['GetAllActivityResult']);
		}
		return false;
	}

	// <summary>
	// Gets all instance process.
	// </summary>
	public static function GetAllInstanceProcess() {
		$api = self::Login();
		$params = array();
		$result = $api->GetAllInstanceProcess($params);
		if ($result) {
			return json_decode($result['GetAllInstanceProcessResult']);
		}
		return false;
	}

	// <summary>
	// Gets all instance process activity.
	// </summary>
	public static function GetAllInstanceProcessActivity() {
		$api = self::Login();
		$params = array();
		$result = $api->GetAllInstanceProcessActivity($params);
		if ($result) {
			return json_decode($result['GetAllInstanceProcessActivityResult']);
		}
		return false;
	}

	// <summary>
	// Gets all process.
	// </summary>
	public static function GetAllProcess() {
		$api = self::Login();
		$result = $api->GetAllProcess();
		if ($result) {
			return json_decode($result['GetAllProcessResult']);
			//->GetAllProcessResult']);
		}
		return false;
	}

	// <summary>
	// Gets all process activity groups.
	// </summary>
	public static function GetAllProcessActivityGroups() {
		$api = self::Login();
		$params = array();
		$result = $api->GetAllProcessActivityGroups($params);
		if ($result) {
			return json_decode($result['GetAllProcessActivityGroupsResult']);
		}
		return false;
	}

	// <summary>
	// Gets all process sub process.
	// </summary>
	public static function GetAllProcessSubProcess() {
		$api = self::Login();
		$params = array();
		$result = $api->GetAllProcessSubProcess($params);
		if ($result) {
			return json_decode($result['GetAllProcessSubProcessResult']);
		}
		return false;
	}

	//GetAllProcessSubProcessByProcessID(string AtulSubProcessID)
	public static function GetAllProcessSubProcessByProcessID($AtulProcessSubprocessID) {
		$api = self::Login();
		$params = array('AtulProcessSubprocessID' => $AtulProcessSubprocessID);
		$result = $api->GetAllProcessSubProcessByProcessID($params);
		if ($result) {
			return json_decode($result['GetAllProcessSubProcessByProcessIDResult']);
		}
		return false;
	}

	public static function GetProcessSubProcessDetailsBySubProcessID($AtulSubProcessID) {
		$api = self::Login();
		$params = array('AtulSubProcessID' => $AtulSubProcessID);
		$result = $api->GetProcessSubProcessDetailsBySubProcessID($params);
		if ($result) {
			return json_decode($result['GetProcessSubProcessDetailsBySubProcessIDResult']);
		}
		return false;
	}

	// <summary>
	// Gets all process sub process activity.
	// TODO: New proc needed to get a subprocess's activities
	// </summary>
	public static function GetAllProcessSubProcessActivity() {
		$api = self::Login();
		$params = array();
		$result = $api->GetAllProcessSubProcessActivity($params);
		if ($result) {
			return json_decode($result['GetAllProcessSubProcessActivityResult']);
		}
		return false;
	}

	public static function GetActivityByID($activityId) {
		$api = self::Login();
		$params = array('ActivityID' => $activityId);
		$result = $api->GetActivityByID($params);
		if ($result) {
			return   json_decode($result['GetActivityByIDResult'])->Activity[0];
		}
		return false;
	}

	public static function GetSubProcessByID($subProcessID) {
		$api = self::Login();
		$params = array('SubProcessID' => $subProcessID);
		$result = $api->GetSubProcessByID($params);
		if ($result) {
			return   json_decode($result['GetSubProcessByIDResult'])->SubProcess[0];
		}
		return false;
	}

	public static function GetProcessActivityByProcessIDActivityID($processId, $activityId) {
		$api = self::Login();
		$params = array('ProcessID' => $processId, 'ActivityID' => $activityId);
		$result = $api->GetProcessActivityByProcessIDActivityID($params);
		if ($result) {
			return   json_decode($result['GetProcessActivityByProcessIDActivityIDResult'])->ProcessActivity[0];
		}
		return false;
	}

	public static function GetProcessSubProcessByProcessIDSubProcessID($processId, $subProcessId) {
		$api = self::Login();
		$params = array('ProcessID' => $processId, 'SubProcessID' => $subProcessId);
		$result = $api->GetProcessSubProcessByProcessIDSubProcessID($params);
		if ($result) {
			return   json_decode($result['GetProcessSubProcessByProcessIDSubProcessIDResult'])->ProcessSubProcess[0];
		}
		return false;
	}

	public static function UpdateProcessSubProcess($ProcessSubProcessID, $ProcessID, $SubProcessID, $sort, $responsibilityOf, $DeadlineOffset, $ModifiedBy) {
		$api = self::Login();
		$params = array('ProcessSubProcessID' => $ProcessSubProcessID, 'ProcessID' => $ProcessID, 'SubProcessID' => $SubProcessID, 'sort' => $sort, 'responsibilityOf' => $responsibilityOf, 'DeadlineOffset' => $DeadlineOffset, 'ModifiedBy' => $ModifiedBy);
		$result = $api->UpdateProcessSubProcess($params);
		if ($result) {
			return (bool)$result['UpdateProcessSubProcessResult'];
		}
		return false;
	}

	// <summary>
	// Gets the instance process activity.
	// </summary>
	public static function GetInstanceProcessActivity() {
		$api = self::Login();
		$params = array();
		$result = $api->GetInstanceProcessActivity($params);
		if ($result) {
			return json_decode($result['GetInstanceProcessActivityResult']);
		}
		return false;
	}

	// <summary>
	// Gets the instance process by ID.
	// </summary>
	// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
	public static function GetInstanceProcessByID($AtulInstanceProcessID) {
		$api = self::Login();
		$params = array('AtulInstanceProcessID' => $AtulInstanceProcessID);
		$result = $api->GetInstanceProcessByID($params);
		//return $AtulInstanceProcessID;
		if ($result) {
			return json_decode($result['GetInstanceProcessByIDResult']);
		}
		return false;
	}

	public static function GetInstanceDetail($AtulInstanceProcessID) {
		$api = self::Login();
		$params = array('AtulInstanceProcessID' => $AtulInstanceProcessID);
		$result = $api->GetInstanceDetail($params);
		//return $AtulInstanceProcessID;
		if ($result) {
			return json_decode($result['GetInstanceDetailResult']);
		}
		return false;
	}

	// <summary>
	// Gets the instance process by ID.
	// </summary>
	// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
	public static function GetProcessByID($AtulProcessID) {
		$api = self::Login();
		$params = array('AtulProcessID' => $AtulProcessID);
		$result = $api->GetProcessByID($params);
		//return $AtulInstanceProcessID;
		if ($result) {
			return   json_decode($result['GetProcessByIDResult'])->Process[0];
		}
		return false;
	}

	public static function GetSubProcessesByProcessID($processID) {
		$api = self::Login();
		$params = array('ProcessID' => $processID);
		$result = $api->GetAllSubProcessByProcessID($params);
		if ($result) {
			return   json_decode(utf8_decode(str_replace(array("\r", "\r\n", "\n"), '<br>', $result['GetAllSubProcessByProcessIDResult'])))->SubProcesses;
		}
		return false;
	}

	public static function GetActivitiesBySubProcessID($subProcessID) {
		$api = self::Login();
		$params = array('SubProcessID' => $subProcessID);
		$result = $api->GetAllActivityBySubProcessID($params);

		if ($result) {
			return   json_decode(utf8_decode(str_replace(array("\r", "\r\n", "\n"), '<br>', $result['GetAllActivityBySubProcessIDResult'])))->Activites;
		}
		return false;
	}

	// <summary>
	// Inserts the instance process.
	// </summary>
	// <param name="AtulProcessID">The atul process ID.</param>
	// <param name="CreatedBy">The created by.</param>
	// <param name="OwnedBy">The owned by.</param>
	// <param name="AtulProcessStatusID">The atul process status ID.</param>
	public static function InsertInstanceProcess($AtulProcessID, $CreatedBy, $OwnedBy, $AtulProcessStatusID) {
		$api = self::Login();
		$params = array('AtulProcessID' => $AtulProcessID, 'CreatedBy' => $CreatedBy, 'OwnedBy' => $OwnedBy, 'AtulProcessStatusID' => $AtulProcessStatusID);
		$result = $api->InsertInstanceProcess($params);
		if ($result) {
			return json_decode($result['InsertInstanceProcessResult']);
		}
		return false;
	}

	// <summary>
	// Inserts the instance process activity.
	// </summary>
	// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
	// <param name="AtulProcessActivityID">The atul process activity ID.</param>
	// <param name="InstanceProcessActivityCompletedBy">The instance process activity completed by.</param>
	// <param name="CreatedBy">The created by.</param>
	public static function InsertInstanceProcessActivity($AtulInstanceProcessID, $AtulProcessActivityID, $InstanceProcessActivityCompletedBy, $CreatedBy) {
		$api = self::Login();
		$params = array('AtulInstanceProcessID' => $AtulInstanceProcessID, 'AtulProcessActivityID' => $AtulProcessActivityID, 'InstanceProcessActivityCompletedBy' => $InstanceProcessActivityCompletedBy, 'CreatedBy' => $CreatedBy);
		$result = $api->InsertInstanceProcessActivity($params);
		if ($result) {
			return json_decode($result['InsertInstanceProcessActivityResult']);
		}
		return false;
	}

	// <summary>
	// Sets the activity dead line.
	// </summary>
	public static function SetActivityDeadLine() {
		$api = self::Login();
		$params = array();
		$result = $api->SetActivityDeadLine($params);
		if ($result) {
			return json_decode($result['SetActivityDeadLineResult']);
		}
		return false;
	}

	// <summary>
	// Sets the activity man minutes.
	// TODO: Add man minute column, update proc(s)
	// </summary>
	public static function SetActivityManMinutes() {
		$api = self::Login();
		$params = array();
		$result = $api->SetActivityManMinutes($params);
		if ($result) {
			return json_decode($result['SetActivityManMinutesResult']);
		}
		return false;
	}

	// <summary>
	// Sets the activity prerequsite activity group.
	// TODO: Request proc to set prereq group Params: ActivityID, GroupID
	// </summary>
	public static function SetActivityPrerequsiteActivityGroup() {
		$api = self::Login();
		$params = array();
		$result = $api->SetActivityPrerequsiteActivityGroup($params);
		if ($result) {
			return json_decode($result['SetActivityPrerequsiteActivityGroupResult']);
		}
		return false;
	}

	// <summary>
	// Updates the instance process.
	// </summary>
	// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
	// <param name="AtulProcessID">The atul process ID.</param>
	// <param name="ModifiedBy">The modified by.</param>
	// <param name="OwnedBy">The owned by.</param>
	// <param name="AtulProcessStatusID">The atul process status ID.</param>
	public static function UpdateInstanceProcess($AtulInstanceProcessID, $AtulProcessID, $ModifiedBy, $OwnedBy, $AtulProcessStatusID, $SubjectIdentifier, $SubjectSummary, $SubjectServiceProviderID) {
		$api = self::Login();
		$params = array('AtulInstanceProcessID' => $AtulInstanceProcessID, 'AtulProcessID' => $AtulProcessID, 'ModifiedBy' => $ModifiedBy, 'OwnedBy' => $OwnedBy, 'AtulProcessStatusID' => $AtulProcessStatusID, 'SubjectIdentifier' => $SubjectIdentifier, 'SubjectSummary' => $SubjectSummary, 'SubjectServiceProviderID' => $SubjectServiceProviderID);

		$result = $api->UpdateInstanceProcess($params);

		if ($result) {
			return json_decode($result['UpdateInstanceProcessResult']);
		}
		return false;

	}

	// <summary>
	// Updates the instance process activity.
	// </summary>
	// <param name="AtulInstanceProcessActivityID">The atul instance process activity ID.</param>
	// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
	// <param name="AtulProcessActivityID">The atul process activity ID.</param>
	// <param name="ProcessActivityCompleted">The process activity completed.</param>
	// <param name="ProcessActivityDidNotApply">The process activity did not apply.</param>
	// <param name="ProcessActivityDeadlineMissed">The process activity deadline missed.</param>
	// <param name="InstanceProcessActivityCompletedBy">The instance process activity completed by.</param>
	// <param name="ModifiedBy">The modified by.</param>
	public static function UpdateInstanceProcessActivity($AtulInstanceProcessActivityID, $AtulInstanceProcessID, $AtulProcessActivityID, $ProcessActivityCompleted, $ProcessActivityDidNotApply, $ProcessActivityDeadlineMissed, $InstanceProcessActivityCompletedBy, $ModifiedBy) {
		$api = self::Login();
		$params = array('AtulInstanceProcessActivityID' => $AtulInstanceProcessActivityID, 'AtulInstanceProcessID' => $AtulInstanceProcessID, 'AtulProcessActivityID' => $AtulProcessActivityID, 'ProcessActivityCompleted' => $ProcessActivityCompleted, 'ProcessActivityDidNotApply' => $ProcessActivityDidNotApply, 'ProcessActivityDeadlineMissed' => $ProcessActivityDeadlineMissed, 'InstanceProcessActivityCompletedBy' => $InstanceProcessActivityCompletedBy, 'ModifiedBy' => $ModifiedBy);
		$result = $api->UpdateInstanceProcessActivity($params);
		if ($result) {
			return json_decode($result['UpdateInstanceProcessActivityResult']);
		}
		return false;
	}

	// <summary>
	// Updates the running process specification.
	// TODO: MAtch to docs, discuss with Cory
	// </summary>
	public static function UpdateRunningProcessSpecification() {
		$api = self::Login();
		$params = array();
		$result = $api->UpdateRunningProcessSpecification($params);
		if ($result) {
			return json_decode($result['UpdateRunningProcessSpecificationResult']);
		}
		return false;
	}

}
