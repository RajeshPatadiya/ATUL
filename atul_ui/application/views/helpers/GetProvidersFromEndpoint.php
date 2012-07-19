<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class Atul_View_Helper_GetProvidersFromEndpoint {
	protected $view;

	public function setView($view) {
		$this -> view = $view;
	}

	public function getProvidersFromEndpoint($accordion) {
		$accordionField = '<input type="hidden" id="providerAccordion" name="providerAccordion" value="' . $accordion . '" />';
		$form = <<<pform
<fieldset>
	<label for="providerQueue">Endpoint Queue:
		<input type="text" name="providerQueue" id="providerQueue" class="input" size="50"/>
		<div class="example" id="providerQueueExample">Example: myapp.actor</div>
	</label>
	<button id="describeprovider" type="button">
		Add Endpoint Providers
	</button>
	<span id="subjectERR"></span>
</fieldset>
pform;
		return $form . $accordionField;
	}

}
?>

