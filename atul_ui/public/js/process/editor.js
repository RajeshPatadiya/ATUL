/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
var tooltipfired = false;
var obsoleteParameters = [];
$(function() {
	window.onbeforeunload = confirmUnload;
	// setting cookie data in history
	$('#processSummary').live('change', checkProcessName);
	var user = $('#cx_loggedInUser').val();
	var processId = $('#processInfo').attr('processId');
	var title = $('#instancetitle').text();
	var tooltipfired = false;
	updateUserHistory(user, 'process', processId, title);
	$("input.number").live("keydown", function(e) {
		var key = e.charCode || e.keyCode || 0;
		// allow backspace, tab, delete, arrows, numbers and keypad numbers ONLY
		return (key == 8 || key == 9 || key == 46 || (key >= 37 && key <= 40) || (key >= 48 && key <= 57) || (key >= 96 && key <= 105));
	});
	if(!$.browser.msie || jQuery.browser.version.substring(0, 2) != "8.") {
		$('#processEditor[class="auth"]').sortable({
			items : 'tbody',
			axis : 'y',
			handle : 'tr.subprocesstitle',
			update : readySort,
			opacity : 0.7,
			helper : "clone"
		});

		$('tbody.subProcess.auth').sortable({
			items : 'tr.activity',
			axis : 'y',
			containment : 'parent',
			update : readySort,
			opacity : 0.7,
			helper : "clone"
		});
	}
	$('#btnAdd').live('click', function() {
		//enter flexfield
		AddFlexFieldDialog();
		window.newff.dialog('open');
		return false;
	});
	$('.activity span.moveup').live('click', moveActivityUp);
	$('.activity span.movedown').live('click', moveActivityDown);
	$('.subprocesshead span.moveup').live('click', moveSubProcessUp);
	$('.subprocesshead span.movedown').live('click', moveSubProcessDown);
	$('#cancelUpdateSort').live('click', function() {
		$('#message').html('');
		window.location.reload();
	});
	$('#updateSort').live('click', updateSort);
	$('#editProcess, #processInfo:not(.uauth)').live('click', doProcessForm);
	$('.subprocesshead:not(.uauth)').live('click', doSubProcessForm);
	$('tbody.subProcess tr.activity:not(.uauth)').live('click', doActivityForm);
	$('#btnDel').live('click', function() {
		var num = $('.flexfieldContainer').length;
		// how many "duplicatable" input fields we currently have
		$('#input' + num).remove();
		// if only one element remains, disable the "remove" button
		if(num - 1 == 0)
			$('#btnDel').attr('disabled', 'disabled');

		return false;
	});
	$('.activity span.deleteactivity').live('click', doDeleteActivity);
	$('span.delete').live('click', doDeleteSubprocess);
	$('span.addActivity').live('click', addActivityForm);
	$('#addSubProcess').live('click', addSubProcessForm);
	$('#addSchedule').live('click', addScheduleForm);
	$('#describeprovider').live('click', describeprovider);
	$('#scheduleRepeats').live('change', scheduleExtraInfo);
	$('#addTime').live('click', addTimeField);
	$('.removeTime').live('click', removeTimeField);
	$('#removeSchedule').live('click', removeSchedule);
	$('#changeOwner').live('click', changeOwnerForm);
	$('#ownerUserGroup').live('click', userOrGroup);
	$('#provider').live('change', doProviderChange);
	$('body').ajaxError(function(event, xhr, settings, error) {// add default ajax handler to manage unforseen web service or proc errors
		errorDialog("An unknown error occured processing the request.  Please try again or contact the server administrator.");
	});
	setArowsVisibile();
});

$(document).ready(function() {
	$(".helptexttokenname").tooltip({
		effect : 'slide',
		showBody : " - ",
		fade : 250,
		extraClass : "tokenhelp",
		bodyHandler : function() {
			return $("#helptexttokenname").html();
		}
	});
	$(".title").tooltip({
		effect : 'slide',
		showBody : " - ",
		fade : 250
	})
	$(".ffinput").tooltip({
		effect : 'slide',
		showBody : " - ",
		fade : 250
	});
});

function getProviderScopeOptions(element, providerID, scopeIdentifier){
	element.html('<option value="">loading...</option>');
	$.getJSON("/process/getsubjectproviderscope",
			{
				providerid: providerID,
			},
			function(data) {
				var l = '';
				$.each(data, function(key, value) { 
					
					if (scopeIdentifier == key) {
						l += '<option value="'+ key + '" selected="selected">' + value + '</option>';
					} else {
						l += '<option value="'+ key + '">' + value + '</option>';
					}
				});
				element.html(l);
			});
}

function doProviderChange() {
	var elementid = $(this).attr('id');
	providerId = $('#' + elementid).val();
	if (providerId != 0 && providerId != '') {
		classId = $('#' + elementid + ' option:selected').attr('classid');
		ProviderVerb = $('#' + elementid + ' option:selected').attr('verb');
		if (providerId != 0 && providerId != '' && classId == 1){  // get scope if any
			scopeSelect = $('#providerScope');
			$(scopeSelect).find('option[value!=0]').remove();
			getProviderScopeOptions(scopeSelect, providerId);
		}
	} else {
		$('#providerScope').html('<option value=""></option>');
	}
	/*
	if(providerId != 0 && &&providerId != '' providerId != NaN && classId != 1) {
		updateParameters(providerId, ProviderVerb)
	} else {
		$('#SubProcessAccordion').accordion("activate", 2);
		$('.isparam').each(function() {
			obsoleteParameters.push($(this).attr('id'));
		})
		$('.isparam').closest('li').remove();
	}*/
	
}

