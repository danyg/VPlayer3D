/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

.import './Core.js' as Core
.import './AppImpl.js' as App

.pragma library

var lastPlItem;
var subtitleTracksIXbyID = {};
var lastLine;

var app;
var vlcPlayer;
var settings;
var fireQmlMessage;
var plugin;
var wjs;

function exportVars(obj){
	app = App.get('app');
	vlcPlayer = App.get('vlcPlayer');
	settings = App.get('settings');
	fireQmlMessage = App.get('fireQmlMessage');
	plugin = App.get('plugin');
	wjs = App.get('wjs');
}

App.on('initialize', init);

function init(){
	exportVars();

	Core.info('Subtitles Instantiated');

	show('');

	App.on('mediaChanged', _recheckSubs);

	App.connectTo(vlcPlayer.mediaPlayerTimeChanged, _onTimeChanged);
	App.on('videoSeeked', _resetLastTrackIx);

	App.on('subtitlesList', _setSubtitlesList);
	App.on('subtitle', _useSubtitle);

	App.on('searchingSubtitles', function(){
		App.infoMsg('Searching subtitles...', false);
		App.pause();
	});

	App.on('subtitlesFound', function(length){
		App.infoMsg(length + ' subtitles found');
		// App.play();
	});

	App.on('downloadSubtitle', function(){
		App.infoMsg('Downloading subtitle...', false);
		App.pause();
	});


	App.on('subtitlesNotFound', function(){
		App.infoMsg('No subtitles found');
		App.play();
	});

}

function show(text) {
	Core.getComponent('subsBox').set('changeText', text.replace(/\n/g, '<br>'));
}

function select(id){
	Core.warn('SUBTITLES select', id);
	Core.trace();

	settings.curSubtitleTrack = id;
	app.trigger('subtitleSelected', id);

	app.infoMsg("Subtitle: " + settings.subtitleTracks[id].movieName);
}

function acquire(item){
	Core.log('Subtitle.acquire', item.getId());
	select(item.getId());
}

var lastTrackIx = 0;
function setDelay(delay){
	settings.subDelay = delay;
	_resetLastTrackIx();

	// not used and performance issue
	// vlcPlayer.subtitle.delay = settings.subDelay;
	app.infoMsg("Subtitle Delay: " + settings.subDelay + " ms");
}
function increaseDelay(){
	setDelay(settings.subDelay +50);
}
function decreaseDelay(){
	setDelay(settings.subDelay -50);
}


function _resetLastTrackIx(){
	Core.log('SUBTITLES reset trackIx');
	lastTrackIx = 0;
}
function _onTimeChanged(){
	if(!settings.curSubtitleTrack){
		return;
	}
	vlcPlayer.subtitle.track = 0; // disable VLC Show subs

	var nowSecond = (vlcPlayer.time - settings.subDelay);
	if(settings.subtitleTracks === undefined || settings.subtitleTracks[settings.curSubtitleTrack] === undefined ){
		return;
	}

	var tracks = settings.subtitleTracks[settings.curSubtitleTrack].tracks;
	if(!!tracks && tracks.length > 0){
		var line = null;

		for(var i = 0; i < tracks.length; i++){
			if(tracks[i].start > nowSecond) {
				break;
			}
			line = tracks[i];
		}

		if(!line){
			return;
		}

		if(line.end < nowSecond){
			// lastTrackIx = i+1;
			// Core.log('SUBTITLES: ix used (clean)', i + '/' + tracks.length);
			show('');
			return;
		}

		if(line !== lastLine){
			// lastTrackIx = i-1;
			// Core.log('SUBTITLES: ix used', i + '/' + tracks.length);
			show(line.text);
			lastLine = line;
			return
		}

		// if(i > lastTrackIx+1){
		// 	Core.warn('SUBTITLES: ix searched until', i + '/' + tracks.length);
		// }
	}
}

function _setSubtitlesList(subList){
	var curId = null;
	settings.subtitleTracks = {}

	for(var i=0, item; i < subList.length; i++){
		item = subList[i];
		item.tracks = [];
		settings.subtitleTracks[item.id] = item;
		curId = curId === null ? item.id : curId;
	}

	if(settings.curSubtitleTrack === null){
		select(curId);
	}
}

function _recheckSubs(item){
	if(lastPlItem !== item){
		show('');

		_resetLastTrackIx();

		settings.subtitleTracks = {};
		settings.curSubtitleTrack = null;
	}
}

function _useSubtitle(data){
	_resetLastTrackIx();

	Core.info('SUBTITLES Using subtitle ID: ', data.id, 'tracks received: ', data.subtitles.length);
	settings.curSubtitleTrack = data.id;
	settings.subtitleTracks[data.id].tracks = data.subtitles;

	App.play();
}
