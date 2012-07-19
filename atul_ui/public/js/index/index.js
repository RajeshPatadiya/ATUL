/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
$(function() {
	window.processData = new Object();
	// set up the process selector
	$('#instanceHeader').hide();
	var user = $('#cx_loggedInUser').val();
	var history = getUserHistory(user);
	if (history != null) {
		for (var u = history.processes.length - 1; u >= 0; u--) {
			$('<li><a href="'+history.processes[u].url+'" target="_blank">'+history.processes[u].title+'</a></li>').appendTo('#processHistory');
		}
		for (var u = history.instances.length - 1; u >= 0 ; u--) {
			$('<li><a href="'+history.instances[u].url+'" target="_blank">'+history.instances[u].title+'</a></li>').appendTo('#instanceHistory');
		}
	}
	createTreeMultiselect('#afterThis', 'processTree', processTreeData, null, false, function(element) {
		var id = $(element).attr('nodeID');
		$('#instanceActionIcons').attr('processid',id);
		$('#instanceSummarySpan').text('');
		$('#instanceCountSpan').text('');
		$('#instanceList').html('');
		loadProcessInstances(id);
	});
	sortProcessList();
	$('#processTree').addClass('indented').show();
	
	$('#instanceEditAction').click(function(e){
		window.open('/process/editor/processid/' + $('#instanceActionIcons').attr('processid'));
	});
	$('#processCreateAction').click(function(e){
		window.open('/wizard');
	});
	$('#instanceCreateAction').click(function(e){
		$('<div id="instanceCreatePopup" title="Subject of Checklist">Loading List...<img src="/img/loading65.gif" /></div>').dialog({
			close : function() {
				$(this).remove();
			},
			buttons: {
				Cancel: function(){
					$(this).dialog('close');
				},
				OK: function(){
					var d = $(this);
					var processId = $('#instanceActionIcons').attr('processid');
					var subjectInstanceId = null;
					var subjectInstanceSummary = null;
					if ($('#subjectInstance').hasClass('selecty')) {
						subjectInstanceId = $('#subjectInstance').val();
						subjectInstanceSummary = $('#subjectInstance option:selected').text();
					} else {
						subjectInstanceSummary = $('#subjectInstance').val();
					}
					$.ajax({
						url: '/process/spawninstance/',
						type: 'post',
						data: {
							processId: processId,
							subjectInstanceId: subjectInstanceId,
							subjectSummary: subjectInstanceSummary
						},
						success: function(data) {
							
							loadProcessInstances($('#instanceActionIcons').attr('processid'));
							if (data.success){
								window.open('/atulpim/instance/pid/' + data.processInstanceId);
								d.dialog('close');
							}
						}
					});
				}
			},
			width: 400
		});
		var processId = $('#instanceActionIcons').attr('processid');
		var d = $(this);
		$.ajax({
			url: '/process/getsubjectform',
			type: 'post',
			data: { 
				processId: processId
			},
			success: function(data) {
				$('#instanceCreatePopup').html(data);
				$('select#subjectInstance').select2();
			}
		});
	
			
		
		
		
	});
	$('#instanceList li').live('click', function(e){
		var instanceProcessId = $(this).attr('instanceprocessid');
		window.open('/atulpim/instance/pid/' + instanceProcessId);
	});
	$('#processDeleteAction').live('click', deleteProcess);
	$('.deleteInstance').live('click', deleteInstance);
	
});
	
function loadProcessInstances(id){
	$.getJSON('/instance/getbyprocessid/processId/' + id, function(data) {
		var output = '';
		var instanceCount = 0;
		if (!window.processData[id]){
			window.processData[id] = new Object();
			$.getJSON('/process/get/processId/' + id, function(data) {
				var processData = data;
				if (processData.AtulProcessID){
					window.processData[processData.AtulProcessID] = processData;
					$('#instanceSummarySpan').html(processData.ProcessSummary + ' -&nbsp;');
					if (processData.authorized) {
						$('#instanceCreateAction').show();
						$('#processDeleteAction').show();
					} else {
						$('#instanceCreateAction').hide();
						$('#processDeleteAction').hide();
					}
					$('#selectedSubjectProviderID').val(processData.SubjectServiceProviderID);
					$('#selectedSubjectScopeID').val(processData.SubjectScopeIdentifier);
				}
			});
		} else {
			$('#instanceSummarySpan').html(window.processData[id].ProcessSummary + ' -&nbsp;');
			$('#selectedSubjectProviderID').val(processData[id].SubjectServiceProviderID);
			$('#selectedSubjectScopeID').val(processData[id].SubjectScopeIdentifier);
		}
		$.each(data.success, function(key, val) {
			instanceCount++;
			// list them in reverse order
			var l = '<li instanceprocessid="' + val.AtulInstanceProcessID + '">' + $.trim(val.SubjectSummary + ' Created By ' + val.CreatedByName + ' on ' + val.CreatedDate);
			if (val.authorized) {
				l = l + '<span class="deleteInstance" instanceId="'+val.AtulInstanceProcessID+'">&nbsp;</span>';
			} 
			l = l + '</li>';
			output =  l + output;
		});
		$('#instanceList').html(output);
		if (instanceCount == 0){
			if (window.processData[id].ProcessSummary){
				$('#instanceSummarySpan').text(window.processData[id].ProcessSummary + ' - ');
			}
			$('#instanceCountSpan').text('No Instances');
		} else {
			$('#instanceCountSpan').text(instanceCount + ' Instances');
		}
		$('#instanceActionIcons').show();
	});
	$('#instanceHeader').show();
}
function deleteProcess() {
	var processId = $('#instanceActionIcons').attr('processid');
	$('<div title="Delete Process?">Are you sure you want to delete this process?</div>')
		.appendTo('body').dialog({
			close : function() {
				$(this).remove();
			},
			buttons : {
				Cancel : function() {
					$(this).dialog('close');
				},
				Save : function() {
					var d = $(this);
					$.ajax({
						url: '/index/deleteprocess',
						type: 'post',
						data: { 
							processId: processId
						},
						success: function(data) {
							if (data.success) {
								var item = $('li[nodeid='+processId+']');
								item.remove();
								$('#instanceHeader').hide();
								$('#instanceList').html('');
								d.dialog('close');
							}
							
						}
					});
				}
			}
		});
	return false;
}

function deleteInstance() {
	var instanceId = $(this).attr('instanceId');
	$('<div title="Delete Instance?">Are you sure you want to delete this process instance?</div>')
		.appendTo('body').dialog({
			close : function() {
				$(this).remove();
			},
			buttons : {
				Cancel : function() {
					$(this).dialog('close');
				},
				Save : function() {
					var d = $(this);
					$.ajax({
						url: '/index/deleteinstance',
						type: 'post',
						data: { 
							instanceId: instanceId
						},
						success: function(data) {
							if (data.success) {
								var processId = $('#instanceActionIcons').attr('processid');
								loadProcessInstances(processId);
								d.dialog('close');
							}
							
						}
					});
				}
			}
		});
	return false;
}
function sortProcessList(){
	var myP = $('div.treemultimenutext').filter(function(index){ return $(this).text() == 'My Processes'; }).parent();
	var groupP = $('div.treemultimenutext').filter(function(index){ return $(this).text() == "My Groups' Processes"; }).parent();
	if (myP != null && myP != 'undefined' && groupP != null && groupP != '') {
		myP.insertBefore(groupP);
	}
}