function updateParameters(providerId, ProviderVerb) {
	doProviderChange();
	$.ajax({
		url : '/process/getproviderparameters',
		data : {
			providerId : providerId,
			ProviderVerb : ProviderVerb
		},
		type : 'post',
		success : function(data) {
			var parameterArray = new Array();
			parameterArray = data.result.ProviderScope.provider.parameter;
			$('#SubProcessAccordion').accordion("activate", 2);
			$('.isparam').each(function() {

				obsoleteParameters.push($(this).attr('id'));
			})
			$('.isparam').closest('li').remove();
			for(p in parameterArray) {
				var flexfieldhelp = "Parameters - Parameters can use tokens(existing flexfields) for dynamic values. Click the token symbol for a token list. When using tokens, insure they are wrapped with @ i.e. @mytoken@";
				var newli = $('<li></li>').addClass('FlexFieldContainerLi');
				var newElem = $('#inputclone').clone().attr('id', 'inputparameter' + p).addClass('isparam');
				newid = 'flexfield1';
				newdivid = 'input1';
				newElem.children('#flexfieldclone').attr('id', 'parameter' + p).attr('name', 'parameter' + p).attr('value', parameterArray[p]).attr('tokenname', parameterArray[p]).attr('isparameter', '1').attr('DISABLED', 'DISABLED');
				newElem.children('#flexfield1').attr('title', 'Parameter ' + parameterArray[p]).attr('tooltip', flexfieldhelp);
				newElem.children("#flexfieldreqclone").attr('id', 'reqparameter' + p).attr('name', 'reqparameter' + p).attr('checked', 'checked').attr('DISABLED', 'DISABLED');
				newElem.children("#btnDel_inputclone").attr('id', 'btnDel_parameter' + p).attr('style', 'display:none');
				newElem.children(".helptext").attr('title', flexfieldhelp);
				newli.append(newElem);

				$(newli).insertBefore("#ffbuttons");
				$(newElem).show();
				$(newElem).css("display", "inline-block");
			}

		}
	});
}

function confirmUnload() {
	// allow the unload if there are no subprocesses defined yet
	if($('#message').html() != '') {
		return 'Are you sure you want to navigate away from this page?  Unsaved data will be lost as a result.';
	}
}

function doDeleteSubprocess() {
	var subProcess = $(this).closest('tbody.subProcess');
	var subProcessId = $(subProcess).attr('subprocessid');
	$('<div title="Delete SubProcess?" class="confirmDelete"><p>Are you sure you want to delete this SubProcess?</p></div>').dialog({
		close : function() {
			$(this).remove()
		},
		buttons : {
			Cancel : function() {
				$(this).dialog('close');
			},
			Delete : function() {
				$.ajax({
					url : '/process/deletesubprocess',
					data : {
						subProcessId : subProcessId
					},
					type : 'post',
					success : function(data) {
						if(data.success) {
							$('tbody[subprocessid=' + subProcessId + ']').fadeOut(function() {
								$('tbody[subprocessid=' + subProcessId + ']').remove();
							});
							$('.confirmDelete').remove();
						} else {
							$('.confirmDelete').html('<p>Deleting the SubProcess Failed.</p>').dialog("option", "buttons", [{
								text : "Ok",
								click : function() {
									$(this).dialog("close");
								}
							}]);
						}
					}
				});
			}
		}
	});
	return false;
}


$('.btnDel').live('click', function() {
	var btnId = $(this).attr('id');
	divId = btnId.replace("btnDel_", "div_");
	flexId = btnId.replace("btnDel_", "");
	tname = $('#name_' + flexId).attr("tokenname");
	if(flexId.search(/input/i) == -1) {
		$.ajax({
			url : '/process/deleteflexfield',
			data : {
				ffid : flexId
			},
			type : 'post',
			success : function(data) {
				$('#' + divId).remove();
				$('#' + tname).remove();
				
			}
		});
	} else {
		$('#' + flexId).remove();
	}
	return false;
});
function doDeleteActivity() {
	var activityId = $(this).parents('.activity').attr('activityId');
	$('<div title="Delete Activity?" class="confirmDelete"><p>Are you sure you want to delete this activity?</p></div>').dialog({
		close : function() {
			$(this).remove()
		},
		buttons : {
			Cancel : function() {
				$(this).dialog('close');
			},
			Delete : function() {
				$.ajax({
					url : '/process/deleteactivity',
					data : {
						activityId : activityId
					},
					type : 'post',
					success : function(data) {
						if(data.success) {
							$('tr.activity[activityId=' + activityId + ']').fadeOut(function() {
								$(this).remove();
							});
							$('.confirmDelete').remove();
						} else {
							$('.confirmDelete').html('<p>Deleting the Activity Failed.</p>').dialog("option", "buttons", [{
								text : "Ok",
								click : function() {
									$(this).dialog("close");
								}
							}]);
						}
					}
				});
			}
		}
	});
	return false;
}

