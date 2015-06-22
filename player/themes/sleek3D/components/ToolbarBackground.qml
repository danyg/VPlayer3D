import QtQuick 2.1
import QmlVlc 0.1

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'toolbarBackground'

	function getContainsMouse(){
		return (!!_bindedComponent ? _bindedComponent.bottomtab.containsMouse : false) || bottomtab.containsMouse;
	}

	property alias bottomtab: bottomtab
	width: parent.width
	height: parent.height
	anchors.verticalCenter: parent.verticalCenter
	VPlayer3DItems.BindedMouseArea {
		kind: 'toolbarBackground_mousearea'
		id: bottomtab
		hoverEnabled: true
		anchors.fill: parent
	}
}
