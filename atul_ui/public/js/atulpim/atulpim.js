/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
( function() {
	// remove layerX and layerY
	var all = $.event.props, len = all.length, res = [];
	while(len--) {
		var el = all[len];
		if(el != 'layerX' && el != 'layerY')
			res.push(el);
	}
	$.event.props = res;
}());
var dirtyFlexField = new Array();
$(document).ready(function() {

	var user = $('#cx_loggedInUser').val();
	var instanceId = $('#processInfo').attr('instanceId');
	var instanceSubject = $('#instanceSubject').text();
	if (instanceSubject == null || instanceSubject == 'undefined') {
		instanceSubject = '';
	}
	var idate = $('#processInfo').attr('instancedate');
	var title = $('#instancetitle').text() + '<br/>&nbsp;&nbsp;' + instanceSubject + '-' + idate;
	updateUserHistory(user, 'instance', instanceId, title);

	$("#instancetitle").tooltip({
		effect : 'slide'
	});
	$(".subprocesshead").tooltip({
		effect : 'slide'
	});
	$(".activityRow").tooltip({
		effect : 'slide'
	});
	$(".optionalff").tooltip({
		effect : 'slide',
		showBody : " - ",
		fade : 250
	});
	$(".requiredff").tooltip({
		effect : 'slide',
		showBody : " - ",
		fade : 250,
		extraClass : "requiredtt"
	});
	$('.flip').live('click', function() {
		subprocessID = $(this).attr('id');
		activityID = subprocessID.split('subprocess-');
		///Crush WHOLE subprocess
		//$("." + subprocessID).toggle('fast');
		$(".subprocess-" + activityID[1]).children(".activityRow").slideToggle('fast');

		$(".subprocess-" + activityID[1]).children('tr[id|="activityflexfield"]').slideToggle('fast');
		//	$(".activity-" + activityID[1]).toggle('fast');
		//$(".activityflexfield-" + activityID[1]).toggle('fast');
		currentSubProcessCheck();
		return false;
	});

	$("#main_table").tableCorners({
		collapse : true,
		thead : true,
		tbody : false,
		tfoot : true,
		radius : '4px'
	});

	$('#changeOwner').live('click', changeOwnerForm);
	$('#ownerUserGroup').live('click', userOrGroup);
	currentsubID = $("#currentsub").val();
	if(currentsubID != null) {
		document.getElementById('subprocesshead-' + currentsubID).scrollIntoView();
	}
	$('#ffUpdate').live('click', ffUpdate);

	//Disable activities with empty required fields
	$.each($('.requiredff'), function() {
		if($(this).val().trim() == "") {
			var relation = $(this).attr('relation');
			var complete = relation.replace("activity-", "checkcomplete-");
			var cna = relation.replace("activity-", "checkna-");
			$('#' + complete).attr("disabled", true);
			$('#' + cna).attr("disabled", true);
		}
	});
});
$('.activityflexfield').live({keyup: ffChange, change: ffChange});
function ffChange(event) {
	window.dirtyFlexField[event.target.id] = event.target.value;
	$('#message').html('<span class="info">You have made changes to a flex field value.  You must update to save changes.</span>' + '<button id="ffUpdate">Update</button><button id="cancelffUpdate">Cancel</button>');
}

function ffUpdate() {

	for(ff in window.dirtyFlexField) {
		$("#opening").dialog({
			
			title : "Updating...",
			height : 60,
			width: 245,
			modal : true
		});
		flexFieldID = ff.replace("ff-", "");
		flexFieldValue = window.dirtyFlexField[ff];
		instanceID = $('#processInfo').attr('instanceId');
		//update flexfields
		$.ajax({
			url : '/process/updateflexfieldstorage',
			data : {
				iid : instanceID,
				ffid : flexFieldID,
				tv : flexFieldValue
			},
			type : 'post',
			success : function(data) {
				if(!data.success) {
					$('#message').html('');
				}
				$("#opening").dialog('close');
				window.location.reload();
			},
			error : function() {
				$('#message .info').html('Updating the fields failed.  Please Try again.  If it continues to fail, please contact the site administrator.');
				$("#opening").dialog('close');
			}
		});
	}

}


