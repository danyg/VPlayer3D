/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1;
import QtQuick.Layouts 1.0;
import QmlVlc 0.1;

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'contextMenuItem'

	property alias text: innerText.text
	property alias hover: mouseArea
	property var dad: parent
	property var _subMenu

	property alias submenuId: root._submenuId;
	property var _submenuId: 'main';

	property alias director: root._director;
	property var _director;

	property var _isSelected;
	property var _click;

	property var _hoverEffect: false;

	anchors.left: parent.left
	width: parent.width

	color: "transparent"
	height: 30

	signal mouseEnter()
	signal mouseExit()

	function isSelected(){
		return !!root._isSelected ? root._isSelected() : false;
	}

	function setSelected(cbk){
		root._isSelected = cbk;
	}

	function click(){
		try{
			return !!root._click ? root._click() : false;
		} catch(e){
			VPlayer3D.Core.error(e.message, e.stack);
		}
	}

	function setClick(cbk){
		root._click = cbk;
	}

	function _mouseEnter(){
		root._director.subElementMouseIn(root._submenuId);
	}

	function _mouseExit(){
		root._director.subElementMouseOut(root._submenuId);
	}

	function getContainsMouse(){
		return _hoverEffect ? _hoverEffect : (!!_bindedComponent ? _bindedComponent.hover.containsMouse : false) || mouseArea.containsMouse;
	}

	function subMenuHover(id){
		if(id.indexOf(root._submenuId) === 0){
			root._hoverEffect = true;
		} else {
			root._hoverEffect = false;
		}
	}

	function setSubMenu(submenu){
		_subMenu = submenu;
		submenuArrow.visible = true;
	}

	VPlayer3DItems.BindedMouseArea {
		id: mouseArea
		kind: root._kind + '_mousearea'

		hoverEnabled: true
		anchors.fill: parent
		onPressed: {
			root.click();
			dad.clickItem(_kind);
			mouse.accepted = true;
		}
		onEntered: {root._mouseEnter()}
		onExited: {root._mouseExit()}
	}

	Rectangle {
		id: shape
		width: root.width
		height: root.height
		clip: true
		color: getContainsMouse() ? VPlayer3D.Core.color(ui.colors.base, .8) : "transparent"

		Text {
			id: selectedIcon
			visible: root.isSelected()
			anchors.left: parent.left
			anchors.leftMargin: 10
			anchors.verticalCenter: parent.verticalCenter

			text: settings.faFontLoaded ? ui.iconFa.selected : "x"
			font.family: fonts.iconsFa.name
			font.pointSize: 9
			color: getContainsMouse() ?
				VPlayer3D.Core.color(ui.colors.basefont, .4) :
				VPlayer3D.Core.color(ui.colors.basefont)
			;
		}

		Text {
			id: innerText
			anchors.left: selectedIcon.right
			anchors.leftMargin: 10
			anchors.verticalCenter: parent.verticalCenter
			text: ""
			font.pointSize: 9
			color: getContainsMouse() ?
				VPlayer3D.Core.color(ui.colors.basefont, .4) :
				VPlayer3D.Core.color(ui.colors.basefont)
			;
		}

		Text {
			id: submenuArrow
			visible: false
			anchors.right: parent.right
			anchors.rightMargin: 11
			anchors.top: parent.top
			anchors.topMargin: 10
			text: settings.glyphsLoaded ? ui.icon.play : ""
			font.family: fonts.icons.name
			font.pointSize: 9
			color: getContainsMouse() ?
				VPlayer3D.Core.color(ui.colors.basefont, .4) :
				VPlayer3D.Core.color(ui.colors.basefont)
			;
		}
	}

	Component.onCompleted: {
		_director.subMouseIn.connect(root.subMenuHover);
	}

	Component.onDestruction: {
		_director.subMouseIn.disconnect(root.subMenuHover);
		VPlayer3D.Core.destroyComponent('mouseArea_' + root._kind + '_mousearea');
	}
}