import QtQuick 2.1

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'volumeMouse'

	property alias dragger: mouseAreaVl
	property alias hover: mouseAreaVol
	signal pressed(string mouseX, string mouseY)
	signal pressAndHold(string mouseX, string mouseY)
	signal positionChanged(string mouseX, string mouseY)
	signal released(string mouseX, string mouseY)

	signal mouseEntered
	signal mouseExited

	function getContainsMouse(){
		return (!!_bindedComponent ? _bindedComponent.onlyContainsMouse() : false) || onlyContainsMouse();
	}

	function onlyContainsMouse(){
		return mouseAreaVl.containsMouse || mouseAreaVol.containsMouse;
	}

	anchors.fill: parent
	color: "transparent"

	// Mouse Area for Dragging
	VPlayer3DItems.BindedMouseArea {
		kind: 'volumeMouse_mouseAreaV1'
		id: mouseAreaVl
		anchors.fill: parent
		anchors.left: parent.left
		hoverEnabled: true
	}
	// End Mouse Area for Dragging
	VPlayer3DItems.BindedMouseArea {
		kind: 'volumeMouse_mouseAreaVol'

		id: mouseAreaVol
		anchors.fill: parent
		anchors.left: parent.left
		onPressed: root.pressed(mouse.x,mouse.y);
		onPressAndHold: root.pressAndHold(mouse.x,mouse.y);
		onPositionChanged: root.positionChanged(mouse.x,mouse.y);
		onReleased: root.released(mouse.x,mouse.y);

		onEntered: root.mouseEntered()
		onExited: root.mouseExited()
	}
}