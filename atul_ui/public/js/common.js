/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

// detect user's current offset from GMT (subtract this from GMT for local time)
setCookie('UTCOffset', new Date().getTimezoneOffset() / 60);

$(function() {
	// tabs init with a custom tab template and an "add" callback filling in the content
	var $tabs = $("#tabs").tabs({
		tabTemplate : "<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close'>Remove Tab</span></li>",
		add : function(event, ui) {
			var tab_content = $tab_content_input.val() || "Tab " + tab_counter + " content.";
			$(ui.panel).append("<p>" + tab_content + "</p>");
		}
	}).removeClass('ui-corner-all');
	// close icon: removing the tab on click
	// note: closable tabs gonna be an option in the future - see http://dev.jqueryui.com/ticket/3924
	$("#tabs span.ui-icon-close").live("click", function() {
		var index = $("li", $tabs).index($(this).parent());
		$tabs.tabs("remove", index);
	});
	$(window).resize(function() {
		doResize();
	});
	doResize();
	doTooltips();
	$(".tokenlist").live('click', function() {
		ShowTokenList();
		window.tokenlist.dialog('open');
		return false;
	});
});
$(document).ready(function() {
	$(".tokenlist").tooltip({
		effect : 'slide',
		showBody : " - ",
		fade : 250,
		showURL : false
	});
});

function doTooltips() {
	/*$('[title]').tooltip({
	 delay: 0,
	 track: true,
	 extraClass: "tooltip",
	 showBody: " - "
	 })*/
}

function doResize() {
	if($("#tabs").length > 0) {
		var tabsHeight = $(window).height() - $('#head').outerHeight() - $('#footer-wrapper').outerHeight() - $('#groupForm').outerHeight() - 120;
		var tabPages = $('#tabs > div');
		tabPages.height(tabsHeight).css('overflow', 'auto');
		var rowpos = $('tbody[active=1]').prev().find('tr:last').position();
		if(rowpos) {
			$('tbody[active=1]').closest('div').scrollTop(rowpos.top);
		}
	}
}

function validateInput(inputValue, validationType) {
	inputValue = trimAll(inputValue);
	switch (validationType) {
		case 'text':
			if(inputValue == '' || inputValue == null)
				return false;
			break;
		case 'number':
			if(inputValue == '' || inputValue == null || isNaN(inputValue))
				return false;
			break;
	}
	return true;
}

function trimAll(sString) {
	if(sString == null) {
		return null;
	}
	while(sString.substring(0, 1) == ' ') {
		sString = sString.substring(1, sString.length);
	}
	while(sString.substring(sString.length - 1, sString.length) == ' ') {
		sString = sString.substring(0, sString.length - 1);
	}
	return sString;
}

//get a cookie
function getCookie(c_name) {
	var i, x, y, ARRcookies = document.cookie.split(";");
	for( i = 0; i < ARRcookies.length; i++) {
		x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
		y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
		x = x.replace(/^\s+|\s+$/g, "");
		if(x == c_name) {
			return unescape(y);
		}
	}
}

function setCookie(c_name, value, exdays) {
	var exdate = new Date();
	var hn = window.location.hostname;
	exdate.setDate(exdate.getDate() + exdays);
	var c_value = escape(value) + ";domain=." + hn + ";path=/" + ((exdays == null) ? "" : "; expires=" + exdate.toUTCString());
	document.cookie = c_name + "=" + c_value;
}

function updateUserHistory(user, processInstance, Id, title) {
	var history = getUserHistory(user);
	if(history == null) {
		history = new Object();
		history.processes = new Array();
		history.instances = new Array();
	}
	var i = new Object();
	i.title = title;
	var position = -1;
	var x
	if(processInstance == 'process') {
		i.url = '/process/editor/processid/' + Id;
		for( x = 0; x <= history.processes.length; x++) {
			if( typeof history.processes[x] !== 'undefined' && history.processes[x].url == i.url) {
				history.processes.splice(x, 1);
			}
		}
		history.processes.push(i);
	} else if(processInstance == 'instance') {
		i.url = '/atulpim/instance/pid/' + Id;
		for( x = 0; x <= history.instances.length; x++) {
			if( typeof history.instances[x] !== 'undefined' && history.instances[x].url == i.url) {
				history.instances.splice(x, 1);
			}
		}
		history.instances.push(i);
	}
	if(history.instances.length >= 10) {
		history.instances.shift();
	}
	if(history.processes.length >= 10) {
		history.processes.shift();
	}
	var cookie = JSON.stringify(history);
	setCookie('uxh_' + user, cookie, 30);
}

function getUserHistory(user) {
	var cookie = getCookie('uxh_' + user);
	if(cookie == null || cookie == '') {
		return null;
	} else {
		return JSON.parse(cookie);
	}
}

function doGetCaretPosition(ctrl) {
	var CaretPos = 0;
	// IE Support
	if(document.selection) {
		ctrl.focus();
		var Sel = document.selection.createRange();
		Sel.moveStart('character', -ctrl.value.length);
		CaretPos = Sel.text.length;
	}
	// Firefox support
	else if(ctrl.selectionStart || ctrl.selectionStart == '0')
		CaretPos = ctrl.selectionStart;
	return (CaretPos);
}

function setCaretPosition(ctrl, pos) {
	if(ctrl.setSelectionRange) {
		ctrl.focus();
		ctrl.setSelectionRange(pos, pos);
	} else if(ctrl.createTextRange) {
		var range = ctrl.createTextRange();
		range.collapse(true);
		range.moveEnd('character', pos);
		range.moveStart('character', pos);
		range.select();
	}
}

function errorDialog(msg) {
	$('<div title="Error"><p>' + msg + '</p></div>').dialog({
		close : function() {
			$(this).remove()
		},
		buttons : {
			Close : function() {
				$(this).dialog('close');
			}
		}
	});
}

function ShowTokenList() {
	$("#tokenlistdialog").dialog("open");
	window.tokenlist = $('#tokenlistdialog').dialog({
		autoOpen : false,
		title : 'Token List',
		width : 550,
		modal : false
	});
	return false;
}

function AddTokenToTokenList(fname, tname) {
	$('#tokenlisttable').append('<tr><td>' + fname + '</td><td>@' + tname + '@</td></tr>');
}

function RemoveTokenFromTokenList() {

}
