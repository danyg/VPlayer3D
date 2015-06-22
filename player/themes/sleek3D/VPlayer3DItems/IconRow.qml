/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1

import "../VPlayer3DItems" as VPlayer3DItems

Rectangle{
	color: "transparent";

	width: parent.width;
	height: 30;

	default property alias content: container.children

	property alias icon: icon.text;

	VPlayer3DItems.Background{}

	Text {
		id: icon;
		font.family: fonts.iconsFa.name;

		color: ui.colors.basefont;

		anchors.left: parent.left
		height: parent.height;
		width: parent.height;

		horizontalAlignment: Text.AlignHCenter;
		verticalAlignment: Text.AlignVCenter;

		font.weight: Font.Light;

		font.pointSize: 10;
	}

	Rectangle {
		id: container
		anchors.left: icon.right;
		anchors.right: parent.right;
		anchors.rightMargin: 5;

	}

}