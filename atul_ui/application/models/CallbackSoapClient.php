<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class CallbackSoapClient extends SoapClient
{
	protected $open_callback;
	protected $close_callback;
	public function __construct($wsdl, $options)
	{
		parent::__construct($wsdl, $options);
		$this->open_callback = (isset($options['open_callback']) ?  $options['open_callback'] : null);
		$this->close_callback = (isset($options['close_callback']) ?  $options['close_callback'] : null);
		if ($this->open_callback != null) {
			call_user_func($this->open_callback, $this);
		}
	}

	public function __destruct()
	{
		try{
			if ($this->close_callback != null) {
				call_user_func($this->close_callback, $this);
			}
			parent::__destruct();
		}catch(Exception $e){
			//print $e->getMessage();
		}
	}

}

?>