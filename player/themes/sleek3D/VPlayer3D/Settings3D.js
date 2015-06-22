/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

.import "./Core.js" as Core
// .pragma library

var c_MODE_2D = 0;
var c_MODE_HSBS = 1;
var c_MODE_HALFOU = 3;

var c_LEFT_EYE = 1;
var c_RIGHT_EYE = 2;

function getMode() {
	return settings.mode3D;
}

function setMode(theMode) {
	Core.log('the mode setted is: ', theMode);
	settings.mode3D = theMode;
}

function init(){
	// vlcPlayer.mediaPlayerMediaChanged.connect(_checkMode);
	app.on('mediaChanged', _checkMode);
}

function _checkMode(item){
	var fileName = item.mrl.split('/').pop();

	Core.log('GETTING 3D Mode from ', fileName);

	if(fileName.match(/half.?ou/i) !== null){
		setMode(c_MODE_HALFOU);
	}
	else if(fileName.match(/hsbs/i) !== null){
		setMode(c_MODE_HSBS);
	}else{
		setMode(c_MODE_2D);
	}

}