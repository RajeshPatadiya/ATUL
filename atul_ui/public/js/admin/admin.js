/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
 */
$(function() {
	window.processData = new Object();
	// set up the process selector
	$('#instanceHeader').hide();
	createTreeMultiselect('#afterThis', 'processTree', processTreeData, null, false, function(element) {
		var id = $(element).attr('nodeID');
		$('#instanceActionIcons').attr('processid',id);
		$('#instanceSummarySpan').text('');
		$('#instanceCountSpan').text('');
		$('#instanceList').html('');
		loadProcessInstances(id);
	});
	$('#processTree').addClass('indented').show();
	$( "#admin_tabs").tabs({
		tabTemplate: "<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close'>Remove Tab</span></li>",
		add: function( event, ui ) {
			var tab_content = $tab_content_input.val() || "Tab " + tab_counter + " content.";
			$( ui.panel ).append( "<p>" + tab_content + "</p>" );
		}
	}).removeClass('ui-corner-all');
	$('#instanceEditAction').click(function(e){
		window.open('/process/editor/processid/' + $('#instanceActionIcons').attr('processid'));
	});
	$('#processOwnerAction').click(function(e){
		openOwnershipDialog('process', $('#instanceActionIcons').attr('processid'), e);
	});
	$('#processCreateAction').click(function(e){
		window.open('/wizard');
	});
	$('#instanceCreateAction').click(function(e){
		$.getJSON('/process/spawninstance/processId/' + $('#instanceActionIcons').attr('processid'), function(data) {
			loadProcessInstances($('#instanceActionIcons').attr('processid'));
			if (data.success){
				window.open('/atulpim/instance/pid/' + data.processInstanceId);
			}
		});
	});
	$('#instanceList li').live('click', function(e){
		var instanceProcessId = $(this).attr('instanceprocessid');
		window.open('/atulpim/instance/pid/' + instanceProcessId);
	});
	$('#processDeleteAction').live('click', deleteProcess);
	$('.deleteInstance').live('click', deleteInstance);
	$('.undeleteInstance').live('click', undeleteInstance);
	$('.undeleteProcess').live('click', undeleteProcess);
	$('.instanceProcessTitle').live('click', toggleDeletedInstances);
});
	
