/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/
define([
	'service!utils',
	'service!app'
], function(
	utils,
	app
){

	'use strict';

	var path = require('path'),
		fs = require('fs'),
		os = require('os'),
		opensubtitles = require('opensubtitles-client'),
		iso6392 = require('iso-639-2')
	;

	function SubObj(){
		this.id = utils.guid();

		this.movieName = '';
		this.languageName = '';
		this.subRating = '';

		this.languageId = '';
		this.season = '';
		this.episode = '';
		this.subFileName = '';

		this.source = '';

		this.downloaded = false;
		this.fsPath = '';

		this.rawData = [];
	}

	SubObj.prototype.formOSSearch = function(rawData){
		this.id = rawData.SubHash;
		this.movieName = rawData.MovieReleaseName;
		this.languageName = rawData.LanguageName;
		this.subRating = rawData.SubRating;

		this.languageId = rawData.SubLanguageID;
		this.season = rawData.SeriesSeason;
		this.episode = rawData.SeriesEpisode;
		this.subFileName = rawData.SubFileName;

		this.source = 'OpenSubtitles.org';

		this.rawData = rawData;
		return this;
	};

	SubObj.prototype.formFS = function(subFile){
		var s = 0,
			e = 0,
			lang = '???',
			langName = 'Unknown',
			fileName = path.basename(subFile),
			fileNameWoExt = path.basename(subFile, path.extname(subFile)),
			tmp
		;

		if((tmp = fileNameWoExt.match(/\-([\w]{3})/i)) !== null){
			lang = tmp[1].toLowerCase();
			tmp = iso6392.get(lang);
			if(tmp){
				langName = tmp.name;
			}
		}
		if((tmp = fileNameWoExt.match(/S([\d]{2,3})E([\d]{2,3})/i)) !== null){
			s = tmp[1];
			e = tmp[2];
		}

		this.fsPath = subFile;
		this.movieName = fileNameWoExt;
		this.languageName = langName;
		this.subRating = 'N/A';

		this.languageId = lang;
		this.season = s;
		this.episode = e;
		this.subFileName = fileName;

		this.source = 'FileSystem';

		this.downloaded = true;

		this.rawData = subFile;
		return this;
	};

	SubObj.prototype.getId = function(){
		return this.id;
	};
	SubObj.prototype.getLangId = function(){
		return this.languageId;
	};
	SubObj.prototype.getSource = function(){
		return this.source;
	};
	SubObj.prototype.isDownloaded = function(){
		return this.downloaded;
	};
	SubObj.prototype.getFilePath = function(){
		return this.fsPath;
	};

	SubObj.prototype.toJSON = function(){
		return {
			id: this.id,
			movieName: this.movieName,
			languageName: this.languageName,
			subRating: this.subRating,
			source: this.source
		};
	};

	SubObj.prototype.download = function(filePath){
		var dfd = utils.defer(),
			dirName = path.dirname(filePath),
			baseName = path.basename(filePath, path.extname(filePath)),
			subPath,
			baseDir = dirName + '/Subs/',
			me = this
		;

		if(!fs.existsSync(baseDir)){
			try{
				fs.mkdirSync(baseDir);
			}catch(e){
				baseDir = os.tmpdir() + '/VPlayer3D.Subs';
				fs.mkdirSync(baseDir);
			}
		}
		subPath = getSubPath(baseDir, baseName, this.languageId);

		if(this.downloaded){
			dfd.resolve(this.fsPath);
		} else {
			opensubtitles.downloader.once('downloading', function(data){
				app.trigger('downloadSubtitle');
			});
			opensubtitles.downloader.once('downloaded', function(data){
				console.log('DOWNLOADED', data);
				clearTimeout(watchDog);

				me.fsPath = data.file;
				me.downloaded = true;
				dfd.resolve(data.file);
			});

			var obj = JSON.parse(JSON.stringify(this.rawData));

			obj.SubFileName = this.id + '-' + this.languageId + '.' + obj.SubFormat;

			opensubtitles.downloader.download(
				[obj],
				1,
				subPath
			);
		}

		return dfd.promise;
	};

	function getSubPath(basePath, baseName, langId){
		var srtPathFile = basePath + baseName + '-' + langId + '.srt',
			ix = 1
		;
		while(fs.existsSync(srtPathFile)){
			srtPathFile = basePath + baseName + '-' + ix + '-' + langId + '.srt';
			ix++;
		}
		return srtPathFile;
	}

	return SubObj;
});