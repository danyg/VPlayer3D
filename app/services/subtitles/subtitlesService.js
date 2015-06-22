/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/
define([
	'service!app',
	'service!utils',
	'./SubList.js',
	'./SubtitleSearch.js'
], function(
	app,
	utils,
	SubList,
	SubtitleSearch
){

	'use strict';

	var fs = require('fs'),
		path = require('path'),
		isUTF8 = require('is-utf8'),
		iconv = require('iconv-lite'),
		Subtitle = require('dgsubtitle')
	;

	function Subtitles(){
		app.on('mediaChanged', this._onNewMedia.bind(this));
		app.on('subtitleSelected', this._openSubtitle.bind(this));
		app.on('searchSubtitlesOnline', this._search.bind(this));
		this._currentMedia = null;
		this._languageSearch = ['spa', 'eng'];
	}

	/**
	 * [_onNewMedia description]
	 * @param  {[type]} data [description]
	 * @return {[type]}      [description]
	 *
	 * @fires QMLTo.subtitlesList
	 */
	Subtitles.prototype._onNewMedia = function(data){
		this._currentMedia = data;
		var filePath = utils.toPath(data.mrl),
			dirPath = path.dirname(filePath),
			list,
			me = this
		;
		this._currentMedia = data;
		this._currentMedia.filePath = filePath;

		this._subList = new SubList(this._languageSearch);

		list = this._getSubsFiles(dirPath);
		if(list.length > 0){
			list.forEach(function(subFile){
				me._subList.push(
					me._subList.getObj().formFS(subFile)
				);
			});
		} else {
			this._search();
		}

		this._triggerList();
	};

	Subtitles.prototype._triggerList = function(){
		if(this._subList.length > 0){


			app.trigger('subtitlesList', this._subList);
		}
	};
	/**
	 * @deprecated
	 */
	Subtitles.prototype._openSubtitle = function(id){
		var subObj = this._subList.getById(id);
		if(!!subObj){
			if(subObj.isDownloaded()){
				this._triggerSubtitle(subObj);
			} else {
				this._downloadAndLoadSubtitle(subObj);
			}
		} else {
			console.warn('Subtitles._openSubtitle subtitle ', id, ' Not Found');
		}
	};

	Subtitles.prototype._triggerSubtitle = function(subObj){
		var subs = this._loadSubtitle( subObj.getFilePath() );
		app.trigger('subtitle', {
			id: subObj.getId(),
			subtitles: subs
		});
	};

	Subtitles.prototype._loadSubtitle = function(filePath){
		filePath = utils.toPath(filePath);

		var subtitlesContent = fs.readFileSync(filePath);
		if(isUTF8(subtitlesContent)){
			subtitlesContent = subtitlesContent.toString();
		} else {
			subtitlesContent = iconv.decode(subtitlesContent, 'latin1');
		}

		var subParser = new Subtitle();
		subParser.parse(subtitlesContent);
		var subs = subParser.getSubtitles({
			duration: true,
			timeFormat: 'ms'
		});
		subs.sort(function(a, b){
			return (a.start - b.start);
		});

		return subs;
	};


	Subtitles.prototype._getSubsFiles = function(dirPath){
		// TODO to a Setting
		var search = [
			'',
			'/Subs',
			'/subs',
			'/Subtitles',
			'/subtitles'
		];
		var subsFiles = utils.getListOfFiles(dirPath, search)
			.filter(utils.filter.endWith('.srt'))
		;
		console.log('SUBTITLES Found:', subsFiles);

		return subsFiles;
	};

	Subtitles.prototype._downloadAndLoadSubtitle = function(subObj){
		var me = this;
		subObj.download(this._currentMedia.filePath)
			.then(function(){
				me._triggerSubtitle(subObj);
			})
		;
	};

	Subtitles.prototype._search = function(){
		if(this._currentMedia === null){
			return;
		}

		var mrl = this._currentMedia.mrl,
			filePath = utils.toPath(mrl),
			searchObj = new SubtitleSearch(filePath, this._languageSearch),
			me = this
		;

		app.trigger('searchingSubtitles');
		me._subList.cleanBySource('OpenSubtitles.org');

		searchObj.search()
			.then(function(results){
				if(results.length > 0){
					results.forEach(function(item){
						me._subList.push(
							me._subList.getObj().formOSSearch(item)
						);
					});

					app.trigger('subtitlesFound',results.length);
				} else {
					app.trigger('subtitlesNotFound');
				}

				me._triggerList();
			})
		;
	};

	return new Subtitles();

	/**
	 * @event QMLFrom.searchSubtitlesOnline
	 * @param {String} mrl playlist item mrl
	 */

	/**
	 * @event QMLFrom.mediaChanged
	 * @param {Object} item 		playlist item
	 * @param {String} item.mrl 	playlist item mrl (file path)
	 * @param {int} item.vidItem 	index in the playlist
	 */

	/**
	 * @event QMLTo.subtitlesList
	 * @param {HashMap} subtitlesList
	 * @param {String} subtitlesList.KEY 	subtitlesName
	 * @param {String} subtitlesList.VALUE 	subtitlesFilePath
	 */

	/**
	 * @event QMLTo.subtitle
	 * @param {Object} subtitlesData
	 * @param {int} subtitlesData.vidItem	Index in the playlist
	 * @param {int} subtitlesData.subTrack	key in the subtitlesList
	 * @param {Array<Track>} subtitlesData.subtitles	list of tracks
	 */

});