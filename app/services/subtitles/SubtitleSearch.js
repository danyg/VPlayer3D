/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/
define([
	'service!utils'
], function(
	utils
){
	'use strict';

	var opensubtitles = require('opensubtitles-client'),
		fs = require('fs'),
		__token = null
	;

	function logout(){
		opensubtitles.api.logout(__token);
		__token = null;
	}


	function SubtitleSearch(filePath, searchLanguages){
		this._filePath = filePath;
		this._searchLanguages = searchLanguages.join(',');
	}

	SubtitleSearch.prototype.search = function(){
		this.dfd = utils.defer();

		if(!!__token){
			this._search();
		} else {
			opensubtitles.api.login()
				.then(this._onOSLogin.bind(this))
			;
		}

		return this.dfd.promise;
	};

	SubtitleSearch.prototype._onOSLogin = function(token){
		__token = token;
		this._search();
	};

	SubtitleSearch.prototype._search = function(){
		if(fs.existsSync(this._filePath)){
			opensubtitles.api.searchForFile(
				__token,
				this._searchLanguages,
				this._filePath
			).then(this._processResult.bind(this));

		} else {
			console.error('SubtitleSearch File doesn\'t exists', this._filePath);
		}
	};

	SubtitleSearch.prototype._processResult = function(results){
		this.dfd.resolve(results);
	};

	return SubtitleSearch;
});