/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1
import "../../VPlayer3D" as VPlayer3D
import "../../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root;
	width: parent.width;
	componentType: 'playlistRow'

	property var fontSize: 10;

	property var modelData;

	height: 30;
	color: "transparent";

	function _getBkColor(){
		return root.modelData.isSelected() ?
			VPlayer3D.Core.color(ui.colors.base, .8) :
			"transparent"
		;
	}

	function _getFgColor(){
		return root.modelData.isSelected() ?
			VPlayer3D.Core.color(ui.colors.basefont, 1) :
			VPlayer3D.Core.color(ui.colors.basefont, -.4)
		;
	}

	function _getOpacity(){
		return root.modelData.isSelected() ? .9 : .7;
	}

	function getRating(rating){
		//TODO
		var n = parseFloat(rating);

	}

	Row{
		anchors.fill: parent;
		spacing: 2;

		Rectangle {
			width: parent.width * .8;
			height: parent.height;
			color: _getBkColor();
			clip: true;

			Text {
				anchors.fill: parent
				anchors.leftMargin: 10;

				verticalAlignment: Text.AlignVCenter;
				horizontalAlignment: Text.AlignLeft;
				font.pointSize: root.fontSize;
				color: _getFgColor();

				text: root.modelData.filename;
			}
		}

		Rectangle {
			width: parent.width * .2;
			height: parent.height;
			color: _getBkColor();
			clip: true;

			Text {
				anchors.fill: parent
				anchors.leftMargin: 10;

				verticalAlignment: Text.AlignVCenter;
				horizontalAlignment: Text.AlignLeft;
				font.pointSize: root.fontSize;
				color: _getFgColor();

				text: root.modelData.duration;
			}
		}

	}

	VPlayer3DItems.BindedMouseArea {
		id: mouseAreaButton
		kind: root._kind + '_mouseArea';
		preventActions: VPlayer3D.Core.prevent_WHEEL;

		anchors.fill: parent
		hoverEnabled: true;

		onClicked: {
			root.modelData.toggleSelect();
			VPlayer3D.Core.log('---> ROW CLICK', root.kind);
		}
		// onPressed: {
		// 	root.modelData.toggleSelect();
		// 	VPlayer3D.Core.log('---> ROW Pressed', root.kind);
		// }
	}

	Component.onDestruction: {
		VPlayer3D.Core.log('Destroying Component', root.componentType);
		VPlayer3D.Core.destroyComponent(root.componentType);
		VPlayer3D.Core.destroyComponent(mouseAreaButton.componentType);
	}
}