function loadProcessInstances(id){
	$.getJSON('/instance/getbyprocessid/processId/' + id, function(data) {
		var output = '';
		var buttons = '';
		var instanceCount = 0;
		if (!window.processData[id]){
			window.processData[id] = new Object();
			$.getJSON('/process/get/processId/' + id, function(data) {
				var processData = data;
				if (processData.AtulProcessID){
					window.processData[processData.AtulProcessID] = processData;
					$('#instanceSummarySpan').html(processData.ProcessSummary + ' -&nbsp;');
				}
			});
		} else {
			$('#instanceSummarySpan').html(window.processData[id].ProcessSummary + ' -&nbsp;');
		}
		$.each(data.success, function(key, val) {
			instanceCount++;
			buttons = '<span title="Edit Ownership" class="instanceOwnerAction" onclick="openOwnershipDialog(\'instance\', \'' + val.AtulInstanceProcessID + '\', event);">&nbsp;</span>';
			// list them in reverse order
			output = '<li instanceprocessid="' + val.AtulInstanceProcessID + '">' + $.trim(val.SubjectSummary + ' Created By ' + val.CreatedByName + ' on ' + val.CreatedDate) + ' ' + buttons + '<span class="deleteInstance" instanceId="'+val.AtulInstanceProcessID+'">&nbsp;</span></li>' + output;
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
		$('#instanceHeader').show();
		$('#instanceActionIcons').show();
		
	});
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

function undeleteInstance() {
	var row = $(this).parents('li.deletedInstance');
	var instanceId = $(this).attr('instanceid');
	$('<div title="Undelete Instance">Are you sure you wish to raise this instance from the dead so it can once again walk the earth?</div>')
		.dialog({
			close : function() {
				$(this).remove();
			},
			buttons : {
				Cancel : function() {
					$(this).dialog('close');
				},
				UnDelete : function() {
					var d = $(this);
					$.ajax({
						url: '/admin/undeleteinstance',
						data: {
							instanceId: instanceId
						},
						type: 'post',
						success: function(data) {
							d.dialog('close');
							row.remove();
						}
					});
				}
			}
		});
}

function undeleteProcess() {
	var row = $(this).parents('li');
	var processId = $(this).attr('processid');
	$('<div title="Undelete Process">Do you want raise this dead process from the grave?</div>')
		.dialog({
			close : function() {
				$(this).remove();
			},
			buttons : {
				Cancel : function() {
					$(this).dialog('close');
				},
				UnDelete : function() {
					var d = $(this);
					$.ajax({
						url: '/admin/undeleteprocess',
						data: {
							processId: processId
						},
						type: 'post',
						success: function(data) {
							d.dialog('close');
							row.remove();
						}
					});
				}
			}
		});
}

// Open dialog for updating ownership.
function openOwnershipDialog(type, id, e)
{
	// Prevent propagation to other click handlers
	if (!e) var e = window.event;
	e.cancelBubble = true;
	if (e.stopPropagation) e.stopPropagation();
	
	// Default and hide existing dialog.
	var url = "";
	var params = {};
	$("#edit_process_type").val(type)
	$("#edit_process_id").val(id)
	$("#edit_ownership_dialog").dialog("close")
	$("#select_ownership_type").val("")
	selectOwnershipType();
	
	if( type == 'process' )
	{
		url = '/admin/getprocessbyid';
		params = {processId: id};
	}
	else if( type == 'instance' )
	{
		url = '/admin/getinstancebyid';
		params = {instanceId: id};
	}
	else
		return;
	
	// Gather details for process or instance from server, and then open dialog.
	$.ajax({
		url : url,
		data: params,
		type: 'post',
		success: function(data) {
			if( data.success ) {
				$("#edit_ownership_member select").val("");
				$("#edit_ownership_group select").val("");
				var ownedBy = "";
				try {
					ownedBy = data.process.OwnedBy;
				} catch(e) {
					ownedBy = data.Instance.atultblInstanceProcess.OwnedBy;
				}
				if( ownedBy !== "" && ownedBy !== false )
				{
					$("#edit_ownership_member select").val(ownedBy);
					$("#edit_ownership_group select").val(ownedBy);
				}
				
				$("#edit_ownership_dialog").dialog({
					width: 600,
					height: 'auto',
					buttons: {
						Cancel : function() {
							$(this).dialog('close');
						},
						Save : function() {
							saveOwnership();
						}
					}
				});
			}
			else
				alert("There was a problem pulling information for this " + type);
		}
	});
}

function saveOwnership()
{
	var selectedType = $("#select_ownership_type").val();
	var owner = $("#edit_ownership_" + selectedType + " select").val();
	var url = "";
	var params = {}
	
	if( selectedType.length > 0 && owner.length > 0 && owner != 'undefined' )
	{
		if( $("#edit_process_type").val() == 'process' )
		{
			url = "/admin/updateprocessowner"
			params = {processId: $("#edit_process_id").val(), atulUserId: owner}
		}
		else if( $("#edit_process_type").val() == 'instance' )
		{
			url = "/admin/updateinstanceowner"
			params = {instanceId: $("#edit_process_id").val(), atulUserId: owner}
		}
		
		$.ajax({
			url : url,
			data: params,
			type: 'post',
			success: function(data) {
				if( data.success ) {
					alert('Edited Successfully');
					$("#edit_ownership_dialog").dialog("close");
				}
				else
					alert("An error was encountered when saving " + $("#edit_process_type").val());
			}
		});
	}
	else
		alert("Please select a valid owner.");
}

function toggleDeletedInstances(){
	var title = $(this);
	var process = title.parents('li.deletedInstanceProcess');
	if (title.hasClass('expanded')) {
		process.children('ul').hide();
		title.removeClass('expanded');
		title.addClass('collapsed');
	} else if (title.hasClass('collapsed')) {
		process.children('ul').show();
		title.removeClass('collapsed');
		title.addClass('expanded');
	}
	
}

function selectOwnershipType()
{
	var selectedType = $("#select_ownership_type").val();
	$(".ownership_type").hide();
	$("#edit_ownership_" + selectedType).show();
}