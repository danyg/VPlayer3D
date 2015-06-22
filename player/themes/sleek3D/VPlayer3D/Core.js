/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

.pragma library

var sysTimer;
var started = false;
var appSettings;

var prevent_CLICK = 1;
var prevent_DOUBLECLICK = 2;
var prevent_PRESSEANDHOLD = 4;
var prevent_PRESSED = 8;
var prevent_RELEASED = 16;
var prevent_WHEEL = 32;

function init(timer) {
	sysTimer = timer;
}

function _init(SubSys, subSysName){
	if(typeof SubSys.init === 'function'){
		try{
			SubSys.init(this);
		} catch(e) {
			error('VPlayer3D.' + subSysName + '.init:', e.message, e.stack);
		}
	}
}

function initializeApp(){
	started = true;

	for(var i = 0; i < callbacks.length; i++){
		try{
			callbacks[i][0].call(callbacks[i][1]);
		} catch (e) {
			error('initializeApp Error: ', e.message, e.stack);
		}
	}
}

function isOn(val, flag){
	return (val | flag) === val;
}

var callbacks = [];

function onInit(cbk, ctx){
	callbacks.push([cbk,ctx || null]);
}


function tryToStart(){
	if(sysTimer && !started){
		sysTimer.restart();
	}
}

var components = {};

function defineComponent(type, component) {
	if(!components.hasOwnProperty(type)){
		components[type] = [];
	}

	if(components[type].length >= 2){
		error('VPlayer3D.Core.defineComponent cannot define more than 2 components for '+ type);
		trace();
		return;
		// throw Error('VPlayer3D.Core.defineComponent cannot define more than 2 components for '+ type);
	}

	components[type].push(component);

	if(components[type].length === 2) {
		if(!!components[type][0].bind){
			components[type][0].bind(components[type][1]);
		}
		if(!!components[type][1].bind){
			components[type][1].bind(components[type][0]);
		}
	}

	tryToStart();
}

function destroyComponent(type){
	if(components.hasOwnProperty(type)){
		try{
			delete components[type][0];
		}catch(e){}
		try{
			delete components[type][1];
		}catch(e){}

		delete components[type];
	}
}

function getComponent(type){
	if(components.hasOwnProperty(type)){
		return components[type][0];
	}

	return null;
}

/**
 * Returns a new #RRGGBB color given a base color and a precentage of luminance
 * @param  {[type]} hex [description]
 * @param  {[type]} lum [description]
 * @return {[type]}     [description]
 */
function color(hex, lum) {
	// validate hex string
	hex = String(hex).replace(/[^0-9a-f]/gi, '');
	if (hex.length < 6) {
		hex = hex[0]+hex[0]+hex[1]+hex[1]+hex[2]+hex[2];
	}
	lum = lum || 0;

	// convert to decimal and change luminosity
	var rgb = "#", c, i;
	for (i = 0; i < 3; i++) {
		c = parseInt(hex.substr(i*2,2), 16);
		c = Math.round(Math.min(Math.max(0, c + (c * lum)), 255)).toString(16);
		rgb += ("00"+c).substr(c.length);
	}

	return rgb;
}

var LOG_ALL = 0,
	LOG_DEBUG = 1,
	LOG_INFO = 2,
	LOG_WARN = 3,
	LOG_ERROR = 100,
	LOG_NONE = 65535
;

var LOG_LEVEL = LOG_ERROR;

function _getStack(){
	var error = new Error();
	var stack = error.stack.split('\n');
	stack.shift();
	stack.shift();
	for(var i = 0; i < stack.length; i++){
		stack[i] = decodeURI(stack[i]).replace('file://');
	}

	return stack;
}

function _processArgs(a, LVL){
	try{
		var args = Array.prototype.slice.call(a, 0);
		for(var i = 0; i < args.length; i++){
			if(typeof args[i] === 'object') {
				args[i] = '\n' + i + ': \n' + JSON.stringify(args[i], undefined, 4) + '\n';
			} else {
				args[i] = args[i];
			}
		}
		return LVL + ': ' + args.join(' ').replace(/\n/g, '\nqml: ' + LVL + ': ');
	} catch(e) {
		console.log('ERROR: ', e.message, e.stack);
	}
	return 'ERROR TRYING TO PROCESS DATA TO BE LOGGED';
}

function trace(){
	if(LOG_LEVEL > LOG_DEBUG){
		return true;
	}
	var stack = _getStack(),
		LVL = 'TRACE'
	;

	console.log(LVL + ': ' + stack.join('\n').replace(/\n/g, '\nqml: ' + LVL + ': ') );
}
function log(){
	if(LOG_LEVEL > LOG_DEBUG){
		return true;
	}
	var msg = _processArgs(arguments, 'DBG'),
		stack = _getStack()
	;

	console.log(msg, '	<' + stack[0].trim() + '>');
}

function info(){
	if(LOG_LEVEL > LOG_INFO){
		return true;
	}
	var msg = _processArgs(arguments, 'INFO'),
		stack = _getStack()
	;

	console.log(msg, '	<' + stack[0].trim() + '>');
}

function warn(){
	if(LOG_LEVEL > LOG_WARN){
		return true;
	}
	var msg = _processArgs(arguments, 'WARN'),
		stack = _getStack()
	;

	console.log(msg, '	<' + stack[0].trim() + '>');
}

function error(){
	if(LOG_LEVEL > LOG_ERROR){
		return true;
	}
	var msg = _processArgs(arguments, 'ERROR'),
		stack = _getStack()
	;

	console.log(msg, '	<' + stack[0].trim() + '>');
}