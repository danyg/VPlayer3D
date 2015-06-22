/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/
define([
	'service!app'
], function(
	app
){
	'use strict';

	function Settings(){
		app.on('settingsChanged', this._onNewSettings.bind(this));
		app.on('volumeChanged', this._onNewVolume.bind(this));
		app.on('requestSettings', this._onPlayerStart.bind(this));
	};

	Settings.prototype._onNewSettings = function(settings){
		localStorage.setItem('vplayerSettings', JSON.stringify(settings));
	};

	Settings.prototype._onNewVolume = function(vol){
		localStorage.setItem('vplayerVolume', JSON.stringify(vol));
	};

	Settings.prototype._onPlayerStart = function(){
		var storedSettings = localStorage.getItem('vplayerSettings');
		app.trigger('storedSettings', JSON.parse(storedSettings));

		var storedVolume = localStorage.getItem('vplayerVolume');
		app.trigger('storedVolume', JSON.parse(storedVolume));
	};

	return new Settings();
});