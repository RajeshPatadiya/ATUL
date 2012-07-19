/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
$(function(){
	window.onbeforeunload = confirmUnload;
	window.finishing = false;
	window.processNameValid = true;
	$('#process_wizard').smartWizard({onLeaveStep: actionFactory, transitionEffect: 'slideleft', onFinish: compileProcess, keyNavigation: false});
	$('#addSubProcess').live('click', addSubProcess);
	$('.addActivity').live('click', addActivity);
	$('.subProcessSummary').live('keyup', function(){
		var summary = $.trim($(this).val());
		if (summary == ''){
			summary = 'New Sub-Process:';
		}
		var sort = parseInt($(this).parents('li').attr('sort'));
		$(this).parents('li').children('h2').children('span.sum').html(summary);
		$('#activitiesSubProcesses li.subProcess[sort='+sort+'] > h2 span.sum').html(summary);
	});
	$('.activitySummary').live('keyup', function(){
		var summary = $.trim($(this).val());
		if (summary == ''){
			summary = 'New Activity:';
		}
		$(this).parents('li.activity').children('h2').children('span.sum').html(summary);
	});
	$('#subProcesses').sortable({items: 'li', update: orderSubProcesses, axis: 'y'});
	$('.expanded').live('click', function(){
		$(this).siblings().slideUp();
		$(this).removeClass('expanded').addClass('collapsed');
	});
	$('.collapsed').live('click', function(){
		$(this).siblings().slideDown();
		$(this).removeClass('collapsed').addClass('expanded');
	});
	$('#subProcesses li h2 span.delete').live('click', function(){
		var sort = $(this).parents('li').attr('sort');
		$('#activitiesSubProcesses li[sort='+sort+']').remove();
		$(this).parents('li').slideUp(function(){$(this).remove();});
	});
	$('.activities li h2 span.delete').live('click', function(){
		$(this).parents('li.activity').slideUp(function(){
			var thisItemsList = $(this).closest('ul');
			$(this).remove();
			$(thisItemsList).find('li.activity').each(function(index){
				$(this).attr('sort', index + 1);
			});
		});
	});
	$(window).resize(function(){
		wizardResize();
	});
	wizardResize();
	$('#processSummary')[0].focus();
	$('#processSummary').live('blur', checkProcessName);
	$('#processSummary').change(function(){ $('#prefixMsg').remove(); })
	$('#processSummary').autocomplete({
		source: prefixes,
		select: function(event, ui) {
			var valuestart = ui.item.value + '.';
			this.value = valuestart;
			$('<span id="prefixMsg">Fill in the rest of your process name.</span>').insertAfter('#processSummary');
			return false;
		}
	});
});

function confirmUnload(){
	// allow the unload if there are no subprocesses defined yet
	if ($('#subProcesses').children().size() > 0 && !window.finishing) {
		return 'Are you sure you want to navigate away from this page?  Unsaved data will be lost as a result.';
	}
}

function actionFactory(step) {
	var stepId = step.attr('rel');
	switch (stepId){
		case '1': // Step 1 is Define Process
			return validateProcess();
			break;
		case '2': // Step 2 is Add Sub-Processes
			return validateSubProcesses();
			break;
		case '3': // Step 3 is Add Activities
			return validateActivities();
			break;
		default:
			break;
	}
}

function orderSubProcesses() {
	var order = 1;
	$('#subProcesses li').each(function(){
		var oldSort = parseInt($(this).attr('sort'));
		$('#activitiesSubProcesses li[sort='+oldSort+']').attr('newSort', order);
		$(this).attr('sort', order);
		order++;
	});
	$('#activitiesSubProcesses li.subProcess').each(function(){
		var thisSort = parseInt($(this).attr('newSort'));
		$(this).attr('sort', thisSort);
		$(this).attr('newSort', '');
		if (thisSort != 1) {
			var beforeThis = thisSort - 1;
			$('#activitiesSubProcesses li.subProcess[sort='+beforeThis+']').after($(this));
		}
	});
}

function orderSubProcesseActivities(event, ui) {
	$(ui.item).closest('ul').find('li').each(function(index){
		$(this).attr('sort', index + 1);
	});
}

function addSubProcess() {
	var currentSort = 1;
	if ($('#subProcesses').children().size() > 0) {
		currentSort = parseInt($('#subProcesses li:last-child').attr('sort')) + 1;	
	}
	$('#subprocessLIParkingDiv > li').clone().hide().appendTo('#subProcesses').slideDown().attr('sort', currentSort).find('input.subProcessSummary')[0].focus();
	$('#subprocessActivityLIParkingDiv > li').clone().appendTo('#activitiesSubProcesses').attr('sort', currentSort);
}

function addActivity() {
	var list = $(this).siblings('ul.activities');
	currentSort = list.children().size() + 1;
	$.ajax({url: '/wizard/activityform/', data: {currentSort: currentSort}, type: 'post', success: function(data){
		$(data).appendTo(list).find('input.activitySummary')[0].focus();
		$('#activitiesSubProcesses ul.activities').sortable({items: 'li', axis: 'y', update: orderSubProcesseActivities});
	}})
	
}

