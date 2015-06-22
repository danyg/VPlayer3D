/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1
import "../../VPlayer3D" as VPlayer3D

Rectangle{
	id: root;
	anchors.left: parent.left;
	anchors.top: parent.top;
	width: parent.width;

	property var fontSize: 10;

	height: 30;
	color: "transparent";

	function _getBkColor(){
		return VPlayer3D.Core.color(ui.colors.base, .8);
	}

	function _getFgColor(){
		return VPlayer3D.Core.color(ui.colors.basefont, 1);
	}

	function _getOpacity(){
		return .9;
	}

	Row{
		anchors.fill: parent;
		spacing: 2;

		Rectangle {
			width: parent.width * .8;
			height: parent.height;
			color: _getBkColor();

			Text {
				anchors.fill: parent
				anchors.leftMargin: 10;

				verticalAlignment: Text.AlignVCenter;
				horizontalAlignment: Text.AlignLeft;
				font.pointSize: root.fontSize;
				color: _getFgColor();

				text: "File Name";
			}
		}

		Rectangle {
			width: parent.width * .2;
			height: parent.height;
			color: _getBkColor();

			Text {
				anchors.fill: parent
				anchors.leftMargin: 10;

				verticalAlignment: Text.AlignVCenter;
				horizontalAlignment: Text.AlignLeft;
				font.pointSize: root.fontSize;
				color: _getFgColor();

				text: "Duration";
			}
		}

	}
}