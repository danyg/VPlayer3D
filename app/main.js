/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/
!(function(){

	'use strict';

	var vendor_path = '../vendor';

	requirejs.config({
		baseUrl: '/app',
		paths: {
			// debug: 'debugOn',
			debug: 'debugOff',
			wjs: '../player/webchimera',
			domReady: vendor_path + '/domReady/domReady'
		},
		shim:{
			wjs: {
				exports: 'wjs'
			}
		}
	});

	requirejs([
		'moduleLoader',
		'debug'
	], function(
		mLoader,
		debug
	){

		if(debug){
			window.console.log('Starting App');
		}

		requirejs([
			'service!subtitles',
			'service!settings',


			'service!app',
		], function(subtitles, settings, app){
			app.start();

		});

	});
})();