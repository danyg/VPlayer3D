import QtQuick 2.1
import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root;
	componentType: 'cursor';

	anchors.left: parent.left
	anchors.top: parent.top

	visible: settings.ismoving <= 5

	color: "transparent"

	width: 25
	height: 25

	z: 2000


	anchors.leftMargin: mouseData.mouseX + ((settings.subtitles3DOffset + 2) * _offset)
	anchors.topMargin: mouseData.mouseY

	Image {
		source: "../images/arrow.png"
		anchors.fill: parent
	}
}