$('#cancelffUpdate').live('click', function() {
	window.location.reload();
});

$('.checkcomplete').live('click', function() {
	activityCheckBoxID = $(this).attr('id');
	activityID = activityCheckBoxID.split('checkcomplete-');
	if($(this).is(':checked')) {
		$("#checkna-" + activityID[1]).removeAttr('checked');
		checkstep(activityID[1], 1);
	} else {
		$("#checkna-" + activityID[1]).removeAttr('checked');
		checkstep(activityID[1], 0);
	}
});

$('.checkna').live('click', function() {
	activityCheckBoxID = $(this).attr('id');
	activityID = activityCheckBoxID.split('checkna-');
	if($(this).is(':checked')) {
		$("#checkcomplete-" + activityID[1]).removeAttr('checked');
		checkstep(activityID[1], 2);
	} else {
		$("#checkcomplete-" + activityID[1]).removeAttr('checked');
		checkstep(activityID[1], 0);
	}
});
$(".processtoggle").live('click', function() {
	activityprocessID = $(this).attr('id');
	processID = activityprocessID.split('processtoggle-');
	$("#processinfo-" + processID[1]).toggle("slow");

});
function checkstep(id, bit) {
	var request = $.ajax({
		url : "/atulpim/completeactivity/",
		type : "POST",
		data : {
			AtulInstanceProcessActivityID : id,
			statusBit : bit
		},
		dataType : "text"
	});

	request.done(function(msg) {
		//$("#log").html(msg);
		$("#checkcomplete-" + id).attr("disabled", true);
		$("#checkna-" + id).attr("disabled", true);
		$("#completedby-" + id).html($('#pimuser').html());
		currentSubProcessCheck();
	});

	request.fail(function(jqXHR, textStatus) {
		alert("Request failed: " + textStatus);
	});
}

function currentSubProcessCheck() {
	var currentsubID = $("#currentsub").val();
	var instanceID = $("#processInfo").attr("instanceId");
	var request = $.ajax({
		url : "/instance/getcurrentinstancesubprocess/",
		type : "POST",
		data : {
			instanceprocessid : instanceID
		},
		dataType : "json"
	});

	request.done(function(msg) {

		//Check that we have a current subprocess. This will be null when a checklist is complete
		if( typeof msg.subprocess[0] != 'undefined') {
			//If they are different, we have a new subprocess and want to reload the page to set it all correct
			if(msg.subprocess[0].AtulSubProcessID !== currentsubID) {
				$('#subprocesshead-' + currentsubID).removeClass('currentsub');
				$("#currentsub").val(msg.subprocess[0].AtulSubProcessID);
				$('.subprocess-' + msg.subprocess[0].AtulSubProcessID).addClass('currentsub');
				document.getElementById('subprocesshead-' + msg.subprocess[0].AtulSubProcessID).scrollIntoView();
			}
		} else {
			$('.section').removeClass('currentsub');
		}
	});

	request.fail(function(jqXHR, textStatus) {
		alert("Request failed: " + textStatus);
	});
}

function changeOwnerForm() {
	var instanceId = $('#processInfo').attr('instanceId');
	$('<div id="instanceOwnerForm" title="Change Instance Owner"><img src="/img/loading65.gif" /></div>').dialog({
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
					url : '/atulpim/updateinstanceowner',
					type : 'post',
					data : {
						instanceId : instanceId,
						newOwner : newOwner
					},
					success : function(data) {
						if(data.success) {
							window.location.reload();

						}
					}
				});
			}
		},
		width : 500
	});
	$.ajax({
		url : '/atulpim/instanceownerform',
		data : {
			instanceId : instanceId
		},
		type : 'post',
		success : function(data) {
			$('#instanceOwnerForm').html(data);
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