function compileProcess() {
	if (validateActivities()) {
		process = new Object();
		process.summary = $('#processSummary').val();
		process.status = $('#processStatus').val();
		process.deadline = $('#processDeadline').val();
		process.description = $('#processDescription').val();
		if (process.summary != ''){
			$('div#step-2 h2.StepTitle').html('Now Add Sub-Processes to ' + process.summary + ':');
		}
		process.subProcesses = new Array();
		$('#subProcesses li').each(function(){
			var sub = new Object();
			sub.summary = $(this).find('.subProcessSummary').val();
			sub.description = $(this).find('.subProcessDescription').val();
			sub.deadline = $(this).find('.subProcessDeadline').val();
			sub.sort = $(this).attr('sort');
			sub.activities = new Array();
			var actSub = $('#activitiesSubProcesses li[sort='+sub.sort+']');
			currentSort = 1;
			actSub.find('ul.activities li').each(function(){
				activity = new Object();
				activity.summary = $(this).find('.activitySummary').val();
				activity.description = $(this).find('.activityDescription').val();
				activity.procedure = $(this).find('.activityProcedure').val();
				activity.sort = currentSort;
				activity.deadline = $(this).find('.activityDeadline').val();
				activity.deadlineType = $(this).find('.activityDeadlineType').val();
				activity.deadlineResultsInMissed = $(this).find('.activityMissedWhenExceeded').is(':checked');
				sub.activities.push(activity);
				currentSort++;
			});
			process.subProcesses.push(sub);
		});
		if (process.subProcesses.length > 0) {
			$.ajax({url: '/wizard/createprocess/', data: {process: process}, success: function(data){
				if (data.success) {
					window.finishing = true;
					window.location = '/process/editor/processid/'+data.processId+'/';
				} else {
					$('#process_wizard').smartWizard('showMessage', data.message);
				}
			}, type: 'post'});
		} else {
			$('#process_wizard').smartWizard('showMessage', "Cannot create a process with no subprocesses.");
			return false;
		}
	} else {
		return false;
	}
}

function validateProcess(){
	var valid = true;
	if (!validateInput($('#processDeadline').val(), 'number')) {
		valid = false;
		$('#processDeadline').addClass('invalid');
	} else {
		$('#processDeadline').removeClass('invalid');
	}
	if (!validateInput($('#processStatus').val(), 'number')) {
		valid = false;
		$('#processStatus').addClass('invalid');
	} else {
		$('#processStatus').removeClass('invalid');
	}
	if (!validateInput($('#processSummary').val(), 'text') || trimAll($('#processSummary').val()) == '') {
		valid = false;
		$('#processSummary').addClass('invalid');
	} else {
		$('#processSummary').removeClass('invalid');
	}
	if (!window.processNameValid) {
		valid = false;
		$('#processSummary').addClass('invalid')
	} else {
		$('#processSummar').removeClass('invalid');
	}
	if (!valid) {
		$('#process_wizard').smartWizard('showMessage', 'Please fill in all required fields.');
	} else {
		$('.msgBox').remove();
	}
	return valid;
}

function validateSubProcesses(){
	var valid = true;
	$('#subProcesses .subProcessSummary').each(function(){
		if (!validateInput($(this).val(), 'text')) {
			valid = false;
			$(this).addClass('invalid');
		} else {
			$(this).removeClass('invalid');
		}
	});
	$('#subProcesses .subProcessDeadline').each(function(){
		if (!validateInput($(this).val(), 'number')) {
			valid = false;
			$(this).addClass('invalid');
		} else {
			$(this).removeClass('invalid');
		}
	});
	if (!valid) {
		$('#process_wizard').smartWizard('showMessage', 'Please fill in all required fields.');
	} else {
		$('.msgBox').remove();
	}
	return valid;
}

function validateActivities(){
	var valid = true;
	$('#activitiesSubProcesses .activitySummary').each(function(){
		if (!validateInput($(this).val(), 'text' )) {
			valid = false;
			$(this).addClass('invalid');
		} else {
			$(this).removeClass('invalid');
		}
	});
	$('#activitiesSubProcesses .activityDeadline').each(function(){
		if (!validateInput($(this).val(), 'number')) {
			valid = false;
			$(this).addClass('invalid');
		} else {
			$(this).removeClass('invalid');
		}
	});
	$('#activitiesSubProcesses .activityDeadlineType').each(function(){
		if (!validateInput($(this).val(), 'number')) {
			valid = false;
			$(this).addClass('invalid');
		} else {
			$(this).removeClass('invalid');
		}
	});
	if (!valid) {
		$('#process_wizard').smartWizard('showMessage', 'Please fill in all required fields.');
	} else {
		$('.msgBox').remove();
	}
	return valid;
}

function wizardResize(){
	
	var wizardHeight = 
		$(window).height() 
		- $('#head').outerHeight() 
		- $('#footer-wrapper').outerHeight() 
		- 280;
	var stepContainer = $('#process_wizard div.stepContainer');
	var stepPanels = $('#process_wizard div.stepContainer div.content');
	stepContainer.height(wizardHeight);
	stepPanels.height(wizardHeight - 18);
}

function checkProcessName() {
	var summary = $('#processSummary').val();
	if (trimAll(summary) != '') {
		if (summary.lastIndexOf('.') == summary.length - 1) {
			window.processNameValid = false;
			$('#process_wizard').smartWizard('showMessage',"Process Name cannot end with a period.");
			return;
		}
		for (i in prefixes) {
			if (prefixes[i] == summary) {
				window.processNameValid = false;
				$('#process_wizard').smartWizard('showMessage',"You must complete the process name.  It cannot be named the same as a parent folder.");
				return;
			}
		}
		$.ajax({
			url: '/wizard/checkprocessname/',
			type: 'post',
			data: {summary: summary},
			success: function(data) {
				if (data.exists) {
					$('#processSummary').addClass('invalid');
					$('#process_wizard').smartWizard('showMessage', 'A Process with that name already exists, or that name will conflict with another process.');
					window.processNameValid = false;
				} else {
					$('#processSummary').removeClass('invalid');
					window.processNameValid = true;
					$('.msgBox').remove();
				}
			}
		}); 
	} else {
		$('#processSummary').removeClass('invalid');
		$('.msgBox').remove();
		window.processNameValid = true;
	}
}