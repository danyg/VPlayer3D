import QtQuick 2.1

import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'windowContent'

	anchors.centerIn: parent
	height: 272
	color: "transparent"
	clip: true
}