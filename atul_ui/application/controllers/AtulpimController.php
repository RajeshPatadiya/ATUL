<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class AtulpimController extends Zend_Controller_Action {

	public function init() {
		/* Initialize action controller here */
		if ($this->getRequest()->isXmlHttpRequest()) {
			// disable layout if request is ajax call
			$this->_helper->layout->disableLayout();
		}
		$this->_redirector = $this->_helper->getHelper('Redirector');
	}

	public function instanceAction() {

		$user = Zend_Auth::getInstance()->getIdentity();
		$this->view->user = $user;
		$this->view->userID = $user->AtulUserID;
		$this->view->UTCOffset = Zend_Registry::get('UTCOffset');

		$this->view->pageName = 'Process Instance Manipulation';
		$this->view->headLink()->appendStylesheet('/css/atul.css?v=1');

		$this->view->headScript()->appendFile($this->view->baseUrl() . '/js/jquery/jquery.tableCorners.js');
		$this->view->headScript()->appendFile($this->view->baseUrl() . '/js/atulpim/atulpim.js');
		$this->view->headTitle('Process Instance Management');

		//Get the process id
		$this->view->processid = $this->_getParam('processid');
		//Get the process instance id
		$this->view->pid = $this->_getParam('pid');

		if (!is_null($this->view->processid) && is_null($this->view->pid)) {
			$status = ServiceManager_Process::GetAllStatus();
			$pid = ServiceManager_AtulWebServiceClient::CreateInstanceProcess($this->view->processid, $user->AtulUserID, $user->AtulUserID, $status[0]->AtulProcessStatusID);
			$this->_redirector->gotoUrl('/atulpim/instance/pid/'.$pid);
		}
		
		if (!is_null($this->view->pid)) {
			//Get instance info
			$this->view->instancejson = ServiceManager_AtulPimWebServiceClient::GetInstanceDetail($this->view->pid);
			$this->view->authorized = $user->isAuthorized($this->view->instancejson->Instance->atultblInstanceProcess->OwnedBy);
		}
	}

	public function completeactivityAction() {

		$this->_helper->layout->disableLayout();
		$user = Zend_Auth::getInstance()->getIdentity();
		$this->view->AtulInstanceProcessActivityID = $this->_getParam('AtulInstanceProcessActivityID');
		$this->view->statusBit = $this->_getParam('statusBit');
		$this->view->ModifiedBy = $user->AtulUserID;		
		$this->view->stepcomplete = ServiceManager_AtulPimWebServiceClient::InstanceProcessActivityComplete($this->view->AtulInstanceProcessActivityID, $this->view->statusBit, $this->view->ModifiedBy);
	}

	public function instanceownerformAction() {
		//$processId = $this->_getParam('processId');
		//$this->view->process = ServiceManager_Process::GetProcessByID($processId);
		$this->view->user = Zend_Auth::getInstance()->getIdentity();
		$this->view->groupList = DataManager_User::GetAllGroups();
		$userGroups = $this->view->user->getGroups();
		$gList = array();
		foreach ($userGroups as $g) {
			$gList[] = $g['DisplayName'];
		}
		$this->view->userList = DataManager_User::GetUsersInGroupList($gList);
		
	}

	public function updateinstanceownerAction() {
		$user = Zend_Auth::getInstance()->getIdentity();
		$instanceId = $this->_getParam('instanceId');
		$newOwner = $this->_getParam('newOwner');
		$result = new stdClass();
		$result->success = ServiceManager_AtulPimWebServiceClient::UpdateInstanceOwner($instanceId, $newOwner, $user->AtulUserID);
		$this->_helper->json($result);
	}

	//Atul_InstanceProcessActivityCompleteUpdate_sp
}

/*
 * GetProcessSubProcessDetailsBySubProcessID(string AtulSubProcessID)
 GetAllProcessSubProcessByProcessID(string AtulProcessSubprocessID)
 */