function doActivityForm() {
	var activityId = $(this).attr('activityId');
	var row = $(this);
	var processId = $(this).parents('div#processEditor').siblings('#processInfo').attr('processId');
	$("#opening").dialog({
		height : 140,
		modal : true
	});
	$.ajax({
		url : '/process/activityform',
		data : {
			activityId : activityId,
			processId : processId
		},
		type : 'post',
		success : function(data) {
			$("#opening").dialog('close');
			$(data).dialog({
				close : function() {
					$(this).remove()
				},
				buttons : {
					Cancel : function() {
						$(this).dialog('close');
					},
					Save : function() {
						var numberRegex = /^[+-]?\d+(\.\d+)?([eE][+-]?\d+)?$/;

						if(!numberRegex.test($('#activityDeadline').val())) {
							$('#activityDeadline').addClass('invalid');

						} else {
							$('#activityDeadline').removeClass('invalid');
							var activity = new Object();
							activity.id = activityId;
							activity.summary = $('#activitySummary').val();
							activity.description = $('#activityDescription').val();
							activity.procedure = $('#activityProcedure').val();
							activity.sort = $('#activitySort').val();
							activity.subProcessId = $('#activitySubProcessId').val();
							activity.processActivityId = $('#activityProcessActivityId').val();
							activity.deadline = $('#activityDeadline').val();
							activity.deadlineType = $('#activityDeadlineType').val();
							activity.deadlineResultsInMissed = $('#activityMissedWhenExceeded').is(':checked');
							activity.processId = processId;
							activity.provider = $('#provider').val();
							var flexfield = [];

							$.each($('.flexfieldContainer'), function() {
								newflexfield = $(this).children('.flexfieldname').val();
								if($(this).attr('id') != "inputclone") {
									var f = new Object();
									f.id = $(this).attr('id');
									f.fieldName = $(this).children('.flexfieldname').val();
									f.tokenname = $(this).children('.flexfieldname').attr('tokenname');
									f.tooltip = $(this).children('.flexfieldname').attr('tooltip');
									f.IsParameter = Number($(this).children('.flexfieldname').attr('isparameter'));
									f.defaultvalue = $(this).children('.flexdefault').val();
									if($(this).children('.flexfieldreq').is(':checked')) {
										f.fieldRequired = 1;
									} else {
										f.fieldRequired = 0;
									}
									flexfield.push(f);
								}
							});
							if(flexfield.length > 0) {
								activity.flexfields = flexfield;
							}
							$.ajax({
								url : '/process/updateactivity',
								data : {
									activity : activity
								},
								type : 'post',
								success : function(data) {
									if(data.success) {
										row.children('.summary').html(activity.summary);
										row.children('.description').html(activity.description);
										row.children('.procedure').html(activity.procedure);
										$('#activityForm').remove();
									} else {
										$(this).html('<p>Updating the Activity failed.</p>').dialog("option", "buttons", [{
											text : "Ok",
											click : function() {
												$(this).dialog("close");
											}
										}]);
									}
								}
							});
						}
					}
				},
				width : 800,
				height : 700,
				modal : true
			});

			$(".flexfieldname").tooltip({
				effect : 'slide',
				showBody : " - ",
				fade : 250
			});
			$(":image").tooltip({
				effect : 'slide',
				showBody : " - ",
				fade : 250,
				showURL : false
			});
			$("li.FlexFieldContainerLi span.helptext").tooltip();
			$("#ActivityAccordion").accordion({
				collapsible : false,
				autoHeight : false
			});
		}
	});
}

function doSubProcessForm() {
	var subProcessId = $(this).attr('subProcessId');
	var processId = $(this).parents('div#processEditor').siblings('#processInfo').attr('processId');
	var caption = $(this);
	$("#opening").dialog({
		height : 140,
		modal : true
	});
	$.ajax({
		url : '/process/subprocessform',
		data : {
			subProcessId : subProcessId,
			processId : processId
		},
		type : 'post',
		success : function(data) {
			$("#opening").dialog('close');
			$(data).dialog({
				close : function() {
					$(this).remove();
					$('#tokenlistdialog').dialog('close');
				},
				buttons : {
					Cancel : function() {
						$(this).dialog('close');
					},
					Save : function() {
						var subProcess = new Object();
						subProcess.id = subProcessId;
						subProcess.summary = $('#subProcessSummary').val();
						subProcess.description = $('#subProcessDescription').val();
						subProcess.deadline = $('#subProcessDeadline').val();
						subProcess.provider = $('#provider').val();
						var flexfield = [];
						var parameters = [];
						$.each($('.flexfieldContainer'), function() {
							newflexfield = $(this).children('.flexfieldname').val();
							//&& $(this).attr('id').indexOf("parameter") == -1
							if($(this).attr('id') != "inputclone") {
								var f = new Object();
								f.id = $(this).attr('id');
								f.fieldName = $(this).children('.flexfieldname').val();
								f.tokenname = $(this).children('.flexfieldname').attr('tokenname');
								f.tooltip = $(this).children('.flexfieldname').attr('tooltip');
								f.IsParameter = Number($(this).children('.flexfieldname').attr('isparameter'));
								f.defaultvalue = $(this).children('.flexdefault').val();
								if($(this).children('.flexfieldreq').is(':checked')) {
									f.fieldRequired = 1;
								} else {
									f.fieldRequired = 0;
								}
								if(f.IsParameter == 1) {
									parameters.push(f);
								} else {
									flexfield.push(f);
								}
							}
						});
						if(flexfield.length > 0) {
							subProcess.flexfields = flexfield;
						}
						if(parameters.length > 0) {
							subProcess.parameters = parameters;
						}
						$.ajax({
							url : '/process/updatesubprocess',
							data : {
								subProcess : subProcess,
								processId : processId
							},
							type : 'post',
							success : function(data) {
								if(obsoleteParameters.length > 0) {
									for(p in obsoleteParameters) {
										flexId = obsoleteParameters[p].replace("div_", "");
										$.ajax({
											url : '/process/deleteflexfield',
											data : {
												ffid : flexId
											},
											type : 'post'
										});
									}
								}
								if(data.success) {
									caption.children('span.title').text(subProcess.summary);
									$('#subProcessForm').remove();

								} else {
									$(this).html('<p>Updating the SubProcess failed.</p>').dialog("option", "buttons", [{
										text : "Ok",
										click : function() {
											$(this).dialog("close");
										}
									}]);
								}
							}
						});
					}
				},
				width : 800,
				height : 700,
				modal : true
			});
			$("#SubProcessAccordion").accordion({
				collapsible : false,
				autoHeight : false
			});
			$("li.FlexFieldContainerLi span.helptext").tooltip({
				effect : 'slide',
				showBody : " - ",
				fade : 250
			});
			$(".flexfieldname").tooltip({
				effect : 'slide',
				showBody : " - ",
				fade : 250
			});
			//
			$(":image").tooltip({
				effect : 'slide',
				showBody : " - ",
				fade : 250,
				showURL : false
			});
			//helpToolTip();

		}
	});
}

