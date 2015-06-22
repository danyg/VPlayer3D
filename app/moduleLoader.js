/*
 *     (c) 2013-2014 Daniel Goberitz.
 *     Modules loader may be freely distributed under the MIT license.
 *     For all details and documentation:
 *     https://www.github.com/danyg/modulesLoader
 *
 * @license ModulesLoader 0.4.0 Copyright (c) 2013-2014 Daniel Goberitz
 * @author Daniel Goberitz <dalgo86@gmail.com>
 *
 * Available via the MIT license.
 */
(function(){
	'use strict';

	var require = requirejs;

	function parseName(name, glue){
		var tmp = name.split('/');
		if(tmp.length === 1){
			name = name + glue + name;
		}else if(tmp.length === 2){
			name = tmp[0] + glue + tmp[1];
		}else if(tmp.length > 2){
			throw new URIError('Ilegal module! or service! name \'' + name + '\'');
		}

		return name;
	}

	function parseModuleName(name){
		if(name.indexOf('modules/') === -1){
			// module!projects -> modules/projects/controllers/projects.js
			// module!projects/projectDetails -> modules/projects/controlers/projectDetails.js
			return 'modules/' + parseName(name, '/controllers/') + '.js';
		}else{
			return name;
		}
	}

	function isAbsolutePath(path) {
		return path.charAt(0) === '/';
	}

	function normalizeArray(parts, allowAboveRoot) {
		// if the path tries to go above the root, `up` ends up > 0
		var up = 0;
		for (var i = parts.length - 1; i >= 0; i--) {
			var last = parts[i];
			if (last === '.') {
				parts.splice(i, 1);
			} else if (last === '..') {
				parts.splice(i, 1);
				up++;
			} else if (up) {
				parts.splice(i, 1);
				up--;
			}
		}

		// if the path is allowed to go above the root, restore leading ..s
		if (allowAboveRoot) {
			for (; up--; up) {
				parts.unshift('..');
			}
		}

		return parts;
	}

	function normalizePath(path){
		var isAbsolute = isAbsolutePath(path),
			trailingSlash = path[path.length - 1] === '/',
			segments = path.split('/'),
			nonEmptySegments = [];

		// Normalize the path
		for (var i = 0; i < segments.length; i++) {
			if (segments[i]) {
				nonEmptySegments.push(segments[i]);
			}
		}
		path = normalizeArray(nonEmptySegments, !isAbsolute).join('/');

		if (!path && !isAbsolute) {
			path = '.';
		}
		if (path && trailingSlash) {
			path += '/';
		}

		path = path.replace(/\\/g, '/');

		return (isAbsolute ? '/' : '') + path;
	}

	require.modulePath = function(moduleWithSufix){
		if(moduleWithSufix.indexOf('module!') === 0){
			moduleWithSufix = moduleWithSufix.substring(7);
		}
		return parseModuleName(moduleWithSufix);
	};

	define('module', {
		parseName: parseModuleName,
		normalize: function(name, normalize){
			return normalizePath(normalize(name));
		},
		load: function (name, req, onload) {
			name = this.parseName(name, req);
			name = normalizePath(require.toUrl(name));
			require([name], function (value) {
				onload(value);
			});
		}
	});

	// kind --> insider Directory
	var InsiderKinds = {
		'model': 'models/',
		'view': 'views/',
		'template': 'templates/',
		'style': 'styles/',
		'helper': 'helpers/',
		'widget': 'widgets/'
	};

	function normalizeInsider(name, normalize, kind, ext){
		var currentPath = normalize('./'),
			root = currentPath.match(/(.*\/modules\/[^\/]*\/)/)
		;

		if(ext === undefined){
			ext = 'js';
		}

		ext = '.' + ext;

		if(root && root[1]){
			if(name.indexOf(root[1]) === -1){

				name = name + (kind.charAt(0).toUpperCase() + kind.substr(1));

				return root[1] + InsiderKinds[kind] + name + ext;
			}else{
				return name;
			}
		}else{
			throw new URIError(kind + '!' + name + ' unreachable from ' + normalize('./'));
		}
	}


	define('model', {
		normalize: function(name, normalize){
			return normalizeInsider(name, normalize, 'model');
		},
		load: function (name, req, onload) {
			req([req.toUrl(name)], function (value) {
				onload(value);
			});
		}
	});

	define('view', {
		normalize: function(name, normalize){
			return normalizeInsider(name, normalize, 'view');
		},
		load: function (name, req, onload) {
			req([req.toUrl(name)], function (value) {
				onload(value);
			});
		}
	});

	define('helper', {
		normalize: function(name, normalize){
			return normalizeInsider(name, normalize, 'helper');
		},
		load: function (name, req, onload) {
			req([req.toUrl(name)], function (value) {
				onload(value);
			});
		}
	});

	define('template', {
		normalize: function(name, normalize){
			return normalizeInsider(name, normalize, 'template', 'html');
		},
		load: function(name, req, onload){
			require(['text!' + name], function (value) {
				onload($(value));
			});
		}
	});

	define('style', {
		normalize: function(name, normalize){
			return normalizeInsider(name, normalize, 'style', 'css');
		},
		load: function(name, req, onload){
			require(['css!' + name], function (value) {
				onload(value);
			});
		}
	});

	define('widget', {
		parseName: function(name){
			if(name.indexOf('widgets/') === -1){
				var tmp = name.split('/'),
					moduleName = tmp[0],
					widgetName = tmp[1]
				;
				return 'modules/' + moduleName + '/widgets/' + widgetName + '/' + widgetName;
			}else{
				return name;
			}
		},
		normalize: function(name, normalize){
			return this.parseName(normalize(name));
		},
		load: function(name, req, onload){
			name = normalizePath(this.parseName(name));

			require([name], function (value) {
				onload(value);
			});
		}
	});

	define('service', {
		parseName: function(name){
			if(name.indexOf('services/') === -1){
				// service!keyboard -> services/keyboard/keyboard.js
				// service!db/driver.sqlite3 -> services/db/driver.sqlite3.js
				return 'services/' + parseName(name, '/') + 'Service.js';
			}else{
				return name;
			}
		},
		normalize: function(name, normalize){
			return normalize(this.parseName(name));
		},
		load: function (name, req, onload) {
			var toLoad;

			toLoad = req.toUrl(name);

			req([toLoad], function (value) {
				onload(value);
			});
		}
	});

	define('mixin', {
		parseName: function(name){
			if(name.indexOf('mixins/') === -1){
				// service!keyboard -> services/keyboard/keyboard.js
				// service!db/driver.sqlite3 -> services/db/driver.sqlite3.js
				return 'mixins/' + parseName(name, '/') + 'Mixin.js';
			}else{
				return name;
			}
		},
		normalize: function(name, normalize){
			return normalize(this.parseName(name));
		},
		load: function (name, req, onload) {
			var toLoad;

			toLoad = req.toUrl(name);

			req([toLoad], function (value) {
				onload(value);
			});
		}
	});




}());