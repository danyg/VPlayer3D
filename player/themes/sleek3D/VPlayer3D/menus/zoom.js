/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

function addMenu(list){
	var item = {
		text: 'Zoom',
		kind: 'zoom',
		subitems: []
	};

	for (var i = 0; i < settings.zooms.length; i++) {
		item.subitems.push({
			text: settings.zooms[i][1],
			kind: 'zoom_' + i,
			isSelected: _getIsSelected( i ),
			click: _getClick(i)
		})
	}

	list.push(item);
}

function _getIsSelected(ix){
	return function(){
		return settings.curZoom === ix;
	}
}

function _getClick(ix){
	return function(){
		var curZoom = settings.zooms[ix];
		settings.curZoom = ix;
		wjs.changeZoom(curZoom[0]);
		app.infoMsg("Zoom Mode: " + curZoom[1]);
	}
}
