/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1
import QmlVlc 0.1

import "./" as Loader
import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'slider'

	property alias highlightColor: backgroundColors.color
	property alias backgroundColor: mainRect.color

	property var value: 0;

	property var _ownScale: root.width - movecura.width;
	property var minValue: 0;
	property var maxValue: 100;

	property var _outputScale: maxValue - minValue;
	property var _followMouse: false;
	property var _ignoreChange: false;
	property var _generatedHere: false;

	width: 120
	height: 30
	color: "transparent"

	signal changed(var value);

	Item{
		id: internal;
		property var value: 0;

		onValueChanged: {
			moveposa.width = (root._ownScale * value) / root._outputScale;
		}
	}


	function getContainsMouse(){
		return (!!_bindedComponent ? _bindedComponent.onlyContainsMouse() : false) || onlyContainsMouse();
	}

	function onlyContainsMouse(){
		return mouseAreaVl.containsMouse || mouseAreaVol.containsMouse;
	}

	function _onClick(mouse) {
	}
	function _onPressed(mouse) {
		root._followMouse = true;
		_changeValueMouse(mouse);
	}

	function _onReleased(mouse) {
		root._followMouse = false;
		_changeValueMouse(mouse);
	}

	function _onHover(mouse) {
		if(root._followMouse){
			_changeValueMouse(mouse);
		}
	}

	function _changeValueMouse(mouse) {
		var mX = mouse.x;
		if(mouse.x >= root._ownScale){
			mX = root._ownScale;
		}else if(mouse.x <= 0){
			mX = 0;
		}

		_changeValue(root.minValue + ((root._outputScale * mX) / root._ownScale))
	}

	function _changeValue(val) {
		root.value = val;
		_bindedComponent._setValue(internal.value);
		root.changed(value);
	}

	function _setValue(val){
		internal.value = val;
	}

	Rectangle {
		id: mainRect
		width: parent.width
		height: 8
		color: VPlayer3D.Core.color(ui.colors.base, .2);

		anchors.verticalCenter: parent.verticalCenter

		Rectangle {
			id: moveposa
			clip: true
			width: 0
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.bottom: parent.bottom

			Rectangle {
				id: backgroundColors
				height: parent.width
				width: parent.height
				anchors.centerIn: parent
				rotation: 90
				color: VPlayer3D.Core.color(ui.colors.base, .8);
			}

		}
		Rectangle {
			id: movecura
			color: '#ffffff'
			width: 4
			height: 14
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: moveposa.width
		}
	}

	VPlayer3DItems.BindedMouseArea {
		kind: root._kind + '_mouseArea'

		id: mouseAreaVol
		anchors.fill: parent
		anchors.left: parent.left

		onPressed: _onPressed(mouse);
		onPositionChanged: _onHover(mouse);
		onReleased: _onReleased(mouse);

		preventActions: VPlayer3D.Core.prevent_WHEEL;

		onWheel: {
			var step = root._outputScale/root._ownScale;

			var val = internal.value + (wheel.angleDelta.y > 0 ? step : step * -1);

			if(val < root.minValue){
				val = root.minValue;
			}else if(val > root.maxValue){
				val = root.maxValue;
			}
			_changeValue(val);
		}
	}

	onValueChanged: {
		VPlayer3D.Core.warn('VAL CHANGED', root.componentType, value);
		try{
			_setValue(root.value);
			_bindedComponent._setValue(root.value);
		} catch(e){
			VPlayer3D.Core.error('on Value Changed', e.message, e.stack)
		}
	}

	Component.onCompleted: {
		// app.on('initialize', function(){
		// 	// _changeValue(root.value);
		// 	app.connectTo(root.valueChanged, function(value){
		// 		// internal.value = root.value;
		// 	});
		// });
	}
}