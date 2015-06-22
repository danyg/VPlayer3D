/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/
define([
	'service!utils',
	'./SubObj.js'
], function(
	utils,
	SubObj
){

	'use strict';

	function SubList(orderPreference){
		this.subsByLangId = {};
		this.subById = {};
		this.subIxBySource = {};

		var pref = {};
		orderPreference.forEach(function(item, index){
			pref[item] = index;
		});
		this._orderPreference = pref;

		this.json = [];
	}

	utils.inherits(SubList, Array);

	SubList.prototype.getObj = function(){
		return new SubObj();
	};

	SubList.prototype.push = function(subObj){
		var ix;
		if(subObj instanceof SubObj){
			if(!this.subsByLangId.hasOwnProperty(subObj.getLangId())){
				this.subsByLangId[subObj.getLangId()] = [];
			}
			if(!this.subIxBySource.hasOwnProperty(subObj.getSource())){
				this.subIxBySource[subObj.getSource()] = [];
			}
			this.subsByLangId[subObj.getLangId()].push(subObj);
			this.subById[subObj.getId()] = subObj;

			ix = Array.prototype.push.call(this, subObj) - 1 ;
			this.json.push(subObj);

			this.subIxBySource[subObj.getSource()].push(ix);
		} else {
			throw new TypeError('Error trying to push a non SubObj in a SubList');
		}
	};

	/**
	 * @param  {String} id
	 * @return {SubObj}
	 */
	SubList.prototype.getById = function(id){
		if(this.subById.hasOwnProperty(id)){
			return this.subById[id];
		}
		return false;
	};

	/**
	 * @param  {String} langId
	 * @return {Array.<SubObj>}
	 */
	SubList.prototype.getByLangId = function(langId){
		if(this.subsByLangId.hasOwnProperty(langId)){
			return this.subsByLangId[langId];
		}
		return [];
	};

	SubList.prototype.cleanBySource = function(source){
		if(this.subIxBySource.hasOwnProperty(source)){
			var list = this.subIxBySource[source].sort(utils.sort.DESC),
				i, j
			;
			for(i=0; i < list.length; i++){
				j = list[i];
				this.splice(j,1);
			}
			this.subIxBySource[source] = [];
		}

		return false;
	};

	SubList.prototype.getDownloaded = function(){
		return this.filter(function(item){
			return item.isDownloaded();
		});
	};

	SubList.prototype.toJSON = function(){
		var me = this;

		return this.json.sort(function(a,b) {
			if(a.languageId === b.languageId){
				return parseFloat(a.subRating) < parseFloat(b.subRating);
			} else {
				var iA = me._orderPreference[a.languageId];
				var iB = me._orderPreference[b.languageId];
				return iB < iA;
			}
		});
	};

	return SubList;
});