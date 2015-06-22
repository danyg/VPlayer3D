/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

function addMenu(list){
	var item = {
		text: 'Font size',
		kind: 'subtitle_size',
		subitems: []
	};

	for (var i = 0; i < settings.subPresets.length; i++) {
		item.subitems.push({
			text: settings.subPresets[i][1],
			kind: 'fontSize_' + i,
			isSelected: _getIsSelected( i ),
			click: _getClick(i)
		})
	}

	list.push(item);
}

function _getIsSelected(ix){
	return function(){
		return settings.subSize === ix;
	}
}

function _getClick(ix){
	return function(){
		var subSize = settings.subPresets[ix];
		settings.subSize = ix;
	}
}
