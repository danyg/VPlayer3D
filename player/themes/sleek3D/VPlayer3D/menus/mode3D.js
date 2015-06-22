/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

.import '../Settings3D.js' as Settings3D

var modes = {
	'2D': Settings3D.c_MODE_2D,
	'Side By Side': Settings3D.c_MODE_HSBS,
	'Top and Bottom': Settings3D.c_MODE_HALFOU
}

function addMenu(list){
	var item = {
		text: 'Mode 3D',
		kind: 'mode3D',
		subitems: []
	};



	for (var i in modes) {
		item.subitems.push({
			text: i,
			kind: 'mode3d_' + modes[i],
			isSelected: _getIsSelected( i ),
			click: _getClick(i)
		})
	}

	list.push(item);
}

function _getIsSelected(ix){
	return function(){
		return Settings3D.getMode() === modes[ix];
	}
}

function _getClick(ix){
	return function(){
		Settings3D.setMode(modes[ix]);
		app.infoMsg("3D Mode: " + ix);
	}
}
