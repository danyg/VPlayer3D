/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1
import QmlVlc 0.1

// Define LeftEyeContainer

import "../components" as Loader
import "../VPlayer3D" as VPlayer3D
import "../ContextMenu" as ContextMenu
import "../SubtitlesWindow" as SubtitlesWindow
import "../PlaylistWindow" as PlaylistWindow
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'eye'
	clip: true;

	property alias eye: root._eye
	property var _eye
	property var _myName: (_eye === VPlayer3D.Settings3D.c_LEFT_EYE ? "Left" : "Right")

	visible: _visible()

	width: parent.width
	height: parent.height

	transform: Scale {
		xScale: (VPlayer3D.Settings3D.getMode() == VPlayer3D.Settings3D.c_MODE_HSBS ? 0.5 : 1);
		yScale: (VPlayer3D.Settings3D.getMode() == VPlayer3D.Settings3D.c_MODE_HALFOU ? 0.5 : 1)
	}

	anchors.top: _getTop()
	anchors.left: _getLeft()

	color: "transparent"

	function _getTop(){
		if (_eye === VPlayer3D.Settings3D.c_LEFT_EYE){
			return parent.top;
		} else {
			return VPlayer3D.Settings3D.getMode() == VPlayer3D.Settings3D.c_MODE_HALFOU ?
				parent.verticalCenter : parent.top
			;
		}
	}

	function _getLeft(){
		if (_eye === VPlayer3D.Settings3D.c_LEFT_EYE){
			return parent.left;
		} else {
			return VPlayer3D.Settings3D.getMode() == VPlayer3D.Settings3D.c_MODE_HSBS ?
				parent.horizontalCenter : parent.left
			;
		}
	}

	function _visible(){
		if (_eye === VPlayer3D.Settings3D.c_LEFT_EYE){
			return true;
		} else {
			return VPlayer3D.Settings3D.getMode() != VPlayer3D.Settings3D.c_MODE_2D;
		}
	}



	property alias subs: subtitletext
	property alias toolbar: toolbar

	Loader.SubtitleText {
		id: subtitletext
		fontColor: ui.colors.subtitles
		fontShadow: ui.colors.subtitlesShadow
		offset: root._offset
	}

	Loader.ArtworkLayer { id: artwork } // Load Artwork Layer (if set with .addPlaylist)

	Loader.TopCenterText {
		id: buftext
		fontColor: ui.colors.font
		fontShadow: ui.colors.fontShadow
	}

	Loader.BigPauseIcon {
		id: pausetog

		color: ui.colors.bigIconBackground
		icon: ui.icon.bigPause
		iconColor: ui.colors.bigIcon

		offset: root._offset
	}

	Loader.SplashScreen {
		id: splashScreen

		color: ui.colors.videoBackground
		fontColor: ui.colors.font
		fontShadow: ui.colors.fontShadow

		eye: root._eye
		offset: root._offset
	}

	Loader.TopRightText {
		id: volumebox
		fontColor: ui.colors.font
		fontShadow: ui.colors.fontShadow
	}

	Loader.MouseSurface {
		id: mousesurface
		kind: 'mousesurface'

		onWidthChanged: wjs.onSizeChanged();
		onHeightChanged: wjs.onSizeChanged();

		onPressed:hotkeys.mouseClick(mouse.button);
		onReleased: hotkeys.mouseRelease(mouse.button);
		onDoubleClicked: hotkeys.mouseDblClick(mouse.button);
		onPositionChanged: hotkeys.mouseMoved(mouse.x,mouse.y);

		Keys.onPressed: hotkeys.keys(event);
	}
	// Loader.DigitalZoom { id: digiZoom } // Digital Zoom Feature

	// Loader.PIP { id: pip } // Picture in Picture Feature
	Loader.Toolbar {
		id: toolbar
		myName: root._myName

		offset: root._offset

	}

	// Start Playlist Menu
	Loader.Menu {
		id: playlistblock
		background.color: ui.colors.playlistMenu.background

		// Start Playlist Menu Scroll
		Loader.MenuScroll {
			id: playlistScroll
			draggerColor: ui.colors.playlistMenu.drag
			backgroundColor: ui.colors.playlistMenu.scroller
			onDrag: wjs.movePlaylist(mouseY)
			dragger.height: (playlist.totalPlay * 40) < 240 ? 240 : (240 / (playlist.totalPlay * 40)) * 240
		}
		// End Playlist Menu Scroll

		Loader.MenuContent {
			width: playlistblock.width < 694 ? (playlistblock.width -12) : 682

			Loader.PlaylistMenuItems { id: playlist } // Playlist Items Holder (This is where the Playlist Items will be loaded)

			// Top Holder (Title + Close Button)
			Loader.MenuHeader {
				text: "Playlist Menu"
				textColor: ui.colors.playlistMenu.headerFont
				backgroundColor: ui.colors.playlistMenu.header

				// Start Close Playlist Button
				Loader.MenuClose {
					id: playlistClose
					icon: settings.glyphsLoaded ? ui.icon.closePlaylist : ""
					iconSize: 9
					iconColor: playlistClose.hover.containsMouse ? ui.colors.playlistMenu.closeHover : ui.colors.playlistMenu.close
					color: playlistClose.hover.containsMouse ? ui.colors.playlistMenu.closeBackgroundHover : ui.colors.playlistMenu.closeBackground
					hover.onClicked: { playlistblock.visible = false; }
				}
				// End Close Playlist Button
			}
			// End Top Holder (Title + Close Button)

		}
	}
	// End Playlist Menu

	// Start Replace MRL Text Box (for debug playlist feature)
	Loader.ReplaceMRL {
		color: "#111111"
		id: inputBox
	}
	// End Replace MRL Text Box (for debug playlist feature)

	// Start Add MRL Text Box (for debug playlist feature)
	Loader.AddMRL {
		color: "#111111"
		id: inputAddBox
	}
	// End Add MRL Text Box (for debug playlist feature)


	// Start Subtitle Menu
	Loader.Menu {
		id: subMenublock
		kind: 'submenu'
		background.color: ui.colors.playlistMenu.background

		// Start Subtitle Menu Scroll
		Loader.MenuScroll {
			id: subMenuScroll
			kind: 'submenu'

			draggerColor: ui.colors.playlistMenu.drag
			backgroundColor: ui.colors.playlistMenu.scroller
			onDrag: wjs.moveSubMenu(mouseY)
			dragger.height: (settings.totalSubs * 40) < 240 ? 240 : (240 / (settings.totalSubs * 40)) * 240
		}
		// End Subtitle Menu Scroll

		Loader.MenuContent {
			kind: 'submenu'
			width: subMenublock.width < 694 ? (subMenublock.width -12) : 682

			Loader.SubtitleMenuItems { id: subMenu } // Subtitle Items Holder (This is where the Playlist Items will be loaded)

			// Top Holder (Title + Close Button)
			Loader.MenuHeader {
				text: "Subtitle Menu"
				textColor: ui.colors.playlistMenu.headerFont
				backgroundColor: ui.colors.playlistMenu.header

				// Start Close Subtitle Menu Button
				Loader.MenuClose {
					id: subMenuClose
					icon: settings.glyphsLoaded ? ui.icon.closePlaylist : ""
					iconSize: 9
					iconColor: subMenuClose.hover.containsMouse ? ui.colors.playlistMenu.closeHover : ui.colors.playlistMenu.close
					color: subMenuClose.hover.containsMouse ? ui.colors.playlistMenu.closeBackgroundHover : ui.colors.playlistMenu.closeBackground
					hover.onClicked: { subMenublock.visible = false; }
				}
				// End Close Subtitle Menu Button
			}
			// End Top Holder (Title + Close Button)

		}
	}
	// End Subtitle Menu

	VPlayer3DItems.VideoColorLevels{
		offset: root._offset;
	}

	SubtitlesWindow.SubtitlesWindow {
		offset: root._offset;
		visible: false;
	}

	PlaylistWindow.PlaylistWindow {
		offset: root._offset;
		visible: false;
	}

	// Start Context Menu
	ContextMenu.ContextMenu {
	// Loader.ContextMenu {
		id: contextblock

		offset: root._offset
	}
	// End Context Menu

	Loader.Cursor{
		offset: root._offset
	}


	// End Mouse Area over entire Surface (check mouse movement, toggle pause when clicked) [includes Toolbar]
}