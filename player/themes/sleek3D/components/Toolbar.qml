import QtQuick 2.1
import QmlVlc 0.1

import "./" as Loader
import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'toolbar'

	property alias toolbarBackground: toolbarBackground

	property alias myName: root._myName
	property var _myName: 'NoNAME'

	property var maxWidth: 800;

	width: parent.width - 200 > maxWidth ? maxWidth : parent.width - 200;
	anchors.left: parent.left
	anchors.leftMargin: ((parent.width - root.width)/2) + (settings.subtitles3DOffset * _offset);
	// anchors.horizontalCenter: parent.horizontalCenter
	anchors.bottom: parent.bottom

	anchors.bottomMargin: settings.toolbar != 0 ? settings.toolbarBottomMargin : -height
	color: 'transparent'
	visible: settings.uiVisible == 0 ? false : settings.multiscreen == 1 ? fullscreen ? true : false : true // Multiscreen - Edit

	opacity: settings.ismoving > 5 ? 0 : 1

	Behavior on anchors.bottomMargin {
		PropertyAnimation {
			duration: settings.multiscreen == 0 ? 250 : 0
		}
	}
	Behavior on opacity {
		PropertyAnimation { duration: 250 }
	}

	height: fullscreen ? 32 : 30

	Loader.ToolbarBackground {
		id: toolbarBackground
		color: VPlayer3D.Core.color(ui.colors.base)
		opacity: ui.settings.toolbar.opacity
	}

	// Start Left Side Buttons in Toolbar
	Loader.ToolbarLeft {

		// Start Playlist Previous Button
		Loader.ToolbarButton {
			id: prevBut
			kind: 'prevBut'

			fontFamily: fonts.iconsFa.name

			icon: settings.glyphsLoaded ? ui.iconFa.prev : ''
			iconSize: 10
			visible: vlcPlayer.playlist.itemCount > 1 ? true : false
			glow: ui.settings.buttonGlow

			onButtonClicked: buttons.clicked('prev');
		}

		Loader.ToolbarBorder {
			color: ui.colors.toolbar.border
			anchors.left: prevBut.right
			visible: prevBut.visible ? borderVisible : false
		}

		Loader.ToolbarButton {
			id: playButton
			kind: 'playButton'

			fontFamily: fonts.iconsFa.name

			icon: settings.glyphsLoaded ?
				vlcPlayer.playing ?
					ui.iconFa.pause :
						vlcPlayer.state != 6 ?
							ui.iconFa.play :
							ui.iconFa.replay
				: ''
			iconSize: 10
			anchors.left: prevBut.visible ? prevBut.right : parent.left
			anchors.leftMargin: prevBut.visible ? 1 : 0
			glow: ui.settings.buttonGlow

			onButtonClicked: buttons.clicked('play');
		}

		Loader.ToolbarBorder {
			color: ui.colors.toolbar.border
			anchors.left: playButton.right
			visible: borderVisible
		}
		Loader.ToolbarButton {
			id: nextBut
			kind: 'nextBut'

			fontFamily: fonts.iconsFa.name
			icon: settings.glyphsLoaded ? ui.iconFa.next : ''
			iconSize: 10
			anchors.left: playButton.right
			anchors.leftMargin: 1
			visible: vlcPlayer.playlist.itemCount > 1 ? true : false
			glow: ui.settings.buttonGlow

			onButtonClicked: buttons.clicked('next');
		}
		Loader.ToolbarBorder {
			visible: nextBut.visible ? borderVisible : false
			anchors.left: nextBut.right
			color: ui.colors.toolbar.border
		}
		// End Playlist Next Button
		// Start Volume Control
		Loader.VolumeHeat {
			id: vh

			anchors.left: nextBut.visible ? nextBut.right : playButton.right
			anchors.leftMargin: 1
		}
		// End Volume Control

		Loader.ToolbarBorder {
			id: volumeBorder
			anchors.left: vh.right
			anchors.leftMargin: 5
			color: ui.colors.toolbar.border
			visible: borderVisible
			Behavior on anchors.leftMargin { PropertyAnimation { duration: 250 } }
		}

		// Start 'Time / Length' Text in Toolbar
		Loader.ToolbarTimeLength {
			id: showtime
			anchors.left: volumeBorder.right
			anchors.leftMargin: 10
			text: wjs.getTime(vlcPlayer.time)
			color: ui.colors.toolbar.currentTime
		}
		Loader.ToolbarTimeLength {
			anchors.left: showtime.right
			anchors.leftMargin: 0
			text: settings.refreshTime ? wjs.getLengthTime() != '' ? ' / '+ wjs.getLengthTime() : '' : wjs.getLengthTime() != '' ? ' / '+ wjs.getLengthTime() : ''
			color: ui.colors.toolbar.lengthTime
		}
		// End 'Time / Length' Text in Toolbar
	}
	// End Left Side Buttons in Toolbar

	// Start Right Side Buttons in Toolbar
	Loader.ToolbarRight {
		// Start Open Subtitle Menu Button
		Row{
			anchors.fill: parent;
			layoutDirection: Qt.RightToLeft;

			Loader.ToolbarButton {
				id: fullscreenButton
				kind: 'fullscreenButton'

				icon: settings.glyphsLoaded ? fullscreen ? ui.icon.minimize : ui.icon.maximize : ''
				iconSize: 17

				glow: ui.settings.buttonGlow

				// iconElem.color: settings.allowfullscreen == 1 ? hover.containsMouse ? ui.colors.toolbar.buttonHover : ui.colors.toolbar.button : ui.colors.toolbar.buttonHover
				opacity: settings.allowfullscreen == 1 ? 1 : 0.2
				color: settings.allowfullscreen == 1 ? 'transparent' : '#000000'

				onButtonClicked: buttons.clicked('fullscreen');
			}
			Loader.ToolbarButton {
				id: playlistButton
				kind: 'playlistButton'

				icon: settings.glyphsLoaded ? ui.icon.playlist : '';
				iconSize: 17;
				visible: true;
				anchors.rightMargin: 1;
				glow: ui.settings.buttonGlow;

				onButtonClicked: buttons.clicked('playlist');
			}
			Loader.ToolbarButton {
				id: subButton
				kind: 'subButton'

				icon: settings.glyphsLoaded ? ui.icon.subtitles : ''
				iconSize: 15
				anchors.rightMargin: 1
				visible: false
				glow: ui.settings.buttonGlow

				onButtonClicked: buttons.clicked('subtitles');
			}
			Loader.ToolbarButton {
				id: vidColorButton
				kind: 'vidColorButton'

				fontFamily: fonts.iconsFa.name;
				icon: ui.iconFa.contrast;
				iconSize: 15
				anchors.rightMargin: 1

				visible: true

				onButtonClicked: buttons.clicked('colorLevels');
			}
		}
		// End Fullscreen Button
	}
	// End Right Side Buttons in Toolbar


	// End Time Bubble
	// Draw Progression Bar
	Loader.ProgressBar {
		id: progressBar
		backgroundColor: VPlayer3D.Core.color(ui.colors.base, .7)
		viewedColor: ui.colors.progress.viewed
		positionColor: ui.colors.progress.position
		cache.visible: vlcPlayer.state > 0 ? ui.settings.caching : false // fix for non-notify issue
		cache.color: VPlayer3D.Core.color(ui.colors.base, .4)

		anchors.bottom: parent.top
		anchors.left: parent.left

		onPressed: wjs.progressDrag(mouseX,mouseY);
		onChanged: wjs.progressChanged(mouseX,mouseY);
		onReleased: wjs.progressReleased(mouseX,mouseY);
	}
	// End Draw Progress Bar

	function _bind() {
		/*_bindedComponent.prevBut.bindedButton = root.prevBut;
		_bindedComponent.playButton.bindedButton = root.playButton;
		_bindedComponent.nextBut.bindedButton = root.nextBut;
		_bindedComponent.mutebut.bindedButton = root.mutebut;

		_bindedComponent.subButton.bindedButton = root.subButton;
		_bindedComponent.playlistButton.bindedButton = root.playlistButton;
		_bindedComponent.fullscreenButton.bindedButton = root.fullscreenButton;

		_bindedComponent.volumeMouse.bindedComponent = root.volumeMouse;
		_bindedComponent.volheat.bindedComponent = root.volheat;
		*/
	}
}