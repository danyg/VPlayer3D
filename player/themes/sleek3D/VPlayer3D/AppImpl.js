/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

/* jshint ignore:start */
.import "./Core.js" as Core
// .import "./Subtitles.js" as Subtitles
// .import "./Settings3D.js" as Settings3D
.pragma library
/* jshint ignore:end */
// ****************************************************************************
// Initialization METHODS
// ****************************************************************************
var props = {};

var app;
var vlcPlayer;
var settings;
var fireQmlMessage;
var plugin;
var wjs;

/**
 * TEMPLATE TO BE COPIED TO OTHER LIBRARIES

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

 *
 */

/**
 * Called By Core and is executed when all the CoreComponents are ready
 *
 * @param  {VPlayer.App} AppInstance
 * @return {[type]}             [description]
 */
function storeGlobalData(root, vlc, sets, fire, plug, functions_qml) {
	app = root;
	vlcPlayer = vlc;
	settings = sets;
	fireQmlMessage = fire;
	plugin = plug;
	wjs = functions_qml;

	set('app', app);
	set('vlcPlayer', vlcPlayer);
	set('settings', settings);
	set('fireQmlMessage', fireQmlMessage);
	set('plugin', plugin);
	set('wjs', wjs);
}

function init() {
	Core.info('APP Instantiated');

	_observeSettings();

	connectTo(vlcPlayer.mediaPlayerMediaChanged, _onMediaChanged);

	this._emit('initialize', this);

	wjs.onApplicationStart();


	// for(var i=0; i < vlcPlayer.playlist.itemCount; i++){
	// 	Core.log(vlcPlayer.playlist.items[i]);
	// }

	// Core.info('MEDIA DESCRIPTION', vlcPlayer.mediaDescription);
}



/**
 * Called when the App.qml Wraper is loaded
 * NOTE: this method is called in a very early moment of the application
 * initialization There Be Dragons
 *
 * @param  {VPlayer.App} AppInstance
 */
function _qmlLoaded() {
	Core.info('APP._qmlLoaded');
	Core.trace();

	connectTo(plugin.jsMessage, _onMessage, this);
	wjs.onQmlLoaded();
}

function set(prop, val){
	props[prop] = val;
}

function get(prop, val){
	return props[prop] || undefined;
}

// ****************************************************************************
// Event Handler / Communication with Javascript METHODS
// ****************************************************************************

var eventHandlers = {};

function on(event, cbk){
	Core.log('<AppImpl.on>', event);
	// Core.trace();
	// Core.log('</AppImpl.on>');


	if(!eventHandlers.hasOwnProperty(event)){
		eventHandlers[event] = [];
	}
	eventHandlers[event].push(cbk);
}

function trigger(event, data){
	Core.log('<AppImpl.trigger>', event);
	Core.trace();
	Core.log('</AppImpl.trigger>');

	var eventObject = {
		'event': event.toString()
	};

	if(!!data){
		eventObject.data = data;
	}
	var strEvent = JSON.stringify(eventObject);
	fireQmlMessage(strEvent);
}

function _emit(event, data){
	Core.log('<AppImpl._emit>', event);
	Core.trace();
	Core.log('</AppImpl._emit>');

	if(eventHandlers.hasOwnProperty(event)){
		eventHandlers[event].every(function(cbk){
			try{
				Core.info('AppImpl._emit Executing listner:', event);
				cbk.call(null, data);
			}catch(e) {
				Core.error('AppImpl._emit:', e.message, e.stack);
			}
			return true;
		});
	}
}

function _onMessage(message){
	var jsonMessage;
Core.log('ONMESSAGE', message);
	if(message === '[refresh-playlist]'){
		this._emit('refreshPlaylist');
		return;
	}
	try{
		jsonMessage = JSON.parse(message);

		if (!!jsonMessage.event){
			this._emit(jsonMessage.event, jsonMessage.data);
		}
	}catch(e){}
}

// ****************************************************************************
// Settings Storage and Retrieval METHODS
// ****************************************************************************

var settingsToStore = [
	'subtitles3DOffset', 'subtitlesBottomOffset', 'subSize',
	'brightness', 'contrast', 'gamma'
];

