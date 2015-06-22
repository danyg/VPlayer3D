import QtQuick 2.1
import QmlVlc 0.1

import "../VPlayer3D" as VPlayer3D

Rectangle {
	// START BUTTON ACTIONS
	function clicked(action) {

		// send data back to On Page JavaScript for .onClicked
		fireQmlMessage("[clicked]"+action);
		// end send data back to On Page JavaScript for .onClicked

		if (action == "play" && typeof settings.preventClicked[action] === "undefined") {
			wjs.togPause();
		}
		else if (action == "prev" && typeof settings.preventClicked[action] === "undefined") {
			vlcPlayer.playlist.prev();
		}
		else if (action == "next" && typeof settings.preventClicked[action] === "undefined") {
			vlcPlayer.playlist.next();
		}
		else if (action == "mute" && typeof settings.preventClicked[action] === "undefined") {
			wjs.toggleMute();
		}
		else if (action == "subtitles" && typeof settings.preventClicked[action] === "undefined") {
			VPlayer3D.Core.getComponent('subtitlesWindow').toggle();
		}
		else if (action == "playlist" && typeof settings.preventClicked[action] === "undefined") {
			VPlayer3D.Core.getComponent('playlistWindow').toggle();
		}
		else if (action == "colorLevels" && typeof settings.preventClicked[action] === "undefined") {
			VPlayer3D.Core.getComponent('VideoColorLevelContainer').toggle();
		}
		else if (action == "fullscreen" && typeof settings.preventClicked[action] === "undefined") {
			if (settings.allowfullscreen == 1) {
				wjs.togFullscreen();
				if (settings.multiscreen == 1) wjs.toggleMute(); // Multiscreen - Edit
			}
		}
	}
	// END BUTTON ACTIONS
}