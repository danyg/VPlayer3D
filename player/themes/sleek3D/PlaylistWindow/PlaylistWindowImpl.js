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

var PlayListModel = Qt.createComponent('./PlaylistModel.qml');
var model = null;
var itemByIX = null;
var window = [];
var table = [];
var tempLM = [];
var vlcPlayer;

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
	vlcPlayer = App.get('vlcPlayer');
	App.on('initialize', _fillModel);
	App.on('refreshPlaylist', _fillModel);
	App.on('initialize', function(){
		vlcPlayer.playlist.currentItemChanged.connect(_checkCurrentItem);
		_checkCurrentItem();
	});
}

function _fillModel(){
	model = [];
	itemByIX = {};

	var elm;
	for(var i=0; i < vlcPlayer.playlist.itemCount; i++){
		elm = PlayListModel.createObject(tempLM[0], {});
		if(!!elm){
			elm.setFromData(vlcPlayer.playlist.items[i], i);
			model.push(elm);
			itemByIX[i] = elm;
		} else {
			Core.error('creating PlayListModel', i);
		}
	}

	Core.log('chargin Table');
	table[0].model = model.slice(0);
	table[1].model = model.slice(0);
}

function getItem(ix){
	return itemByIX[ix];
}

function _checkCurrentItem(){
	var value = vlcPlayer.playlist.currentItem;

	for(var i=0; i < vlcPlayer.playlist.itemCount; i++){
		if(i === value){
			itemByIX[i]._select();
			currentSelected = itemByIX[i];
		} else {
			itemByIX[i].unselect();
		}
	}
}

var currentSelected = null;
function setSelect(item){
	if(currentSelected !== null){
		try{
			currentSelected.unselect();
		}catch(e){}
	}
	currentSelected = item;

	vlcPlayer.playlist.playItem(item.ix);
}