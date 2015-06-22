import QtQuick 2.1

import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'window'

	property alias background: menuBackground

	visible: false
	anchors.centerIn: parent
	width: (parent.width * 0.9) < 694 ? (parent.width * 0.9) : 694
	height: 284
	color: "transparent"
	Rectangle {
		id: menuBackground
		anchors.fill: parent
	}
	MouseArea {
		hoverEnabled: true
		anchors.fill: parent
	}
}