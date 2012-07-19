<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class ProcessController extends Zend_Controller_Action {
	public function init() {
		/* Initialize action controller here */
		if ($this->getRequest()->isXmlHttpRequest()) {
			// disable layout if request is ajax call
			$this->_helper->layout->disableLayout();
		}
	}

	public function editorAction() {
		$this->view->headTitle("Atul: Edit Process");
		$processId = $this->_getParam('processid');
		$this->view->pageName = "Process Editor";
		$this->view->headScript()->appendFile("/js/jquery/timepicker.js");
		$this->view->headScript()->appendFile("/js/jquery/jquery.bsmselect.js");
		$this->view->headScript()->appendFile("/js/process/editor.js");
		$this->view->headLink()->appendStylesheet("/css/jquery/timepicker.css");
		$this->view->headLink()->appendStylesheet("/css/process/editor.css");
		$this->view->headLink()->appendStylesheet("/css/jquery/jquery.bsmselect.css");
		$temp = ServiceManager_Atul::GetConfigVariablesByScriptName('helpText');
		$this->view->helpText = $this->view->processHelpText($temp->atulConfigVars);
		try {
			$this->view->process = ServiceManager_Process::GetProcessByID($processId);
			$this->view->flexfields = ServiceManager_Process::FlexFieldsGetByProcessID($processId);
		} catch (Exception $e) {
			$this->view->error = $e->getMessage();
		}
		if (isset($this->view->process)) {
// 		print_r($this->view->process);die();
			$this->view->providers = ServiceManager_Process::GetProviders();
			$subProcesses = ServiceManager_Process::GetSubProcessesByProcessID($processId);
			if ($subProcesses) {
				$this->view->process->subProcesses = $subProcesses;
			} else {
				// suppress warning
				$this->view->process->subProcesses = array();
			}
			foreach ($this->view->process->subProcesses as $subProcess) {
				$subProcess->activities = ServiceManager_Process::GetActivitiesBySubProcessID($subProcess->AtulSubProcessID);
			}
			$this->view->schedule = ServiceManager_Process::GetProcessScheduleByProcessID($processId);
			if ($this->view->schedule != null && $this->view->schedule != false) {
				$this->view->scheduler = new Scheduler();
				$this->view->scheduler->loadCronSchedule($this->view->schedule['RepeatSchedule']);
				$this->view->scheduler->parseCron();
			}
		}
		$this->view->user = Zend_Auth::getInstance()->getIdentity();
		$this->view->authorized = $this->view->user->isAuthorized($this->view->process->OwnedBy);
		$temp = ServiceManager_Atul::GetConfigVariablesByScriptName('helpText');
		$this->view->helpText = $this->view->processHelpText($temp->atulConfigVars);
		$processes = ServiceManager_Process::GetAllProcess()->atultblprocess;
		$this->view->prefixes = array();
		foreach ($processes as $process) {
			$name = $process->ProcessSummary;
			$nameparts = explode('.', $name);
			if (count($nameparts) > 1) {
				unset($nameparts[count($nameparts) - 1]);
				$prefix = implode('.', $nameparts);
				// search array case-insensitively for prefix value and push if doesn't exist
				if (!in_array(strtolower($prefix), array_map('strtolower', $this->view->prefixes))) {
					array_push($this->view->prefixes, $prefix);
				}
			}
		}
		natsort($this->view->prefixes);
	}

	public function getproviderparametersAction() {
		//(long providerId, int classid, string ProviderVerb)
		$providerId = $this->_getParam('providerId');
		$classId = $this->_getParam('classid');
		$ProviderVerb = $this->_getParam('ProviderVerb');
		$providerscope = ServiceManager_Process::GetProviderParameters($providerId, $classId, $ProviderVerb);
		$this->_helper->json($providerscope);
	}

	public function getsubjectproviderscopeAction() {
	$configVars = ServiceManager_Atul::GetSimpleConfigVariablesByScriptName('actorSettings');
		$configVars = Atul_Utility::setIfNotSet($configVars, 'queueMessageCheckTimeoutSeconds', 10);
		$providerID = $this->_getParam('providerid');
		$result = ServiceManager_AtulWebServiceClient::GetSubjectProviderScope(
			$providerID,
			$configVars['queueMessageCheckTimeoutSeconds']);
		if ($result == false){
			die('bad');
		} else {
			$xml = simplexml_load_string($result);
			$output = array();
			foreach($xml->response->scope->item as $item){
				$output[(string)$item->id[0]] = (string) $item->description[0];
			}
			$this->_helper->json($output);
		}
	}
	
	public function getsubjectformAction()
	{
		$this->view->hasSubject = false;
		$configVars = ServiceManager_Atul::GetSimpleConfigVariablesByScriptName('actorSettings');
		$configVars = Atul_Utility::setIfNotSet($configVars, 'queueMessageCheckTimeoutSeconds', 10);
		$processId = $this->_getParam('processId');
		$process = ServiceManager_Process::GetProcessByID($processId);
		if (isset($process->SubjectServiceProviderID) && $process->SubjectServiceProviderID != null && $process->SubjectServiceProviderID != 0) {
			$this->view->hasSubject = true;
			$scope = $process->SubjectScopeIdentifier;
			$providerID = $process->SubjectServiceProviderID;
			
			
			// call to getentities verb against provider
			$result = ServiceManager_AtulWebServiceClient::GetSubjectProviderEntites($providerID, $scope, $configVars['queueMessageCheckTimeoutSeconds']);
			
			if ($result == false) {
				die('bad');
			} else {
				$xml = simplexml_load_string($result);
				$output = array();
				
				foreach($xml->response->entities->item as $item) {
					$output[(string)$item->id[0]] = (string)$item->description[0];
				}
				$this->view->entities = $output;
				//$this->_helper->json($output);
			}
		}
	}

	public function processformAction() {
		$processId = $this->_getParam('processId');
		$this->view->process = ServiceManager_Process::GetProcessByID($processId);
		$this->view->statusList = ServiceManager_Process::GetAllStatus();
		$this->view->providers = ServiceManager_Process::GetProviders();
		
		$temp = ServiceManager_Atul::GetConfigVariablesByScriptName('helpText');
		$this->view->helpText = $this->view->processHelpText($temp->atulConfigVars);
	}

	public function subprocessformAction() {
		$subProcessId = $this->_getParam('subProcessId');
		$processId = $this->_getParam('processId');
		$this->view->subProcess = ServiceManager_Process::GetSubProcessByID($subProcessId);
		$this->view->processSubProcess = ServiceManager_Process::GetProcessSubProcessByProcessIDSubProcessID($processId, $subProcessId);
		$this->view->providers = ServiceManager_Process::GetProviders();
		$this->view->flexfields = ServiceManager_Process::FlexFieldGetBySearch(0, $subProcessId, 0);
		//parameters... flexfields or...

	}

	public function activityformAction() {
		$activityId = $this->_getParam('activityId');
		$processId = $this->_getParam('processId');
		$this->view->activity = ServiceManager_Process::GetActivityByID($activityId);
		$this->view->processActivity = ServiceManager_Process::GetProcessActivityByProcessIDActivityID($processId, $activityId);
		$this->view->deadlineTypeList = ServiceManager_Process::GetAllDeadlineType();
		$this->view->providers = ServiceManager_Process::GetProviders();
		$this->view->flexfields = ServiceManager_Process::FlexFieldGetBySearch(0, 0, $activityId);
	}

	public function addactivityformAction() {
		$this->view->subProcessId = $this->_getParam('subProcessId');
		$this->view->processId = $this->_getParam('processId');
		$this->view->deadlineTypeList = ServiceManager_Process::GetAllDeadlineType();
		$this->view->currentSort = $this->_getParam('currentSort');
	}

	public function addactivityAction() {
		$activity = $this->_getParam('activity');
		$subProcessId = $this->_getParam('subProcessId');
		$processId = $this->_getParam('processId');
		$result = new stdClass();
		$user = Zend_Auth::getInstance()->getIdentity();
		$result->username = $user->name;
		$result->activityId = ServiceManager_Process::CreateActivity($processId, $subProcessId, $activity['description'], $activity['summary'], $activity['procedure'], $activity['deadlineResultsInMissed'], $activity['sort'], $user->AtulUserID, $user->AtulUserID, $activity['deadline'], $activity['deadlineType']);
		if ((bool)$result->activityId) {
			$result->success = true;
		} else {
			$result->success = false;
		}
		$this->_helper->json($result);
	}

	public function addsubprocessformAction() {
		$this->view->processId = $this->_getParam('processId');
		$this->view->currentSort = $this->_getParam('currentSort');
	}

	public function addsubprocessAction() {
		$subProcess = $this->_getParam('subProcess');
		$processId = $this->_getParam('processId');
		$result = new stdClass();
		$user = Zend_Auth::getInstance()->getIdentity();
		$result->subProcessId = ServiceManager_Process::CreateSubProcess($processId, $subProcess['summary'], $subProcess['description'], $subProcess['sort'], null, $user->AtulUserID, $subProcess['deadline'], $user->AtulUserID, $user->AtulUserID);
		if ((bool)$result->subProcessId) {
			$result->processSubProcessId = ServiceManager_Process::GetProcessSubProcessByProcessIDSubProcessID($processId, $result->subProcessId)->AtulProcessSubprocessID;
			$result->success = true;
		} else {
			$result->success = false;
		}
		$this->_helper->json($result);
	}

	public function addscheduleformAction() {
		$this->view->processId = $this->_getParam('processId');
		$this->view->user = Zend_Auth::getInstance()->getIdentity();
		$this->view->groupList = DataManager_User::GetAllGroups();
		$this->view->userList = DataManager_User::GetUsersInGroupList(array_keys($this->view->user->getGroups()));
	}

	public function addscheduleAction() {
		$scheduleStart = $this->_getParam('scheduleStart');
		$repeat = $this->_getParam('repeat');
		$days = $this->_getParam('days');
		$owners = $this->_getParam('owners');
		$interval = $this->_getParam('interval');
		$processId = $this->_getParam('processId');
		$scheduleTimes = $this->_getParam('scheduleTimes');
		$user = Zend_Auth::getInstance()->getIdentity();
		$scheduler = new Scheduler($scheduleStart, $scheduleTimes, $repeat, $days, $interval);

		$cron = $scheduler->getCronSchedule();
		$schedule = ServiceManager_Process::ScheduleProcess($processId, $scheduler->getSerial($user->AtulUserID), $scheduleStart . ' ' . $scheduler->getTime(0), $scheduler->getCronSchedule(), implode(',', $owners));
		$scheduler->loadCronSchedule($schedule['RepeatSchedule']);
		$result = new stdClass();
		if ($schedule != null && $schedule != false) {
			$result->success = true;
			$result->scheduleId = $schedule['AtulProcessScheduleID'];
			$result->nextScheduled = Scheduler::parseDate($schedule['NextScheduledDate']);
			$result->scheduleString = $scheduler->getScheduleText();
		} else {
			$result->success = false;
		}
		$this->_helper->json($result);

	}

	public function deletescheduleAction() {
		$scheduleId = $this->_getParam('scheduleId');
		$result = new stdClass();
		$result->success = ServiceManager_Process::DeleteProcessSchedule($scheduleId);
		$this->_helper->json($result);
	}

	public function updateprocessAction() {
		$process = $this->_getParam('process');
		$result = new stdClass();
		$user = Zend_Auth::getInstance()->getIdentity();
		$result->success = ServiceManager_Process::UpdateProcess($process['id'], $process['description'], $process['summary'], $user->AtulUserID, $process['owner'], $process['status'], $process['deadline'], $process['provider'], $process['providerScope']);
		$this->_helper->json($result);
	}

	public function updatesubprocessAction() {
		$subProcess = $this->_getParam('subProcess');
		$processId = $this->_getParam('processId');
		if (isset($subProcess['flexfields'])) {
			self::upsertFlexFields($subProcess['flexfields'], "0", $subProcess['id'], "0");
		}
		if(isset($subProcess['parameters'])){
			self::upsertParameters($subProcess['parameters'], "0", $subProcess['id'], "0");
		}
		$result = new stdClass();
		$user = Zend_Auth::getInstance()->getIdentity();
		$processSubProcess = ServiceManager_Process::GetProcessSubProcessByProcessIDSubProcessID($processId, $subProcess['id']);

		$result->success = ServiceManager_Process::UpdateSubProcess($subProcess['id'], $subProcess['description'], $subProcess['summary'], $user->AtulUserID, $user->AtulUserID);
		if ($result->success) {
			$subProcess = Atul_Utility::setIfNotSet($subProcess, 'provider', null);
			$result->success = ServiceManager_Process::UpdateProcessSubProcess($processSubProcess->AtulProcessSubprocessID, $processSubProcess->AtulProcessID, $processSubProcess->AtulSubProcessID, $processSubProcess->ProcessSubprocessSortOrder, $user->AtulUserID, (int)$subProcess['deadline'], $user->AtulUserID, $subProcess['provider']);
		} else {
			error_log("Error Updating SubProcess with: " . $subProcess['id'] . ', ' . $subProcess['description'] . ', ' . $subProcess['summary'] . ', ' . $user->AtulUserID . ', ' . $user->AtulUserID, 0);
		}
		//if $subProcess['provider'], get provider parameters, add provider flexfields
		$this->_helper->json($result);
	}

	public function updateactivityAction() {
		$activity = $this->_getParam('activity');
		if (isset($activity['flexfields'])) {
			self::upsertFlexFields($activity['flexfields'], "0", "0", $activity['id']);
		}
		$result = new stdClass();
		$user = Zend_Auth::getInstance()->getIdentity();
		$result->success = ServiceManager_Process::UpdateActivity($activity['id'], $activity['subProcessId'], $activity['description'], $activity['summary'], $activity['procedure'], $activity['sort'], $user->AtulUserID, $user->AtulUserID);
		if ($result->success) {
			//$activity['provider']
			$result->success = ServiceManager_Process::UpdateProcessActivity($activity['processActivityId'], $activity['processId'], $activity['id'], $activity['sort'], $activity['deadlineResultsInMissed'], $activity['deadlineType'], $activity['deadline'], $user->AtulUserID, 0);
		}
		$this->_helper->json($result);
	}

	private function upsertFlexFields($ffields, $AtulProcessID = "", $AtulSubProcessID = "", $AtulActivityID = "") {
		foreach ($ffields as $value) {
			ServiceManager_Process::FlexFieldUpsert($value['tokenname'], $value['fieldRequired'], -1, $AtulProcessID, $AtulSubProcessID, $AtulActivityID, $value['defaultvalue'], $value['fieldName'], $value['tooltip'], (int)$value['IsParameter']);
		}
	}
	private function upsertParameters($ffields, $AtulProcessID = "", $AtulSubProcessID = "", $AtulActivityID = "") {
		foreach ($ffields as $value) {
			ServiceManager_Process::FlexFieldUpsert($value['tokenname'], 1, -1, $AtulProcessID, $AtulSubProcessID, $AtulActivityID, $value['defaultvalue'], $value['fieldName'], "", 1);
		}
	}
	public function updateflexfieldstorageAction() {
		$AtulInstanceProcessID = $this->_getParam('iid');
		$AtulFlexFieldID = $this->_getParam('ffid');
		$tokenValue = $this->_getParam('tv');
		$CreatedBy = "-1";
		ServiceManager_Process::FlexFieldStorageInsert("$AtulInstanceProcessID", $AtulFlexFieldID, $tokenValue, $CreatedBy);
		//We use the insert proc, but it works like an upsert
		//FlexFieldStorageInsert(string AtulInstanceProcessID, long AtulFlexFieldID, string tokenValue, string CreatedBy)
	}

	public function updatesubprocesssortAction() {
		$processSubProcessId = $this->_getParam('processSubProcessId');
		$sort = $this->_getParam('sort');

		$result = new stdClass();
		$user = Zend_Auth::getInstance()->getIdentity();
		$result->success = ServiceManager_Process::UpdateProcessSubProcessSort($processSubProcessId, $sort, $user->AtulUserID);

		$this->_helper->json($result);
	}

	public function updateactivitysortAction() {
		$activityId = $this->_getParam('activityId');
		$sort = $this->_getParam('sort');
		$result = new stdClass();
		$user = Zend_Auth::getInstance()->getIdentity();
		$result->success = ServiceManager_Process::UpdateActivitySort($activityId, $sort, $user->AtulUserID);
		$this->_helper->json($result);
	}

	public function deletesubprocessAction() {
		$subProcessId = $this->_getParam('subProcessId');
		$user = Zend_Auth::getInstance()->getIdentity();
		$result = new stdClass();
		$result->success = ServiceManager_Process::DeleteSubProcess($subProcessId, $user->AtulUserID);
		$this->_helper->json($result);
	}

	public function deleteactivityAction() {
		$activityId = $this->_getParam('activityId');
		$user = Zend_Auth::getInstance()->getIdentity();
		$result = new stdClass();
		$result->success = ServiceManager_Process::DeleteActivity($activityId, $user->AtulUserID);
		$this->_helper->json($result);
	}

	public function getAction() {
		$processId = $this->_getParam('processId');
		$user = Zend_Auth::getInstance()->getIdentity();
		$result = new stdClass();
		$result = ServiceManager_Process::GetProcessByID($processId);
		$result->authorized = $user->isAuthorized($result->OwnedBy);
		$this->_helper->json($result);
	}

	public function spawninstanceAction() {
		$processId = $this->_getParam('processId');
		$subjectId = $this->_getParam('subjectInstanceId');
		$subjectSummary = $this->_getParam('subjectSummary');
		$user = Zend_Auth::getInstance()->getIdentity();
		$status = ServiceManager_Process::GetAllStatus();
		$result = new stdClass();
		$result->processInstanceId = ServiceManager_AtulWebServiceClient::CreateInstanceProcess($processId, $user->AtulUserID, $user->AtulUserID, $status[0]->AtulProcessStatusID, $subjectId, $subjectSummary);
		if ((bool)$result->processInstanceId) {
			$result->success = true;
		} else {
			$result->success = false;
		}
		if ($this->getRequest()->isXmlHttpRequest()) {
			$this->_helper->json($result);
		}
		$this->view->instanceId = $result->processInstanceId;
	}

	public function updateproviderAction() {
		$AtulServiceProviderID = $this->_getParam('AtulServiceProviderID');
		$ServiceProviderName = $this->_getParam('ServiceProviderName');
		$ServiceProviderDescription = $this->_getParam('ServiceProviderDescription');
		$AtulServiceProviderClassID = $this->_getParam('AtulServiceProviderClassID');
		$WSDL = $this->_getParam('WSDL');
		$DSN = $this->_getParam('DSN');
		$user = Zend_Auth::getInstance()->getIdentity();
		$CreatedBy = $user->AtulUserID;
		$result = new stdClass();
		$result->success = ServiceManager_Process::DeleteActivity($AtulServiceProviderID, $ServiceProviderName, $ServiceProviderDescription, $AtulServiceProviderClassID, $WSDL, $DSN, $CreatedBy);
		$this->_helper->json($result);
	}

	public function insertproviderAction() {
		$ServiceProviderName = $this->_getParam('ServiceProviderName');
		$ServiceProviderDescription = $this->_getParam('ServiceProviderDescription');
		$AtulServiceProviderClassID = $this->_getParam('AtulServiceProviderClassID');
		$WSDL = $this->_getParam('WSDL');
		$DSN = $this->_getParam('DSN');
		$user = Zend_Auth::getInstance()->getIdentity();
		$CreatedBy = $user->AtulUserID;
		$result = new stdClass();
		$result->success = ServiceManager_Process::InsertProvider($ServiceProviderName, $ServiceProviderDescription, $AtulServiceProviderClassID, $WSDL, $DSN, $CreatedBy);
		$this->_helper->json($result);
	}

	public function describeactorAction() {
		$queue = $this->_getParam('queue');
		$providerXML = ServiceManager_AtulWebServiceClient::DescribeActor($queue);
		$this->view->providerXML = $providerXML;
	}

	public function upsertproviderAction() {
		$XML = $this->_getParam('eXML');
		$WSDL = $this->_getParam('wsdl');
		$DSN = $this->_getParam('dsn');
		$newproviders = new SimpleXMLElement($XML);
		$this->view->providers = ServiceManager_Process::GetProviders();
		$user = Zend_Auth::getInstance()->getIdentity();
		$result = new stdClass();
		$this->view->providerxml = "None Updated";
		//Check each potential new provider to see if existing
		foreach ($newproviders->provider as $p) {
			$update = false;
			foreach ($this->view->providers as $ep) {
				//If new provider matches existing provider, update
				if (($p->classid == $ep->AtulServiceProviderClassID) && ($WSDL == $ep->wsdl) && ($DSN == $ep->dsn) && ($p->verb == $ep->verb)) {
					$update = true;

					$result->success = ServiceManager_Process::UpdateProvider($ep->AtulServiceProviderID, $p->name, $p->description, $p->classid, $WSDL, $DSN, $p->verb, $user->AtulUserID, $XML);
				}
			}
			//If we didn't update, we need to add
			if (!$update) {
				$this->view->providerxml .= $p->name . "| ";
				$ServiceProviderName = $p->name;
				$ServiceProviderDescription = $p->description;
				$AtulServiceProviderClassID = $p->classid;
				$ServiceProviderXML = $XML;
				$result->success = ServiceManager_Process::InsertProvider($p->name, $p->description, $p->classid, $WSDL, $DSN, $user->AtulUserID, $p->verb, $XML);

			}
		}

	}

	public function getproviderselectAction() {
		$this->view->class = $this->_getParam('classid');
		$this->view->proid = $this->_getParam('proid');
		$this->view->providers = ServiceManager_Process::GetProviders();
	}

	//this will currently only handle activities. Watch her for some thing wonderful
	public function getflexfieldsAction() {
		$this->view->id = $this->_getParam('id');
		//classID relates to provider levels, i.e class 1 = process, 2 = subprocess, 3 = activity
		$this->view->class = $this->_getParam('class');
		$this->view->flexfields = ServiceManager_Process::FlexFieldGetBySearch(0, 0, $this->_getParam('id'));
	}

	public function deleteflexfieldAction() {
		$AtulFlexFieldID = $this->_getParam('ffid');
		$result->success = ServiceManager_Process::FlexFieldDelete($AtulFlexFieldID, -1);
	}

	public function processownerformAction() {
		$processId = $this->_getParam('processId');
		$this->view->process = ServiceManager_Process::GetProcessByID($processId);
		$this->view->user = Zend_Auth::getInstance()->getIdentity();
		$this->view->groupList = DataManager_User::GetAllGroups();
		$userGroups = $this->view->user->getGroups();
		$gList = array();
		foreach ($userGroups as $g) {
			$gList[] = $g['DisplayName'];
		}
		$this->view->userList = DataManager_User::GetUsersInGroupList($gList);
	}

	public function updateprocessownerAction() {
		$user = Zend_Auth::getInstance()->getIdentity();
		$processId = $this->_getParam('processId');
		$newOwner = $this->_getParam('newOwner');
		$result = new stdClass();
		$result->success = ServiceManager_Process::UpdateUserForProcess($processId, $newOwner, $user->AtulUserID);
		$this->_helper->json($result);
	}

}
