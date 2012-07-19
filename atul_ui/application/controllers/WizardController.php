<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class WizardController extends Zend_Controller_Action 
{

	public function init() 
	{
		/* Initialize action controller here */
		if ($this->getRequest()->isXmlHttpRequest()) {
			// disable layout if request is ajax call
			$this->_helper->layout->disableLayout();
		}
	}

	public function indexAction() 
	{
		$this->view->headTitle("Atul: Create New Process...");
		$this->view->headScript()->appendFile("/js/jquery/jquery.smartWizard-2.0.min.js");
		$this->view->headScript()->appendFile("/js/wizard/wizard.js");
		$this->view->headLink()->appendStylesheet("/css/jquery/smart_wizard.css");
		$this->view->headLink()->appendStylesheet("/css/wizard/wizard.css");
		$this->view->pageName = 'Wizard';
		$this->view->statusList = ServiceManager_Process::GetAllStatus();
		$temp = ServiceManager_Atul::GetConfigVariablesByScriptName('helpText');
		$this->view->helpText = $this->view->processHelpText($temp->atulConfigVars);
		$processes = ServiceManager_Process::GetAllProcess()->atultblprocess;
		$this->view->prefixes = array();
		foreach ($processes as $process) {
			$name = $process->ProcessSummary;
			$nameparts = explode('.', $name);
			if (count($nameparts) > 1) {
				unset($nameparts[count($nameparts) - 1]);
				$prefix = implode('.',$nameparts);
				// search array case-insensitively for prefix value and push if doesn't exist
				if (!in_array(strtolower($prefix), array_map('strtolower', $this->view->prefixes))) {
					array_push($this->view->prefixes, $prefix);
				}
			}
		}
		natsort($this->view->prefixes);		
	}
	
	public function activityformAction()
	{
		$this->view->deadlineTypeList = ServiceManager_Process::GetAllDeadlineType();
		$this->view->currentSort = $this->_getParam('currentSort');
	}
	
	public function createprocessAction() 
	{
		$process = $this->_getParam('process');
		$user = Zend_Auth::getInstance()->getIdentity();
		$result = new stdClass();
		$result->success = true;
		try {
			$empty = true;
			if (isset($process['subProcesses']) && count($process['subProcesses']) > 0) {
				$existingProcess = ServiceManager_Process::GetProcessBySummary($process['summary']);
				if ($existingProcess == null) {
					$result->processId = ServiceManager_Process::CreateProcess($process['description'], $process['summary'], 
						$user->AtulUserID, $user->AtulUserID, $process['status'], $process['deadline']); 
					if ($result->processId) {
						foreach ($process['subProcesses'] as $subProcess) {
							$subProcessId = ServiceManager_Process::CreateSubProcess($result->processId, 
								$subProcess['summary'], $subProcess['description'],
								(int)$subProcess['sort'], null, (int)$user->AtulUserID, (int)$subProcess['deadline'], (int)$user->AtulUserID, (int)$user->AtulUserID);
							if ($subProcessId) {
								if (isset($subProcess['activities']) && is_array($subProcess['activities'])){
									foreach ($subProcess['activities'] as $activity) {
										$activityId = ServiceManager_Process::CreateActivity($result->processId, $subProcessId, $activity['description'], 
											$activity['summary'], $activity['procedure'], $activity['deadlineResultsInMissed'], $activity['sort'], 
											$user->AtulUserID, $user->AtulUserID, $activity['deadline'], $activity['deadlineType']);
										if (!$activityId) {
											$result->success = false;
											$result->message = "Creating activity failed.";
										}
									}
								}
							} else {
								$result->success = false;
								$result->message = "Creating SubProcess failed.";
							}
						}
					} else {
						$result->success = false;
						$result->message = "Call to create process failed.";
					}
				} else {
					$result->success = false;
					$result->message = "A Process already exists with that same Summary";
				}
			} else {
				$result->success =false;
				$result->message = "Cannot create a process with no subprocesses";
			}
		} catch (Exception $e) {
			$result->success = false;
			$result->message = $e->getMessage();
		}
		$this->_helper->json($result);
	}
	
	public function checkprocessnameAction()
	{
		$summary = $this->_getParam('summary');
		$processId = $this->_getParam('processId');
		$summaryParts = explode('.', $summary);
		$result = new stdClass();
		$result->exists = false;
		while (count($summaryParts) >= 1) {
			$toCheck = implode('.', $summaryParts);
			$process = ServiceManager_Process::GetProcessBySummary($toCheck);
			if ($process != null) {
				if ($processId == null || $process['AtulProcessID'] != $processId) {
					$result->exists = true;
				}
			}
			array_pop($summaryParts);
		}
		$this->_helper->json($result);
	}
}
