import QtQuick 2.1
import QmlVlc 0.1

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'titleBar'

	property alias fontColor: toptext.color
	property alias backgroundColor: topBarBackground.color
	property alias isVisible: topBarBackground.visible

	anchors.fill: parent
	color: "transparent"
	Rectangle {
		id: topBarBackground

		width: parent.width
		height: 34
		anchors.top: parent.top
		opacity: 0.7
		Behavior on opacity { PropertyAnimation { duration: 250} }
	}
	Rectangle {
		width: parent.width
		height: 34
		color: 'transparent'
		anchors.top: parent.top
		opacity: 1//settings.ismoving > 5 ? 0 : 1
		Behavior on opacity { PropertyAnimation { duration: 250} }
		Text {
			id: toptext
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left;
			anchors.leftMargin: 14
			text: "VPlayer3D"
			font.pointSize: 13
			font.family: fonts.defaultFont.name
		}
	}
}