function doProcessForm() {
	var processId = $('#processInfo').attr('processId');
	$("#opening").dialog({
		height : 140,
		modal : true
	});
	$.ajax({
		url : '/process/processform',
		data : {
			processId : processId
		},
		type : 'post',
		success : function(data) {
			$("#opening").dialog('close');
			$(data).dialog({
				close : function() {
					$(this).remove()
				},
				buttons : {
					Cancel : function() {
						$(this).dialog('close');
					},
					Save : function() {
						var process = new Object();
						process.summary = $('#processSummary').val();
						process.description = $('#processDescription').val();
						process.status = $('#processStatus').val();
						process.statusName = $('#processStatus option:selected').text();
						process.deadline = $('#processDeadline').val();
						process.provider = $('#provider').val();
						process.providerScope = $('#providerScope').val();
						process.owner = $('#processowner').val();
						process.id = processId;
						if(checkProcessName()) {
							$.ajax({
								url : '/process/updateprocess',
								data : {
									process : process
								},
								type : 'post',
								success : function(data) {
									if(data.success) {
										$('#instancetitle').html(process.summary);
										$('#processDescriptionInfo').html('Description:<br /><small>' + process.description + '</small>');
										$('#processStatusInfo').html('Status:<br /><small>' + process.statusName + '</small>');
										$('#processDeadlineInfo').html('Deadline:<br /><small>' + process.deadline + '</small>');
										$('#processForm').remove();
									} else {
										$(this).html('<p>Updating the Process failed.</p>').dialog("option", "buttons", [{
											text : "Ok",
											click : function() {
												$(this).dialog("close");
											}
										}]);
									}
								}
							});
						}
					}
				},
				width : 750,
				height : 550,
				modal : true
			});
			
			var t_provider = $('#provider').val();
			
			if (t_provider != null && t_provider != '') {
				var scopeEl = $('#providerScope');
				var curScope = scopeEl.val();
			
				getProviderScopeOptions(scopeEl, t_provider, curScope);
			}
			
			$("#processInfoAccordion").accordion({
				collapsible : false,
				autoHeight : false
			});
			$("#processInfoAccordion span.helptext").tooltip({
				effect : 'slide',
				showBody : " - ",
				fade : 250,
				showURL : false
			});
			$('#processSummary').autocomplete({
				source : prefixes,
				select : function(event, ui) {
					var valuestart = ui.item.value + '.';
					this.value = valuestart;
					$('<span id="prefixMsg">Fill in the rest of your process name.</span>').insertAfter('#processSummary');
					return false;
				}
			});
		}
	});

}

function readySort() {
	setArowsVisibile();
	$('#message').html('<span class="info">You have made changes to the sort order.  You must update to save changes.</span>' + '<button id="updateSort">Update</button><button id="cancelUpdateSort">Cancel</button>');
}

function updateSort() {
	var subCount = 1;
	var subSuccess = true;
	var actSuccess = true;
	$('#processcontainer tbody.subProcess').each(function() {
		var subSort = $(this).attr('sort');
		if(subSort != subCount) {
			var processSubProcessId = $(this).attr('processSubProcessId');
			$.ajax({
				url : '/process/updatesubprocesssort',
				data : {
					sort : subCount,
					processSubProcessId : processSubProcessId
				},
				type : 'post',
				success : function(data) {
					if(!data.success) {
						subSuccess = false;
					}
				},
				error : function() {
					subSuccess = false;
				}
			});
		}
		subCount++;
		var actCount = 1;
		$(this).find('tr.activity').each(function() {
			var actSort = $(this).attr('sort');
			if(actSort != actCount) {
				var activityId = $(this).attr('activityId');
				$.ajax({
					url : '/process/updateactivitysort',
					data : {
						sort : actCount,
						activityId : activityId
					},
					type : 'post',
					success : function(data) {
						if(!data.success) {
							actSuccess = false;
						}
					},
					error : function() {
						subSuccess = false;
					}
				});
			}
			actCount++;
		});
	});
	if(actSuccess && subSuccess) {
		$('#message').html('');
	} else {
		$('#message .info').html('Updating sort failed.  Please Try again.  If it continues to fail, please contact the site administrator.');
	}
}

