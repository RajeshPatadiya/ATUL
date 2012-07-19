/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * injects a new tree multi-select div into a specified element
 * 
 * @param after = a jquery selector for the element that the new div will come after
 * @param id = the ID of the created div
 * @param data = flat two dimensional tree data with ID in the last column of each row
 * @param selected = array of pre-selected IDs
 * @param multi = boolean - allow multi-select or restrict to single select
 * @param clickFunction = anonymous funtion to call when a leaf node is clicked
 * @param invertLimit = maximum number of selectable nodes before invert is disabled. defaults to 50. 0 = no limit
 */

function createTreeMultiselect(after, id, data, selected, multi, clickFunction, invertLimit){
	if (invertLimit == null){
		invertLimit = 50;
	}

	if (typeof(window.multiselectItems) == 'undefined'){
		window.multiselectItems = new Array();
	}
	var tree = new Array();
	var branch, nodeID;
	for (i in data){
		nodeID = data[i].pop();
		branch = rollUpBranch(data[i],nodeID);
		$.extend(true, tree, branch);
	}

	var divHTML = '<div id="' + id + '" style="display: none;"><span id="treemultiselectfilter">Filter: <input id="'+id+'Filter" type="text" title="Regex Compatible"> <img id="'+id+'ClearFilter" src="/img/close_sm.png" title="Clear Filter"></span></div>';
	
	$('#' + id).remove();

	$(after).after(divHTML);
	$('#' + id + 'Filter').keyup(function(event){
		handleFilter(this, event);
	});
	$('#' + id).append('<div class="treemultiselectulcontainer">' + makeUlTree(tree,0) + '</div>');
	$('#' + id + ' li:has(li)').each(function(index){
		$(this).addClass('haschildren');
		// if a node has no siblings, pre-open its children so the user doesn't have to descend a tall tree with
		// only one choice at each level to reach the bottom.  we always want to eliminate pointless manual twiddling
		if ($(this).siblings().length == 0){
			var level = $(this).attr('level');
			$(this).addClass('visiblechildren');
			$(this).children().children().addClass('visible');
		}
	});
	$('#' + id + ' li').click(function(event){
		handleClick(this, event, multi, clickFunction);
	});
	$('#' + id + ' li[nodeID]').prepend('<span class="checkbox">&nbsp;</span>');
	$('#' + id + '>div.treemultiselectulcontainer>ul>li').addClass('visible');
	$('#' + id + '>div.treemultiselectulcontainer>ul').addClass('border');
	if ($.browser.msie){
		//FIXME: A sad, sad hack to make the checkboxes appear left of the scroll bar in IE.  sigh....
		$('#' + id + '>div.treemultiselectulcontainer').css('padding-right','14px');
	}
	for (i in selected){
		$('#' + id + ' li[nodeid=' + selected[i] + ']').addClass('selected');
	}
	$('#' + id + ' li:has(.selected)').addClass('selecteddescentants');
	$('#' + id + 'ClearFilter')
		.css('cursor','pointer')
		.click(function(){
			$(this).siblings('input').val('').keyup();
		});
	$('#' + id + 'Filter')
		.keyup(function(event){
			handleFilter(this, event);
		});
	if (multi){
		var checkboxes = $('#' + id +' li[nodeid] span.checkbox');
		if (invertLimit == 0 || checkboxes.length <= invertLimit){
			$('#' + id + 'ClearFilter').after('<span class="invert" title="Invert Selection">&nbsp;</span>');
			$('#' + id + ' span.invert').click(function(){
				$(this).parent().find('li[nodeid] span.checkbox').click();
			});
		}
	}
}

//recursively build a tree of ULs using a tree object
function makeUlTree(tree, level){
	var output = '';
	var valueString;
	for (i in tree.children){
		if (typeof(tree.children[i].id) != 'undefined'  && tree.children[i].id != ''){
			valueString = ' nodeID="' + tree.children[i].id + '"';
		} else {
			valueString = '';
		}
		output = output + '<li class="treemultimenu"' + valueString + ' level="' + level + '"><div class="treemultimenutext">' + i + '</div>';
		output = output +  makeUlTree(tree.children[i], level + 1) ;
		output = output + '</li>';
	}
	if (output != ''){
		output = '<ul class="treemultimenu">' + output + '</ul>';
	}
	return output;
}

// recursively create a branch object from a linear path 
// these are merged to form a tree
function rollUpBranch(path, nodeValue){
	var result = {children:new Array()};
	if (path.length > 0){
		result.children[path.shift()] = rollUpBranch(path, nodeValue);
	} else {
		result.id = nodeValue;
	}
	return result;
}

function handleClick(element, event, multi, clickFunction){
	var level = parseInt($(element).attr('level'));
	var elementParents = $(element).parentsUntil('div');
	var topUL = elementParents[elementParents.length - 1];
	// is this a leaf node?
	if($(event.originalTarget).hasClass('checkbox') || $(event.srcElement).hasClass('checkbox') || $(element).find('li[level=' + (level + 1) + ']').toggleClass('visible').length == 0){
		if (multi){
			$(element).toggleClass('selected');
		} else {
			$(topUL).find('li.selected').removeClass('selected');
			$(element).addClass('selected');
		}
		clickFunction(element);
	} else {
		$(element).toggleClass('visiblechildren');
	}
//TODO: is there a way to make the scan below more efficient?
	$(topUL).find('li').removeClass('selecteddescentants');
	$(topUL).find('li:has(.selected)').addClass('selecteddescentants');
	event.stopPropagation();
}

function handleFilter(element, event){
	if (typeof(window.multiselectItems[element.id]) == 'undefined'){
		window.multiselectItems[element.id] = new Array();
		topUL = $('#' + element.id).parent().parent().find('ul.treemultimenu.border')[0];
		window.multiselectItems[element.id] = $(topUL).find('li');
	}
	if (element.value.length > 1){
		var regex = new RegExp(element.value, "i");
		window.multiselectItems[element.id].each(function(){
			if (regex.test($(this).text())) {
				$(this).addClass("filter");
				$(this).removeClass("unfilter");
			} else {
				$(this).addClass("unfilter");
				$(this).removeClass("filter");
			}
		});
	} else {
		window.multiselectItems[element.id].removeClass('filter').removeClass('unfilter');
	}
}

