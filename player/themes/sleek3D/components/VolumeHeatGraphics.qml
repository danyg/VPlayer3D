import QtQuick 2.1
import QmlVlc 0.1

import "./" as Loader
import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'volheat'

	property alias volColor: backgroundColors.volColor
	property alias volume: moveposa.width
	property alias backgroundColor: mainRect.color

	width: 120
	height: parent.height
	color: "transparent"

	function setVolume(vol){
		if(vol > 0){
			vol = (vol /200) * (root.width -4);
		}

		moveposa.width = vol;
		if(_bindedComponent)
			_bindedComponent.volume = vol;
	}

	function getContainsMouse(){
		return volumeMouse.getContainsMouse();
	}

	Loader.VolumeHeatMouse {
		id: volumeMouse

		onPressed: wjs.clickVolume(mouseX,mouseY)
		// onPressAndHold: wjs.clickVolume(mouseX,mouseY)
		onPositionChanged: wjs.hoverVolume(mouseX,mouseY)
		onReleased: wjs.releaseVolume(mouseX,mouseY)
	}

	Rectangle {
		id: mainRect
		width: 120
		height: 8
		anchors.verticalCenter: parent.verticalCenter
		Rectangle {
			id: moveposa
			clip: true
			width: 0
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.bottom: parent.bottom

			Loader.VolumeHeatColors { id: backgroundColors } // Draw Volume Heat Background Colors

		}
		Rectangle {
			id: movecura
			color: '#ffffff'
			width: 4
			height: 14
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: moveposa.width
		}

	}
}