function addActivityForm() {
	var subProcessId = $(this).parent().attr('subProcessId');
	var processId = $('#processInfo').attr('processId');
	var currentSort = 1;
	var tbody = $('tbody[subProcessId=' + subProcessId + ']');
	if($('tbody[subProcessId=' + subProcessId + ']').children('tr').size() > 0) {
		currentSort = parseInt($('tbody[subProcessId=' + subProcessId + ']').children('tr').size()) + 1;
	}
	$.ajax({
		url : '/process/addactivityform',
		data : {
			subProcessId : subProcessId,
			processId : processId
		},
		type : 'post',
		success : function(data) {
			$(data).appendTo('body').dialog({
				minWidth : 650,
				close : function() {
					$(this).remove()
				},
				buttons : {
					Cancel : function() {
						$(this).dialog('close');
					},
					Save : function() {
						activity = new Object();
						activity.summary = $('#activitySummary').val();
						activity.description = $('#activityDescription').val();
						activity.procedure = $('#activityProcedure').val();
						activity.sort = currentSort;
						activity.deadline = $('#activityDeadline').val();
						activity.deadlineType = $('#activityDeadlineType').val();
						activity.deadlineResultsInMissed = $('#activityMissedWhenExceeded').is(':checked');
						$.ajax({
							url : '/process/addactivity',
							data : {
								activity : activity,
								subProcessId : subProcessId,
								processId : processId
							},
							type : 'post',
							success : function(data) {
								if(data.success) {
									$('<tr class="activity activityRow" activityId="' + data.activityId + '">' + '<td class="activitydata activitythSpace"></td>' + '<td class="summary activitydata activitythSummary">' + activity.summary + '</td>' + '<td class="description activitydata activitythDescription">' + activity.description + '</td>' + '<td class="procedure activitydata activitythProcedure">' + activity.procedure + '<td class="owner activitydata activitythUser">' + data.username + '</td>' + '<td class="delete activitydata activitythAction">' + '<span class="deleteactivity"></span>' + '</td></br>' + '</br>' + '</br></td>' + '</tr>').appendTo($('tbody[subProcessId=' + subProcessId + ']'));
									$('#addActivityForm').remove();
								} else {
									errorDialog("Adding the activity failed.  Please try again.  If you keep encountering problems, please contact the site administrator.");
								}
							}
						});
					}
				}
			});
		}
	});
	return false;
}

function addSubProcessForm() {
	var processId = $('#processInfo').attr('processId');
	var currentSort = 1;
	if($('.subprocesshead').length > 0) {
		currentSort = parseInt($('.subprocesshead').length) + 1;
	}
	$.ajax({
		url : '/process/addsubprocessform',
		data : {
			processId : processId
		},
		type : 'post',
		success : function(data) {
			$(data).dialog({
				minWidth : 650,
				close : function() {
					$(this).remove()
				},
				buttons : {
					Cancel : function() {
						$(this).dialog('close');
					},
					Save : function() {
						var subProcess = new Object();
						subProcess.summary = $('#subProcessSummary').val();
						subProcess.description = $('#subProcessDescription').val();
						subProcess.deadline = $('#subProcessDeadline').val();
						subProcess.sort = currentSort;
						$.ajax({
							url : '/process/addsubprocess',
							data : {
								subProcess : subProcess,
								processId : processId
							},
							type : 'post',
							success : function(data) {
								if(data.success) {
									var tbody = $('#processParkingTable tbody:first').clone().attr('ProcessSubProcessId', data.processSubProcessId).attr('sort', subProcess.sort).attr('subprocessid', data.subProcessId);
									$(tbody).find('td:first').attr('subprocessid', data.subProcessId).find('span:first').html(subProcess.summary);
									$(tbody).appendTo('#processcontainer');
									//									$('<div class="ui-widget-content ui-corner-all subprocesshead" " ProcessSubProcessId="' + data.processSubProcessId + '" sort="' + subProcess.sort + '" subprocessid="' + data.processSubProcessId + '">' + '<span class="title">' + subProcess.summary + '</span>' + '<span class="delete"></span><span class="addActivity"></span></div>').appendTo('#processEditor');
									$('#addSubProcessForm').remove();
								} else {
									errorDialog("Adding the subprocess failed.  Please try again.  If you keep encountering problems, please contact the site administrator.");
								}
							}
						});
						$(this).dialog('close');
					}
				}
			});
		}
	});
	return false;
}

