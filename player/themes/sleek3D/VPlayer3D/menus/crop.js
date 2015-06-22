/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

function addMenu(list){
	var item = {
		text: 'Crop',
		kind: 'crop',
		subitems: []
	};

	for (var i = 0; i < settings.crops.length; i++) {
		item.subitems.push({
			text: settings.crops[i],
			kind: 'crop_' + i,
			isSelected: _getIsSelected( i ),
			click: _getClick(i)
		})
	}

	list.push(item);
}

function _getIsSelected(ix){
	return function(){
		return settings.curCrop === settings.crops[ix];
	}
}

function _getClick(ix){
	return function(){
		settings.curCrop = settings.crops[ix];
		if (settings.curCrop == "Default") {
			wjs.resetAspect();
		} else {
			wjs.changeAspect(settings.curCrop, "crop");
		}
		app.infoMsg("Crop: " + settings.curCrop);
	}
}