var notUpdateSettings = false;

function _observeSettings(){
	settingsToStore.every(function(prop){
		connectTo(settings[prop + 'Changed'], _triggerSettingsChange.bind(this, prop));
		return true;
	});

	on('storedSettings', _onSettings);
	on('storedVolume', setVolume);

	trigger('requestSettings');
}

function _onSettings(sets){
	notUpdateSettings = true;
	var l = Object.keys(sets);
	Core.log('newSettings received', l);

	l.every(function(key){
		settings[key] = sets[key];
		return true;
	});
	notUpdateSettings = false;
}

function _triggerSettingsChange(settingName){
Core.log('Settings Changed:', settingName, ' Able to Update:', notUpdateSettings);
	if(notUpdateSettings){
		return;
	}

	var data = {};
	settingsToStore.every(function(prop){
		data[prop] = settings[prop];
		return true;
	});

	trigger('settingsChanged', data);
}

// ****************************************************************************
// Event METHODS
// ****************************************************************************
var lastMediaChangedItem = null;
function _onMediaChanged() {
	var item = vlcPlayer.playlist.items[vlcPlayer.playlist.currentItem];

	if(!!item && (lastMediaChangedItem !== item.mrl)){
		item = JSON.parse(JSON.stringify(item)); // COPY
		if(!!item.setting){
			item.setting = JSON.parse(item.setting);
		}
		item.title = item.title.replace('[custom]', '');
		item.vidItem = vlcPlayer.playlist.currentItem;

		lastMediaChangedItem = item.mrl;

		trigger('mediaChanged', item);
		_emit('mediaChanged', item);
	}
}

function connectTo(signal, cbk, ctx){
	try{
		var handler = function(){
			try{
				cbk.apply(ctx || null, arguments);
			} catch(e){
				Core.error('Error on connect', e.message, e.stack);
			}
		};
		signal.connect(handler);
	}catch(e){
		Core.error(e.message, e.stack);
	}
}

// ****************************************************************************
// MULTIMEDIA METHODS
// ****************************************************************************

function setVolume(vol, dontStoreIt){
	if(!vlcPlayer){
		return;
	}
	vlcPlayer.volume = vol;
	if(dontStoreIt !== true){
		trigger('volumeChanged', vol);
	}
	infoMsg('Volume ' + Math.round((125 * vol)/200) + '%');
}

function setDefaultColorValues(){
	setGamma(1);
	setBrightness(1);
	setContrast(1);
	infoMsg('Video Colors: Defaults');
}

function setGamma(val){
	if(!vlcPlayer){
		return;
	}
	infoMsg('Gamma: ' + Math.round((100 * val)) + '%');
	vlcPlayer.video.gamma = val;
	settings.gamma = val;
}

function setBrightness(val){
	if(!vlcPlayer){
		return;
	}
	infoMsg('Brightness: ' + Math.round((100 * val)) + '%');
	vlcPlayer.video.brightness = val;
	settings.brightness = val;
}

function setContrast(val){
	if(!vlcPlayer){
		return;
	}
	infoMsg('Contrast: ' + Math.round((100 * val)) + '%');
	vlcPlayer.video.contrast = val;
	settings.contrast = val;
}

function setVideoTime(time){
	if(!vlcPlayer){
		return;
	}
	vlcPlayer.time = time;
	_emit('videoSeeked', time);
}

function setSubtitlesPosition(pos){
	settings.subtitlesBottomOffset += pos;
	app.infoMsg('Subtitles position '+ settings.subtitlesBottomOffset);
}

function pause(){
	if (vlcPlayer.playing) {
		vlcPlayer.togglePause();
	}
}
function play(){
	if (!vlcPlayer.playing) {
		vlcPlayer.togglePause();
	}
}

// ****************************************************************************
// ELEMENT INTERACTION METHODS
// ****************************************************************************

function infoMsg(msg, notClean){
	if(!!Core.getComponent('OSD_topRight')){
		Core.getComponent('OSD_topRight').setText(msg, notClean);
	}
}