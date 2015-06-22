/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

function addMenu(list){
	var item = {
		text: 'Aspect Ratio',
		kind: 'aratio',
		subitems: []
	};

	for (var i = 0; i < settings.aspectRatios.length; i++) {
		item.subitems.push({
			text: settings.aspectRatios[i],
			kind: 'ar_' + i,
			isSelected: _getIsSelected( i ),
			click: _getClick(i)
		})
	}

	list.push(item);
}

function _getIsSelected(ix){
	return function(){
		return settings.curAspect === settings.aspectRatios[ix];
	}
}

function _getClick(ix){
	return function(){
		settings.curAspect = settings.aspectRatios[ix];
		if (settings.curAspect == "Default") {
			wjs.resetAspect();
		} else {
			wjs.changeAspect(settings.curAspect,"ratio");
		}
		app.infoMsg("Aspect Ratio: " + settings.curAspect);
	}
}
