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

	var SOURCE_OS = 'OpenSubtitles.org',
		SOURCE_SUBDB = 'thesubdb.com',
		SOURCE_FS = 'FileSystem',
		SUBRATING_NA = 'N/A'
	;

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

		this.source = SOURCE_OS;

		this.rawData = rawData;
		return this;
	};

	SubObj.prototype.formSubDBSearch = function(rawData){
		var langObj = utils.iso6391to6392(rawData.lang);

		this.movieName = rawData.movieName;
		this.languageName = langObj.name;
		this.subRating = SUBRATING_NA;

		this.languageId = langObj.iso6392;
		this.subFileName = rawData.movieName + '-' + langObj.iso6392 + '.srt';

		this.source = SOURCE_SUBDB;

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
		this.subRating = SUBRATING_NA;

		this.languageId = lang;
		this.season = s;
		this.episode = e;
		this.subFileName = fileName;

		this.source = SOURCE_FS;

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
		if(this.source === SOURCE_OS){
			return this._downloadOS(filePath);
		} else if(this.source === SOURCE_SUBDB){
			return this._downloadSubDB(filePath);
		} else {
			var dfd = utils.defer();
			dfd.resolve();
			return dfd;
		}
	};

	SubObj.prototype._downloadOS = function(filePath){
		var dfd = utils.defer(),
			subPath,
			me = this
		;

		if(this.downloaded){
			dfd.resolve(this.fsPath);
		} else {

			subPath = this._getPathToDownload(filePath);

			opensubtitles.downloader.once('downloading', function(data){
				app.trigger('downloadSubtitle', data);
			});
			opensubtitles.downloader.once('downloaded', function(data){
				console.log('DOWNLOADED', data);

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

	SubObj.prototype._downloadSubDB = function(filePath){
		var dfd = utils.defer(),
			subPath,
			me = this
		;

		if(this.downloaded){
			dfd.resolve(this.fsPath);
		} else {

			subPath = this._getPathToDownload(filePath);

			this.rawData.subdb.api.download_subtitle(
				this.rawData.hash,
				this.rawData.lang,
				subPath,
				function(err, res){
					if(err){
						dfd.reject();
						console.error('Subtitle Not Downloaded', me.id, err);
						return;
					}

					console.log('DOWNLOADED', res);

					me.fsPath = subPath;
					me.downloaded = true;

					dfd.resolve(subPath);
				}
			);
		}

		return dfd.promise;
	};

	SubObj.prototype._getPathToDownload = function(filePath){
		var baseName = path.basename(filePath, path.extname(filePath)),
			dirName = path.dirname(filePath),
			baseDir = dirName + '/Subs/'
		;

		if(!fs.existsSync(baseDir)){
			try{
				fs.mkdirSync(baseDir);
			}catch(e){
				baseDir = os.tmpdir() + '/VPlayer3D.Subs';
				fs.mkdirSync(baseDir);
			}
		}


		return getSubPath(baseDir, baseName, this.languageId);
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