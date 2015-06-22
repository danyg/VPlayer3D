/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

.import "../VPlayer3D/Core.js" as Core
.import "../VPlayer3D/AppImpl.js" as App
.import "../VPlayer3D/Subtitles.js" as Subtitles
.pragma library


var SubObj = Qt.createComponent("./SubObj.qml");
var model = null;
var window = [];
var table = [];
var tempLM = [];

function init(w, t, tmp){
	try{
		window.push(w);
		table.push(t);
		tempLM.push(tmp);

		if(table.length === 2){
			_start();
		}

	}catch(e){
		Core.error(e.message, e.stack);
	}
}

function close(){
	window[0].close();
}

function _start(){
	App.on('mediaChanged', _cleanList);
	App.on('subtitlesList', onSubtitlesList);
	App.on('subtitle', _useSubtitle);
}

function _cleanList(){
	onSubtitlesList([]);
}
function onSubtitlesList(data){
	Core.log('subtitlesList Received', data.length);

	currentSelected = null;
	model = data.map(function(item){
		var elm = SubObj.createObject(tempLM[0], {});
		if(!!elm){
			elm.setFromData(item);
		} else {
			Core.error('creating SubObj', item);
		}
		return elm;
	});

	Core.log('chargin Table');
	table[0].model = model.slice(0);
	table[1].model = model.slice(0);
};

function getItem(item){
	return model[item];
}

var currentSelected = null;
function setSelect(item){
	if(currentSelected !== null){
		try{
			currentSelected.unselect();
		}catch(e){}
	}
	currentSelected = item;

	Subtitles.acquire(item);
}

function _useSubtitle(data){
	Core.log('SubtitlesWindowImpl _useSubtitle', data.id);
	var item = model.filter(function(i){
		return i.getId() === data.id;
	});

	Core.log('SubtitlesWindowImpl _useSubtitle', item.length);

	if(item.length > 0){
		item[0]._select();
		currentSelected = item[0];
		close();
	}
}