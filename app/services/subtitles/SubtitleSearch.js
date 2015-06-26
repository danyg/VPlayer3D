/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/
define([
	'service!utils',
	'./SubList.js'
], function(
	utils,
	SubList
){
	'use strict';

	var opensubtitles = require('opensubtitles-client'),
		fs = require('fs'),
		path = require('path'),
		SubDb = require('subdb'),
		__OSToken = null
	;

	function logout(){
		opensubtitles.api.logout(__OSToken);
		__OSToken = null;
	}


	function SubtitleSearch(filePath, searchLanguages){
		this._filePath = filePath;
		this._searchLanguages = searchLanguages;
	}

	SubtitleSearch.prototype.search = function(){
		var dfd = utils.defer(),
			promises = [],
			me = this
		;
		this._subList = new SubList();

		if(!!__OSToken){
			promises.push(
				this._searchOS()
			);
		} else {
			promises.push(
				opensubtitles.api.login()
					.then(this._onOSLogin.bind(this))
			);
		}
		promises.push(
			this._subDBSearch()
		);

		utils.promiseAll(promises)
			.then(function(){
				dfd.resolve(me._subList);
			})
		;

		return dfd.promise;
	};

	SubtitleSearch.prototype._subDBSearch = function(){
		var dfd = utils.defer();
		this._subdb = new SubDb();

		utils
			.wrapPromise(
				this._subdb,
				this._subdb.computeHash,
				this._filePath
			)()
			.then(this._onSubDBHash.bind(this))
			.then(this._processSubDBResults.bind(this))
			.then(function(){
				dfd.resolve();
			})
		;

		return dfd.promise;
	};

	SubtitleSearch.prototype._resolved = function(err){
		var dfd = utils.defer();
		dfd.resolve();
		return dfd.promise;
	};

	SubtitleSearch.prototype._onSubDBHash = function(args){
		var err = args[0],
			hash = args[1]
		;

		if(err){
			return this._resolved(err);
		}

		this._subdbHash = hash;

		return utils.wrapPromise(
			this._subdb.api,
			this._subdb.api.search_subtitles,
			hash
		)();
	};

	SubtitleSearch.prototype._processSubDBResults = function(args){
		var err = args[0],
			results = args[1]
		;

		if(err){
			return this._resolved(err);
		}

		var dfd = utils.defer(),
			movieName = path.basename(this._filePath, path.extname(this._filePath)),
			me = this
		;

		setTimeout(function(){
			results.forEach(function(lang){
				var isoLang = utils.iso6391to6392(lang);
				if(!!isoLang && me._searchLanguages.indexOf(isoLang.iso6392) !== -1){
					me._subList.push(
						me._subList.getObj().formSubDBSearch({
							movieName: movieName,
							hash: me._subdbHash,
							lang: lang,
							subdb: me._subdb
						})
					);
				}
			});
			dfd.resolve();
		}, 1);

		return dfd.promise;
	};

	SubtitleSearch.prototype._onOSLogin = function(token){
		__OSToken = token;
		return this._searchOS();
	};


	SubtitleSearch.prototype._searchOS = function(){
		var dfd = utils.defer();

		if(fs.existsSync(this._filePath)){
			opensubtitles.api
				.searchForFile(
					__OSToken,
					this._searchLanguages.join(','),
					this._filePath
				)
				.then(this._processOSResults.bind(this))
				.then(dfd.resolve)
			;
		} else {
			console.error('SubtitleSearch File doesn\'t exists', this._filePath);
			dfd.resolve([]);
		}

		return dfd.promise;
	};

	SubtitleSearch.prototype._processOSResults = function(results){
		var dfd = utils.defer(),
			me = this
		;

		setTimeout(function(){
			if(results.length > 0){
				results.forEach(function(item){
					me._subList.push(
						me._subList.getObj().formOSSearch(item)
					);
				});
			}
			dfd.resolve();
		}, 1);

		return dfd.promise;
	};

	return SubtitleSearch;
});