function addScheduleForm() {
	var processId = $('#processInfo').attr('processId');
	var currentSort = 1;
	if($('.subprocesshead').length > 0) {
		currentSort = parseInt($('.subprocesshead').length) + 1;
	}
	$('<div id="addScheduleForm" title="Add Schedule:"><img src="/img/loading70.gif"/></div>').dialog({
		minWidth : 400,
		close : function() {
			$(this).remove();
		}
	});
	$.ajax({
		url : '/process/addscheduleform',
		data : {
			processId : processId
		},
		type : 'post',
		success : function(data) {
			$('#addScheduleForm').html(data).dialog('option', 'buttons', {
				'Cancel' : function() {
					$(this).dialog('close');
				},
				'Save' : function() {
					var d = $(this);
					d.prepend('<img src="/img/loading70.gif"/>');
					var scheduleStart = $('#scheduleStartDate').val();
					var scheduleTimes = new Array();
					$('input.scheduleStartTime').each(function() {
						scheduleTimes.push($(this).val());
					});
					var owners = $('#scheduleOwners').val();
					var repeat = $('#scheduleRepeats').val();
					var days = $('#days').val();
					var interval = $('#repeatinterval').val();
					var processId = $('#scheduleProcessId').val();
					$.ajax({
						url : '/process/addschedule',
						type : 'post',
						data : {
							scheduleStart : scheduleStart,
							repeat : repeat,
							days : days,
							interval : interval,
							scheduleTimes : scheduleTimes,
							processId : processId,
							owners : owners
						},
						success : function(data) {
							if(data.success) {
								$('#scheduleColumn').html('<p>' + data.scheduleString + '</p><p>Next run time is ' + data.nextScheduled + '.</p>');
								var buttonContainer = $('#addSchedule').closest('li')[0];
								$('#addSchedule').remove();
								$(buttonContainer).append('<button id="removeSchedule" scheduleId="' + data.scheduleId + '">Remove Schedule</button>');
								d.dialog('close');
							} else {
								errorDialog("Adding the schedule failed.  Please try again.  If you keep encountering problems, please contact the site administrator.");
							}

						}
					});
				}
			});

			$('#scheduleStartDate').datepicker().blur().focus();

			$('.scheduleStartTime').timepicker({
				timeFormat : 'hh:mm tt',
				separator : ' @ ',
				ampm : true
			});
			$('#addTime').hide();
			$('#scheduleOwners').bsmSelect();
		}
	});
	return false;
}

function scheduleExtraInfo() {
	var repeat = $('#scheduleRepeats').val();
	if(repeat == 'days') {
		var days = '<label for="days" class="break">Choose Days:<select id="days" multiple="multiple" name="days" title="--" class="input">';
		days += '<option value="0">Sunday</option>';
		days += '<option value="1">Monday</option>';
		days += '<option value="2">Tuesday</option>';
		days += '<option value="3">Wednesday</option>';
		days += '<option value="4">Thursday</option>';
		days += '<option value="5">Friday</option>';
		days += '<option value="6">Saturday</option>';
		days += '</select></label>';
		$('#scheduleExtra').html(days);
	} else if(repeat == 'dates') {
		var dates = '<label for="days" class="break">Choose Dates:<select id="days" multiple="multiple" name="days" title="--" class="input">';
		for( i = 0; i <= 28; i++) {
			dates += '<option value="' + i + '">' + i + '</option>';
		}
		dates += '</select></label>';
		$('#scheduleExtra').html(dates);
	} else if(repeat == 'xweeks') {
		var interval = '<label for="repeatinterval">How many weeks?<input type="text" id="repeatinterval" name="repeatinterval" class="input" /><label for="repeatinterval"></label>';

		$('#scheduleExtra').html(interval);
	} else if(repeat == 'xmonths') {
		var interval = '<label for="repeatinterval">How many months?<input type="text" id="repeatinterval" name="repeatinterval" class="input" /></label>';

		$('#scheduleExtra').html(interval);
	} else {
		$('#scheduleExtra').html('');
	}
	$('#days').bsmSelect();
	if(repeat == 'none') {
		$('#addTime').hide();
		$('.extraTime').remove();
	} else {
		$('#addTime').show();
	}
}

function removeSchedule() {
	var scheduleId = $(this).attr('scheduleId');
	$('<div title="Delete Schedule?"><p>Are you sure you want to remove the schedule for this process?</p></div>').dialog({
		close : function() {
			$(this).remove();
		},
		buttons : {
			Cancel : function() {
				$(this).dialog('close');
			},
			OK : function() {
				var d = $(this);
				d.html('<img src="/img/loading70.gif" />');
				$.ajax({
					url : '/process/deleteschedule',
					type : 'post',
					data : {
						scheduleId : scheduleId
					},
					success : function(data) {
						if(data.success) {
							$('#scheduleColumn').html('<p>There is no schedule for this process yet.</p>');
							var buttonContainer = $('#removeSchedule').closest('li')[0];
							$('#removeSchedule').remove();
							$(buttonContainer).append('<button id="addSchedule">Add A Schedule</button>');
							d.dialog('close');
						} else {
							errorDialog("Failed to remove the schedule.  Please try again.  If you keep encountering problems, please contact the site administrator.");
						}
					}
				});
			}
		}
	});
	return false;
}

function addTimeField() {
	var newTimeField = '<p class="extraTime"><input type="text" class="scheduleStartTime followedinput" /><img src="/img/close_sm.png" class="removeTime" /></p>';
	$(newTimeField).insertBefore($(this));
	$('.scheduleStartTime').timepicker({
		timeFormat : 'hh:mm tt',
		separator : ' @ ',
		ampm : true
	});
	$('.scheduleStartTime:last').trigger('select');
}

function removeTimeField() {
	$(this).parent('p').remove();
}

