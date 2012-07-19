<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class IndexController extends Zend_Controller_Action 
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
		$this->view->headTitle("Atul: Accuracy Through the Use of Lists");
		$this->view->headScript()->appendFile("/js/index/index.js");
		$this->view->headScript()->appendFile("/js/treemultiselect.js");
		$this->view->headLink()->appendStylesheet("/css/treemultiselect.css");
		$this->view->headLink()->appendStylesheet("/css/index/index.css");
		$this->view->pageName = 'Explorer';
		$this->view->statusList = ServiceManager_Process::GetAllStatus();
		$this->view->processes = ServiceManager_Process::GetAllProcess()->atultblprocess;
		$this->view->user = Zend_Auth::getInstance()->getIdentity();
		ServiceManager_Process::FilterProcessesForUser($this->view->user, $this->view->processes);
	}
	
	public function deleteprocessAction()
	{
		$processId = $this->_getParam('processId');
		$user = Zend_Auth::getInstance()->getIdentity();
		$result = new stdClass();
		$result->success = ServiceManager_Process::DeleteProcess($processId, $user->AtulUserID);
		$this->_helper->json($result);
	}
	
	public function deleteinstanceAction()
	{
		$instanceId = $this->_getParam('instanceId');
		$user = Zend_Auth::getInstance()->getIdentity();
		$result = new stdClass();
		$result->success = ServiceManager_AtulWebServiceClient::DeleteInstanceProcess($instanceId, $user->AtulUserID);
		$this->_helper->json($result);
	}
}
