<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class AdminController extends Zend_Controller_Action
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
		$this->view->pageName = "Admin Editor";
		$this->view->headScript()->appendFile("/js/admin/admin.js");
		$this->view->headScript()->appendFile("/js/treemultiselect.js");
		$this->view->headLink()->appendStylesheet("/css/treemultiselect.css");
		$this->view->headLink()->appendStylesheet("/css/admin/admin.css");
		$config = Zend_Registry::get('config');
		$adminrole = $config->roles->general->admin;
		$deletedDays = $config->deleted->daysback;
		$this->view->authorized = Zend_Auth::getInstance()->getIdentity()->hasGroup($adminrole);
		$this->view->statusList = ServiceManager_Process::GetAllStatus();
		$this->view->processes = ServiceManager_Process::GetAllProcess()->atultblprocess;
		$this->view->allGroups = DataManager_User::GetAllGroups();
		$this->view->allUsers = DataManager_User::GetAllUsers();
		$this->view->deletedProcesses = ServiceManager_Process::GetDeletedProcesses($deletedDays);
		$this->view->deletedInstances = ServiceManager_Instance::GetDeletedInstances($deletedDays);
	}
	
	public function getinstancebyidAction()
	{
		$instanceId = $this->_getParam('instanceId');
		$result = new stdClass();
		$result = ServiceManager_AtulPimWebServiceClient::GetInstanceDetail($instanceId);
		$result->success = isset($result->Instance->atultblInstanceProcess->AtulInstanceProcessID) ? true : false;
		$this->_helper->json($result);
	}
	
	public function getprocessbyidAction()
	{
		$processId = $this->_getParam('processId');
		$result = new stdClass();
		$result->process = ServiceManager_Process::GetProcessByID($processId);
		$result->success = isset($result->process->AtulProcessID) ? true : false;
		$this->_helper->json($result);
	}
	
	public function updateinstanceownerAction()
	{
		$instanceId = $this->_getParam('instanceId');
		$newOwnerId = $this->_getParam('atulUserId');
		$result = new stdClass();
		$user = Zend_Auth::getInstance()->getIdentity();
		$result->success = ServiceManager_AtulPimWebServiceClient::UpdateInstanceOwner($instanceId, $newOwnerId, $user->AtulUserID);
		$this->_helper->json($result);
	}
	
	public function updateprocessownerAction()
	{
		$processId = $this->_getParam('processId');
		$newOwnerId = $this->_getParam('atulUserId');
		$result = new stdClass();
		$user = Zend_Auth::getInstance()->getIdentity();
		$result->success = ServiceManager_Process::UpdateUserForProcess($processId, $newOwnerId, $user->AtulUserID);
		$this->_helper->json($result);
	}
	
	public function undeleteinstanceAction()
	{
		$instanceId = $this->_getParam('instanceId');
		$user = Zend_Auth::getInstance()->getIdentity();
		$result = new stdClass();
		$result->success = ServiceManager_Instance::UndeleteInstance($instanceId, $user->id);
		$this->_helper->json($result);
	}
	
	public function undeleteprocessAction()
	{
		$processId = $this->_getParam('processId');
		$user = Zend_Auth::getInstance()->getIdentity();
		$result = new stdClass();
		$result->success = ServiceManager_Process::UndeleteProcess($processId, $user->id);
		$this->_helper->json($result);
	}
}