function changeOwnerForm() {
	var processId = $('#processInfo').attr('processId');
	$('<div id="processOwnerForm" title="Change Process Owner"><img src="/img/loading65.gif" /></div>').dialog({
		minWidth : 450,
		close : function() {
			$(this).remove();
		},
		buttons : {
			Cancel : function() {
				$(this).dialog('close');
			},
			OK : function() {
				var d = $(this);
				var ug = $('#ownerUserGroup').val();
				var newOwner = 0;
				if(ug == 'user') {
					newOwner = $('#ownerUser').val();
				} else if(ug == 'group') {
					newOwner = $('#ownerGroup').val();
				}
				if(newOwner == 0) {
					alert("You must choose a new user or group to own this process.");
				}
				$.ajax({
					url : '/process/updateprocessowner',
					type : 'post',
					data : {
						processId : processId,
						newOwner : newOwner
					},
					success : function(data) {
						if(data.success) {
							window.location.reload();

						} else {
							errorDialog("Changing the process owner failed.  Please try again.  If you keep encountering problems, please contact the site administrator.");
						}
					}
				});
			}
		}
	});
	$.ajax({
		url : '/process/processownerform',
		data : {
			processId : processId
		},
		type : 'post',
		success : function(data) {
			$('#processOwnerForm').html(data);
		},
		error : function() {
			alert("There was an error retrieving the owner list.");
		}
	});
	return false;
}

function userOrGroup() {
	var ug = $('#ownerUserGroup').val();
	if(ug == 'user') {
		$('#ownerUserChoice').show();
		$('#ownerGroupChoice').hide();
	} else if(ug == 'group') {
		$('#ownerUserChoice').hide();
		$('#ownerGroupChoice').show();
	} else {
		$('#ownerUserChoice').hide();
		$('#ownerGroupChoice').hide();
	}
}

function describeprovider() {
	var queue = $('#providerQueue').val();
	var accordion = $('#providerAccordion').val();
	var classid = $('#classid').val();
	var proid = $('#proid').val();
	if(queue.indexOf(".") < 0) {
		$('#subjectERR').text('Error: Check your queue name.');
		return;
	} else {
		$('#subjectERR').text('');
	}
	$("#opening").dialog({
		height : 140,
		modal : true
	});
	$.ajax({
		url : '/process/describeactor',
		data : {
			queue : queue
		},
		type : 'post',
		success : function(data) {
			$('#subjectERR').text('');
			$('#providerSelectContainer').html(data);
			setTimeout(function() {
				LoadProviders(classid, proid);
				$("#opening").dialog('close');
				/*$('.isparam').each(function() {

				 obsoleteParameters.push($(this).attr('id'));
				 })
				 $('.isparam').closest('li').remove();*/
				$("#" + accordion).accordion("activate", 1);
				$('#subjectERR').text('');
			}, 8000);
		},
		error : function() {
			$('#subjectERR').text('Error: System error');
		}
	});

	return false;
}

function LoadProviders(classid, proid) {
	$.ajax({
		url : '/process/getproviderselect',
		data : {
			classid : classid,
			proid : proid
		},
		type : 'post',
		success : function(data) {
			$('#subjectERR').text('');
			$('#providerSelectContainer').html(data);
			$("#opening").dialog('close');
			$("#" + accordion).accordion("activate", 1);
			$('#subjectERR').text('');
		},
		error : function() {
			$('#subjectERR').text('Error: System error');
		}
	});
}

