/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1
import QmlVlc 0.1

import "../VPlayer3D" as VPlayer3D

Rectangle {
	id: root

	property var componentType: 'AbstractItem';
	property alias kind: root._kind;
	property var _kind: '';
	property alias bindedComponent: root._bindedComponent;
	property var _bindedComponent;

	property var animTime: 300;

	property alias offset: root._offset
	property var _offset: 0

	function _bind() {

	}
	function bind(binded) {
		_bindedComponent = binded;
		_bind();
	}

	function set(propName, val){
		_set(propName, val);
		if(_bindedComponent){
			_bindedComponent._set(propName, val);
		} else {
			VPlayer3D.Core.error('bindedComponent ', componentType, ' without binded');
		}
	}

	function _set(propName, val){
		root[propName] = val;
	}

	function getComponentType(){
		return root.componentType;
	}

	function get(propName){
		return root[propName] || root._bindedComponent[propName];
	}

	Component.onCompleted: {
		var type = root.componentType +
			(root._kind !== '' ? '_' + root._kind : '')
		;
		root.componentType = type;
		VPlayer3D.Core.defineComponent(root.componentType, root);
	}



}