/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1
import QmlVlc 0.1
import QtGraphicalEffects 1.0

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root;
	componentType: 'Button';

	property alias icon: icon.text;
	property alias iconFamily: icon.font.family;
	property alias iconSize: icon.font.pointSize;

	property alias text: buttonText.text;
	property alias fontFamily: buttonText.font.family;
	property alias fontSize: buttonText.font.pointSize;

	property alias hover: mouseAreaButton;

	signal buttonClicked;
	signal buttonEntered;
	signal buttonExited;

	function getContainsMouse(){
		return (!!_bindedComponent ? _bindedComponent.hover.containsMouse : false) || mouseAreaButton.containsMouse;
	}

	function isVisible() {
		return root.visible;
	}

	function setVisible(status){
		set('visible', status);
	}

	height: parent.height
	width: 125;
	clip: false;
	color: getContainsMouse() ?
		VPlayer3D.Core.color(ui.colors.base, .8) :
		VPlayer3D.Core.color(ui.colors.base, -.1)
	;
	opacity: getContainsMouse() ?
		1 :
		.7
	;

	anchors.fill: buttonRow

	Row{
		id: buttonRow
		anchors.fill: parent;

		// spacing: 8

		Text {
			id: icon;

			font.family: fonts.iconsFa.name;

			color: getContainsMouse() ?
				VPlayer3D.Core.color(ui.colors.basefont, .8) :
				VPlayer3D.Core.color(ui.colors.basefont)
			;

			height: root.height;
			width: root.height;

			horizontalAlignment: Text.AlignHCenter;
			verticalAlignment: Text.AlignVCenter;

			font.weight: Font.Light;

			font.pointSize: 10;
		}

		Text{
			id: buttonText;

			color: getContainsMouse() ?
				VPlayer3D.Core.color(ui.colors.basefont, .8) :
				VPlayer3D.Core.color(ui.colors.basefont)
			;

			font.family: fonts.defaultFont.name;

			width: paintedWidth;
			height: root.height;

			verticalAlignment: Text.AlignVCenter;
			font.weight: Font.Light;

			font.pointSize: 10;
		}

	}

	VPlayer3DItems.BindedMouseArea {
		id: mouseAreaButton
		kind: root._kind + '_mouseAreaButton'

		anchors.fill: parent
		hoverEnabled: true
		onClicked: root.buttonClicked()
		// onPressed: root.buttonClicked()
		onEntered: root.buttonEntered()
		onExited: root.buttonExited()
	}
}