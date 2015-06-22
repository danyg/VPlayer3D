/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1
import QmlVlc 0.1

import "./" as LoadSettings
import "core" as JsLogic
import "components" as Loader
import "./VPlayer3D" as VPlayer3D
import "./VPlayer3DItems" as VPlayer3DItems

Rectangle {

	// load core javascript functions and settings
	property variant ui: {}
	LoadSettings.UIsettings { id: skinData }
	JsLogic.Settings { id: settings }
	JsLogic.Functions { id: wjs }
	JsLogic.Hotkeys { id: hotkeys }
	JsLogic.Buttons { id: buttons }
	VPlayer3D.App { id: app }

	// end load core javascript functions and settings

	property var borderVisible: skinData.variables.settings.toolbar.borderVisible;
	property var buttonWidth: skinData.variables.settings.toolbar.buttonWidth;
	property var timeMargin: skinData.variables.settings.toolbar.timeMargin;

	id: theview;

	color: ui.colors.videoBackground; // Set Video Background Color
	VPlayer3DItems.MouseData {
		id: mouseData
		onWheel: hotkeys.mouseScroll(wheel.angleDelta.x,wheel.angleDelta.y);
	}

	Loader.VideoLayer { id: videoSource } // Load Video Layer

	Loader.Fonts {
		id: fonts
		icons.source: ui.settings.iconFont
		iconsFa.source: ui.settings.faIconFont
		defaultFont.source: ui.settings.defaultFont
		secondaryFont.source: ui.settings.secondaryFont
	}

	VPlayer3DItems.Eye {
		id: lefteye
		eye: VPlayer3D.Settings3D.c_LEFT_EYE
		offset: 1
	}

	VPlayer3DItems.Eye {
		id: righteye
		eye: VPlayer3D.Settings3D.c_RIGHT_EYE
		offset: -1
	}

	Timer {
		id: sysTimer
		interval: 200; running: false; repeat: false
		onTriggered: {
			VPlayer3D.Settings3D.init();
			app.init();
			// VPlayer3D.Subtitles.init();
			// WARNING DON'T REMOVE THE initializeApp the timer will be executed again
			VPlayer3D.Core.initializeApp(); // DON'T EVER REMOVE THIS
		}
	}

	Component.onCompleted: {
		VPlayer3D.Core.init(sysTimer);
		app.qmlLoaded();
	}

}
