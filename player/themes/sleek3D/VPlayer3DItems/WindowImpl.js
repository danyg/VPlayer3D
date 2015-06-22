/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

/* jshint ignore:start */
.import "../VPlayer3D/Core.js" as Core
.import "../VPlayer3D/AppImpl.js" as App
.pragma library
/* jshint ignore:end */

var windows = {},
	windowsList = [],
	inits = {}
;

function init(window){
	if(_setInitiated(window)){
		windows[window.componentType] = window;
		windowsList.push(window);
	}
}

function _setInitiated(window){
	if(!inits.hasOwnProperty(window.componentType)){
		inits[window.componentType] = 0;
	}
	inits[window.componentType]++;
	if(inits[window.componentType] === 2){
		return true;
	} else if (inits[window.componentType] > 2){
		Core.error('WindowImpl there is 2 or more windows with the same componentType', window.componentType);
	}

	return false;
}

function onOpen(window){
	for(var i = 0; i < windowsList.length; i++){
		windowsList[i].close();
	}
}