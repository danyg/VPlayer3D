/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/
define([
	'wjs',
	'service!utils',
	'debug'
], function(
	wjs,
	utils,
	debug
){
	'use strict';

	var EventEmitter = require('events'),
		util = require('util')
	;

	function App(){
		this.playlist = [];
	}

	util.inherits(App, EventEmitter);

	App.prototype.start = function(){
		wjs('#player_wrapper').addPlayer({
			id: 'webchimera',
			theme: 'sleek3D',
			autoplay: 1,
			debug: debug,
			'adjust-filter': 1
		});
		this.player = wjs('#webchimera');
		this.player.onMessage(this._onMessage.bind(this));
/*
		var BASE = 'Z:/';
		var fs = require('fs');
		if(fs.existsSync('Z:/')){
			BASE = 'Z:/';
		} else {
			BASE = 'D:/Pelis/';
		}

		this.playlist.push({
			url: 'file:///' + BASE + '/Jupiter Ascending (2015) [1080p]/Jupiter.Ascending.2015.1080p.BluRay.x264.YIFY.mp4'
		});
		this.playlist.push({
			url: 'file:///' + BASE + '/_3D_/Exodus Gods and Kings 2014 1080p 3D BRRip Half-OU x264 DTS-JYK/Exodus Gods and Kings 2014 1080p 3D BRRip Half-OU x264 DTS-JYK.mkv'
		});
		this.playlist.push({
			url: 'file:///' + BASE + '/_3D_/Iron%20Man%203%20(2013)%20[3D]%20[HSBS]/Iron.Man.3.2013.1080p.3D.HSBS.BluRay.x264.YIFY.mp4'
		});
		this.playlist.push({
			url: 'file:///' + BASE + '/_3D_/Seventh Son 2014 3D 1080p BRRip Half-OU x264 DTS-JYK/Seventh Son 2014 3D 1080p BRRip Half-OU x264 DTS-JYK.mkv'
		});
		this.playlist.push({
			url: 'file:///' + BASE + '/_3D_/Jurassic Park 3D 1993 1080p BluRay Half-OU x264 x264 AAC - Ozlem/Jurassic Park 3D 1993 1080p BluRay Half-OU x264 x264 AAC - Ozlem.mp4'
		});

		this.playlist.push({
			url: 'file:///' + BASE + '/_3D_/Guardians Of The Galaxy 3D 2014 1080p BRRip Half-OU x264 DTS-JYK/Guardians Of The Galaxy 3D 2014 1080p BRRip Half-OU x264 DTS-JYK.mkv'
		});

		this.player.addPlaylist(this.playlist);*/

		this._dom = {};
		requirejs(['domReady!'], this._onDomReady.bind(this));
	};

	App.prototype._onDomReady = function(){
		this._dom.player = document.getElementById('player_wrapper');
		this._dom.close = document.getElementById('close');


		window.addEventListener('dragover', this._onDragOver.bind(this), false);
		window.addEventListener('dragleave', this._onDragLeave.bind(this), false);
		window.addEventListener('drop', this._onDrop.bind(this), false);
		window.addEventListener('resize', this.resize.bind(this), false);
		this._dom.close.addEventListener('click', this.close.bind(this), false);
		this.resize();

	};

	App.prototype.close = function(){
		process.exit();
	};

	App.prototype.resize = function(){
		this._dom.player.style.width = (window.innerWidth - 10) + 'px';
		this._dom.player.style.height = (window.innerHeight - 35) + 'px';

		this.player.resetSize();
	};

	App.prototype._onDragOver = function(e){
		e.preventDefault();
		this._dom.player.style.visibility = 'hidden';
		return false;
	};

	App.prototype._onDragLeave = function(e){
		window.console.log('DragLeave');
		e.preventDefault();
		this._dom.player.style.visibility = '';
		return false;
	};

	App.prototype._onDrop = function(e){
		e.preventDefault();

		try{
			this._setPlaylist(e.dataTransfer.files);
		} catch (er){
			console.log('Error Loading ', e.dataTransfer.files[0].path, er);
		}
		this._dom.player.style.visibility = '';

		return false;
	};


	App.prototype._setPlaylist = function(eventDataTransfer){
		var i, file;
		this.playlist = [];
		for(i = 0; i < eventDataTransfer.length; i++){
			file = eventDataTransfer[i];
			this.playlist.push({
				url: utils.toUrl(file.path)
			});
		}
		this.player.clearPlaylist();
		this.player.addPlaylist(this.playlist);
		this.player.playItem(0);
	};

	App.prototype.getItem = function(ix){
		return this.playlist[ix];
	};

	App.prototype._onMessage = function(message){
		if(message.indexOf('"event":') !== -1){
			var json = JSON.parse(message);
			this.emit(json.event, json.data);
		}
	};

	App.prototype.emit = function(){
		console.log(this.constructor.name,'emit', arguments);
		return EventEmitter.prototype.emit.apply(this, arguments);
	};

	App.prototype.trigger = function(event, data){
		var eventObject = {
			event: event
		};
		if(!!data){
			eventObject.data = data;
		}
		var message = JSON.stringify(eventObject);
		console.log(this.constructor.name,'trigger', JSON.parse( message ));
		this.player.emitJsMessage(message);
	};

	return new App();
});