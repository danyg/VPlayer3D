import QtQuick 2.1
import QmlVlc 0.1

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedMouseArea {
	id: root

	hoverEnabled: true
	anchors.fill: parent
	focus: true

	propagateComposedEvents: true

}