function AddFlexFieldDialog() {
	window.newff = $('#ffform').dialog({
		open : function(event, ui) {
			$("#newfftokenname").removeClass("invalidtoken");
			if(window.tooltipfired != true) {
				$("label[for=^'newff'] span.helptext").tooltip({
					effect : 'slide',
					showBody : " - ",
					fade : 250,
					showURL : false
				});
			}
			window.tooltipfired = true;
		},
		autoOpen : false,
		title : 'Add New Flex Field',
		close : function() {

			$(this).dialog('destroy');
		},
		buttons : {
			Cancel : function() {
				$('#ffformdialog')[0].reset();
				$(this).dialog('destroy');
			},
			Save : function() {
				if(!$('#newfftokenname').val().match(/^_?(?!(xml|[_\d\W]))([\w.-]+)$/i)) {
					$('#newfftokenname').addClass("invalidtoken");
					return false;
				} else {
					$('#newfftokenname').removeClass("invalidtoken");
				}

				var newli = $('<li></li>').addClass('FlexFieldContainerLi');
				var tooltip = $('#newfftooltip').val();
				var tipdisplay = "Token Name: " + $('#newfftokenname').val() + "<br/>ToolTip: " + tooltip;
				var newid = "";
				newdivid = "";
				var flexfieldhelp = "Flex Fields are user or system defined fields that can be populated with output from automation, set with user values or any other arbitrary data.";
				if($('.flexfieldContainer').length == 0) {
					//if we don't, let's clone the hidden one
					var newElem = $('#inputclone').clone().attr('id', 'input1');
					newid = 'flexfield1';
					newdivid = 'input1';
					newElem.children('#flexfieldclone').attr('id', 'flexfield1').attr('name', 'flexfield1').attr('value', $('#newfffriendlyname').val()).attr('tokenname', $('#newfftokenname').val());
					newElem.children('#flexfield1').attr('title', tipdisplay).attr('tooltip', tooltip);
					newElem.children("#flexfieldreqclone").attr('id', 'flexfieldreq1').attr('name', 'flexfieldreq1').removeAttr("checked");
					newElem.children("#btnDel_input1").attr('id', 'btnDel_input1');
					$(newli).insertBefore("#ffbuttons");
					$(newElem).show();
					$(newElem).css("display", "inline-block");
				} else {
					//if we do, let's clone the bottom one'
					btmNewFlex = $('.flexfieldContainer').get(-1);
					btmNewFlexID = $(btmNewFlex).attr('id')
					var num = Number(btmNewFlexID.replace(/input/i, ""));
					var newNum = 1;
					if(!isNaN(num)) {
						newNum = new Number(num + 1);
						var newElem = $('#input' + num).clone().attr('id', 'input' + newNum);
						newid = 'flexfield' + newNum;
						newdivid = 'input' + newNum;
						newElem.children('#flexfield' + num).attr('id', 'flexfield' + newNum).attr('name', 'flexfield' + newNum).attr('value', $('#newfffriendlyname').val()).attr('tokenname', $('#newfftokenname').val());
						newElem.children('#flexfield' + newNum).attr('title', tipdisplay).attr('tooltip', tooltip);
						newElem.children("#flexfieldreq" + num).attr('id', 'flexfieldreq' + newNum).attr('name', 'flexfieldreq' + newNum).removeAttr("checked");
						newElem.children("#btnDel_input" + num).attr('id', 'btnDel_input' + newNum);
					} else {
						var newElem = $('#inputclone').clone().attr('id', 'input1');
						newid = 'flexfield1';
						newdivid = 'input1';
						newElem.children('#flexfieldclone').attr('id', 'flexfield1').attr('name', 'flexfield1').attr('value', $('#newfffriendlyname').val()).attr('tooltip', tooltip).attr('title', tipdisplay).attr('tokenname', $('#newfftokenname').val());
						newElem.children("#flexfieldreqclone").attr('id', 'flexfieldreq1').attr('name', 'flexfieldreq1').removeAttr("checked");
						newElem.children("#btnDel_inputclone").attr('id', 'btnDel_input1');
					}

					// create the new element
					// insert the new element before add button
					newElem.children(".helptext").attr('title', flexfieldhelp);
					newli.append(newElem);

					$(newli).insertBefore("#ffbuttons");
					$(newElem).show();
					$(newElem).css("display", "inline-block");
					
					AddTokenToTokenList($('#newfffriendlyname').val(), $('#newfftokenname').val());
				}

				$(this).dialog('destroy');
				$("#" + newdivid + " .helptext").tooltip({
					effect : 'slide',
					showBody : " - ",
					fade : 250,
					extraClass : "tokenhelp"
				});

				$("#" + newid).tooltip({
					effect : 'slide',
					showBody : " - ",
					fade : 250
				})
			}
		},
		close : $('#ffformdialog')[0].reset(),
		width : 750,
		modal : true
	});
	return false;
}

function checkProcessName() {
	var summary = $('#processSummary').val();
	var processId = $('#processInfo').attr('processId');
	$('#processSummary').removeClass('invalid');
	var processNameValid = true;
	if(trimAll(summary) != '') {
		if(summary.lastIndexOf('.') == summary.length - 1) {
			processNameValid = false;
			errorDialog("Process Name cannot end with a period.");
			$('#processSummary').addClass('invalid');
			return processNameValid;
		}
		for(i in prefixes) {
			if(prefixes[i] == summary) {
				processNameValid = false;
				$('#processSummary').addClass('invalid');
				errorDialog("You must complete the process name.  It cannot be named the same as a parent folder.");
				return processNameValid;
			}
		}
		$.ajax({
			url : '/wizard/checkprocessname/',
			type : 'post',
			data : {
				summary : summary,
				processId : processId
			},
			success : function(data) {
				if(data.exists) {
					$('#processSummary').addClass('invalid');
					errorDialog("A process with that name already exists");
					processNameValid = false;

				} else {
					$('#processSummary').removeClass('invalid');
					processNameValid = true;
				}
			},
			error : function() {
				errorDialog("An error occurred while checking for an existing process name.  Please try again.  If you keep encountering problems, please contact the site administrator.");
			}
		});
	} else {
		processNameValid = true;
	}
	return processNameValid;
}

function moveActivityUp() {
	var row = $(this).closest('.activityRow');
	row.insertBefore(row.prev());
	readySort();
	return false;
}

function moveActivityDown() {
	var row = $(this).closest('.activityRow');
	row.insertAfter(row.next());
	readySort();
	return false;
}

function moveSubProcessUp() {
	var sub = $(this).closest('tbody');
	sub.insertBefore(sub.prev());
	readySort();
	return false;
}

function moveSubProcessDown() {
	var sub = $(this).closest('tbody');
	sub.insertAfter(sub.next());
	readySort();
	return false;
}

function setArowsVisibile() {
	$('span.moveup, span.movedown').show();
	$('tbody.subProcess:nth-child(2) tr.subprocesstitle span.moveup').hide();
	$('tbody.subProcess:last-child tr.subprocesstitle span.movedown').hide();
	$('tbody.subProcess tr.activityRow:last-child span.movedown').hide();
	$('tbody.subProcess tr.activityRow:nth-child(2) span.moveup').hide();
}