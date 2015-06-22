/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1

import "../VPlayer3D" as VPlayer3D
import "./" as VPlayer3DItems

Rectangle {
	id: root;
	color: "transparent"
	anchors.top: parent.top
	anchors.left: parent.left
	anchors.right: parent.right;

	property alias text: title.text;
	property var kind: 'defaultTitlebar';

	height: 30;

	signal closeClicked();

	Text{
		id: title;
		width: parent.width;
		height: 30;

		anchors.top: parent.top;
		anchors.left: parent.left;
		anchors.leftMargin: 10;
		font.bold: true;

		verticalAlignment: Text.AlignVCenter;
		horizontalAlignment: Text.AlignLeft;

		font.pointSize: 10;
		color: VPlayer3D.Core.color(ui.colors.basefont);
	}

	Rectangle{
		id: closeButton;
		width: 30;
		height: 30;
		color: mouseAreaButton.getContainsMouse() ?
			VPlayer3D.Core.color(ui.colors.base, .8) :
			"transparent"
		;

		anchors.top: parent.top;
		anchors.right: parent.right;

		Text {
			id: icon
			anchors.centerIn: parent
			font.family: fonts.iconsFa.name
			color: VPlayer3D.Core.color(ui.colors.basefont, 1);

			height: paintedHeight
			width: paintedWidth
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter

			font.pointSize: 8;
			font.weight: Font.Light

			text: ui.iconFa.close
		}
	}

	VPlayer3DItems.BindedMouseArea {
		id: mouseAreaButton
		kind: root.kind + '_mouseAreaCloseButton'

		anchors.fill: closeButton
		hoverEnabled: true
		onClicked: root.closeClicked()
		onPressed: root.closeClicked()
	}

}