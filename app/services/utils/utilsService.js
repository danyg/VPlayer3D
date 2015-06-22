/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/
define([], function(){
	'use strict';

	var path = require('path'),
		fs = require('fs'),
		os = require('os'),
		Q = require('q')
	;

	var utils = {
		/**
		 * Inherit the prototype methods from one constructor into another.
		 *
		 * The Function.prototype.inherits from lang.js rewritten as a standalone
		 * function (not on Function.prototype). NOTE: If this file is to be loaded
		 * during bootstrapping this function needs to be rewritten using some native
		 * functions as prototype setup using normal JavaScript does not work as
		 * expected during bootstrapping (see mirror.js in r114903).
		 *
		 * @param {function} ctor Constructor function which needs to inherit the
		 *		 prototype.
		 * @param {function} superCtor Constructor function to inherit prototype from.
		 */
		inherits: function(ctor, superCtor) {
			ctor.super_ = superCtor;
			ctor.prototype = Object.create(superCtor.prototype, {
				constructor: {
					value: ctor,
					enumerable: false,
					writable: true,
					configurable: true
				}
			});
		},

		behaveAsMixin: function(ctor){
			var methods = Object.keys(ctor.prototype),
				inheritedMixins = []
			;

			if(ctor.prototype.hasOwnProperty('_b')){
				inheritedMixins = Object.keys(ctor.prototype._b);
			}

			ctor.includeIn = function(target){
				target = !!target.prototype ? target.prototype : target;

				if(!target.hasOwnProperty('_constructMixins')){
					target._constructMixins = function(args){
						var mixins = Object.keys(this._b);
						for(var i = 0; i < mixins.length; i++){
							this._b[mixins[i]].apply(this, args);
						}
					};
				}

				if(!target.hasOwnProperty('_b')){
					target._b = {};
				}
				target._b[ctor.name] = ctor;

				inheritedMixins.every(function(ctorName){
					if(!target._b.hasOwnProperty(ctorName)){
						target._b[ctorName] = ctor.prototype._b[ctorName];
					}
					return true;
				});

				methods.every(function(methodName){

					if(!target.hasOwnProperty(methodName)){
						target[methodName] = ctor.prototype[methodName];
					}

					return true;
				});
			};
		},

		toPath: function(mrl){
			var trash = os.platform() === 'win32' ? 'file:///' : 'file://';

			var filePath = decodeURI(mrl).replace(trash, '');
			filePath = path.resolve(filePath);

			return filePath;
		},

		toUrl: function(path){
			var base = os.platform() === 'win32' ? 'file:///' : 'file://';
			return base + path.replace(/\\/g, '/')
		},

		getListOfFiles: function(dirPath, subDirs){
			var list = [],
				me = this
			;

			if(subDirs === true){
				throw new Error('IMPLEMENT ME!!!');
			} else if(!!subDirs.length){
				subDirs = os.platform() === 'win32' ? subDirs.map(this.map.lowerCase) : subDirs;

				subDirs = subDirs
					.filter(this.filter.unique)
					.map(this.map.replace(path.sep, '/'))
				;

				for(var i = 0, dir; i < subDirs.length; i++){
					dir = subDirs[i];
					if(fs.existsSync(dirPath+dir)){
						list.push.apply(list,
							fs.readdirSync(dirPath + dir)
								.map(
									me.map.prefix(dirPath + dir + path.sep)
								)
						);
					}
				}
			}

			return list;
		},

		map: {
			prefix: function(prefix){
				return function(item){
					return prefix + item;
				};
			},
			sufix: function(sufix){
				return function(item){
					return item + sufix;
				};
			},
			replace: function(needle, replacement){
				return function(i){
					return String.prototype.replace.call(i, needle, replacement);
				};
			},
			lowerCase: function(i){
				return String.prototype.toLowerCase.call(i);
			},
			upperCase: function(i){
				return String.prototype.toUpperCase.call(i);
			}
		},
		filter: {
			unique: function(e,i,a){
				return (a.indexOf(e) === i);
			},
			contains: function(pattern){
				return function(e){
					return e.indexOf(pattern) !== -1;
				};
			},
			startWith: function(pattern){
				return function(e){
					return e.indexOf(pattern) === 0;
				};
			},
			endWith: function(pattern){
				var le = pattern.length;
				return function(e){
					return e.lastIndexOf(pattern) === e.length - le;
				};
			},
		},
		sort: {
			ASC: function(a,b){
				return b < a;
			},
			DESC: function(a,b){
				return a < b;
			}
		},

		defer: function(){
			return Q.defer();
		},

		guid: function() {
			var d = new Date().getTime();
			return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
				var r = (d + Math.random() * 16) % 16 | 0;
				d = Math.floor(d/16);
				return (c == 'x' ? r : (r & 0x7 | 0x8)).toString(16);
			});
		}

	};

	return utils;
});