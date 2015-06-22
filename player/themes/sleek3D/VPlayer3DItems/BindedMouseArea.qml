/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1

import "../VPlayer3D" as VPlayer3D

MouseArea {
	id: root;

	cursorShape: root.debug ? Qt.CrossCursor : Qt.BlankCursor

	hoverEnabled: true;
	anchors.fill: parent;

	property var preventActions: 0;

	// property var debug: true;
	property var debug: false;

	// Hack because is impossible to connect to pressed property since there is
	// a duplication of this property with a boolean!
	signal clickEvent(var mouse);
	signal doubleClickEvent(var mouse);
	signal positionChangeEvent(var mouse);
	signal pressAndHoldEvent(var mouse);
	signal releaseEvent(var mouse);
	signal pressEvent(var mouse);
	signal wheelEvent(var mouse);

	Rectangle {
		visible: root.debug;

		color: '#90ee90';
		opacity: .2;
		anchors.fill: parent
	}

	// focus: true
	acceptedButtons: Qt.LeftButton| Qt.MiddleButton | Qt.RightButton

	property var componentType: 'mouseArea'
	property alias kind: root._kind
	property var _kind: ''

	function getContainsMouse(){
		return (!!_bindedComponent ? _bindedComponent.containsMouse : false) || root.containsMouse;
	}

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
			VPlayer3D.Core.error('BindedMouseArea', componentType, ' without binded');
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

	function dbg(eventName, e){
		if(root.debug){
			VPlayer3D.Core.log('BindedMouseArea ' + eventName, root.componentType, '<' + e.x +'x'+ e.y + '>');
		}
	}

	// onPressed: _getListener('pressed', 'pressEvent'); //qtbug

	onClicked: {
		_calculateXY(mouse);
		root.dbg('onClicked', mouse);
		mouse.mouseY = mouse.y;
		mouse.mouseX = mouse.x;
		mouse.accepted = !VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_CLICK);
		if(mouse.accepted){
			root.clickEvent(mouse);
			mouseData._clicked(mouse);
		}
	}
	onDoubleClicked: {
		_calculateXY(mouse);
		root.dbg('onDoubleClicked', mouse);
		mouse.mouseY = mouse.y;
		mouse.mouseX = mouse.x;
		mouse.accepted = !VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_DOUBLECLICK);
		if(mouse.accepted){
			root.doubleClickEvent(mouse);
			mouseData._doubleClicked(mouse);
		}
	}
	onPositionChanged: {
		_calculateXY(mouse);
		// root.dbg('onPositionChanged', mouse);
		mouseData._changePrevents(root.preventActions);
		mouse.mouseY = mouse.y;
		mouse.mouseX = mouse.x;
		mouse.accepted = true;
		root.positionChangeEvent(mouse);
	}
	onPressAndHold: {
		_calculateXY(mouse);
		root.dbg('onPressAndHold', mouse);
		mouse.mouseY = mouse.y;
		mouse.mouseX = mouse.x;
		mouse.accepted = !VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_PRESSEANDHOLD);
		if(mouse.accepted){
			root.pressAndHoldEvent(mouse);
			mouseData.pressAndHold(mouse);
		}
	}
	onPressed: {
		_calculateXY(mouse);
		root.dbg('onPressed', mouse);
		mouse.mouseY = mouse.y;
		mouse.mouseX = mouse.x;
		mouse.accepted = !VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_PRESSED);
		if(mouse.accepted){
			root.pressEvent(mouse);
			mouseData._pressed(mouse);
		}
	}
	onReleased: {
		_calculateXY(mouse);
		root.dbg('onReleased', mouse);
		mouse.mouseY = mouse.y;
		mouse.mouseX = mouse.x;
		mouse.accepted = !VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_RELEASED);
		if(mouse.accepted){
			root.releaseEvent(mouse);
			mouseData._released(mouse);
		}
	}
	onWheel: {
		// root.dbg('onWheel', mouse);
		wheel.mouseY = wheel.y;
		wheel.mouseX = wheel.x;
		wheel.accepted = !VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_WHEEL);
		if(wheel.accepted){
			root.wheelEvent(wheel);
			mouseData._wheel(wheel);
		}
	}

	function _calculateXY(e){
		try{
			// var ocord = lefteye.mapToItem(root, root.x, root.y);
			var ocord = lefteye.mapFromItem(root, root.x, root.y);

			var parent = root.parent;
			var ocord = {x: root.x, y: root.y};
			var eyeParent = lefteye;

			while(parent){
				if(parent.parent === theview){
					break;
				}
				ocord.x += parent.x;
				ocord.y += parent.y;

				parent = parent.parent;
			}

			mouseData.mouseX = e.x + ocord.x;
			mouseData.mouseY = e.y + ocord.y;
// VPlayer3D.Core.log(
// 	'mouseX:', e.x,
// 	'mouseY:', e.x,
// 	'ocord.x:', ocord.x,
// 	'ocord.y:', ocord.y,
// 	'X:', mouseData.mouseX,
// 	'Y:', mouseData.mouseY
// );
			mouseData._positionChanged(root);
		}catch(e){
			VPlayer3D.Core.error('Calculating X,Y', e.message, e.stack);
		}
	}

	Component.onCompleted: {
		var type = root.componentType +
			(root._kind !== '' ? '_' + root._kind : '')
		;
		root.componentType = type;
		VPlayer3D.Core.defineComponent(root.componentType, root);

		root.entered.connect(function(){
			settings.ismoving = 1;
			mouseData._entered(root);
		});

		root.exited.connect(function(){
			settings.ismoving = 5;
			mouseData._exited(root);
		});

	}
}
