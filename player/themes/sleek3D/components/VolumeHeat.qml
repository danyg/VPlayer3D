import QtQuick 2.1

import "./" as Loader
import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'volumeHeatContainer'

	clip: true
	height: parent.height
	width: getWidth()

	function getWidth(){

		return mutebut.width +
		(settings.firstvolume == 1 ?
			0 :
			vlcPlayer.state <= 1 && volumeBorder.anchors.leftMargin == 0 ?
				0 :
				mutebut.getContainsMouse() ?
				120 :
				volheat.getContainsMouse() ?
					120 :
					0
		);
	}

	anchors.verticalCenter: parent.verticalCenter
	// anchors.left: mutebut.right
	color: 'transparent'
	Behavior on width { PropertyAnimation { duration: vlcPlayer.state <= 1 && volumeBorder.anchors.leftMargin == 0 && width > 0 ? 0 : 250 } }

	// Start Mute Button
	Loader.ToolbarButton {
		id: mutebut
		kind: 'mutebut'

		icon: settings.glyphsLoaded ? vlcPlayer.state == 0 ? ui.icon.volume.medium : vlcPlayer.position == 0 && vlcPlayer.playlist.currentItem == 0 ? settings.automute == 0 ? ui.icon.volume.medium : ui.icon.mute : vlcPlayer.audio.mute ? ui.icon.mute : vlcPlayer.volume == 0 ? ui.icon.mute : vlcPlayer.volume <= 30 ? ui.icon.volume.low : vlcPlayer.volume > 30 && vlcPlayer.volume <= 134 ? ui.icon.volume.medium : ui.icon.volume.high : ''
		iconSize: fullscreen ? 17 : 16
		width: skinData.done === true ? ui.settings.toolbar.buttonMuteWidth : skinData.variables.settings.toolbar.buttonMuteWidth
		glow: ui.settings.buttonGlow

		onButtonClicked: buttons.clicked('mute');
		onButtonEntered: wjs.refreshMuteIcon();
		onButtonExited: wjs.refreshMuteIcon();

	}


	Loader.VolumeHeatGraphics {
		id: volheat

		anchors.left: mutebut.right

		backgroundColor: ui.colors.volumeHeat.background
		volColor: ui.colors.volumeHeat.color
	}

}
