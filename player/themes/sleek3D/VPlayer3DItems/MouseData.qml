/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1

import "../VPlayer3D" as VPlayer3D

Item {
	id: root;

	property var mouseX: 0;
	property var mouseY: 0;
	property var containsMouse: false;
	property var showCursor: false;

	property var _exitedSent: true;
	property var _exitedLayer;

	property var preventActions;


	signal entered()
	signal exited()

	signal clicked(variant mouse);
	signal doubleClicked(variant mouse);
	signal positionChanged();
	signal pressAndHold(variant mouse);
	signal pressed(variant mouse);
	signal released(variant mouse);
	signal wheel(variant wheel);

	function _changePrevents(b){
		root.preventActions = b;
	}

	function _clicked(mouse){
		settings.ismoving = 1;
		if(!VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_CLICK)){
			root.clicked(mouse);
		}
	}
	function _doubleClicked(mouse){
		settings.ismoving = 1;
		if(!VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_DOUBLECLICK)){
			root.doubleClicked(mouse);
		}
	}
	function _positionChanged(){
		settings.ismoving = 1;
		root.positionChanged();
	}
	function _pressAndHold(mouse){
		settings.ismoving = 1;
		if(!VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_PRESSEANDHOLD)){
			root.pressAndHold(mouse);
		}
	}
	function _pressed(mouse){
		settings.ismoving = 1;
		if(!VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_PRESSED)){
			root.pressed(mouse);
		}
	}
	function _released(mouse){
		settings.ismoving = 1;
		if(!VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_RELEASED)){
			root.released(mouse);
		}
	}
	function _wheel(wheel){
		settings.ismoving = 1;
		if(!VPlayer3D.Core.isOn(root.preventActions, VPlayer3D.Core.prevent_WHEEL)){
			root.wheel(wheel);
		}
	}

	function _entered(layer){
		settings.ismoving = 1;
		if(exitedTimer.running){
			// I'm changing layers Or momentary I exited the window
			exitedTimer.stop();
		} else {
			// came from outside of window
			root.entered();
		}
	}

	function _exited(layer){
		settings.ismoving = 5;
		root._exitedLayer = layer;
		exitedTimer.start();
	}

	Timer {
		id: enteredTimer
		interval: 200;
		repeat: false;
		running: false;

		onTriggered: { root.entered(); }
	}

	Timer {
		id: exitedTimer
		interval: 200;
		repeat: false;
		running: false;

		onTriggered: { root.exited(); }
	}

	Timer {
		interval: 1000; running: true; repeat: true
   		onTriggered: { settings.ismoving++ }
	}

	Component.onCompleted: {
		// root.entered.connect(function(){
		// 	settings.ismoving = 1;
		// });

		// root.exited.connect(function(){
		// 	settings.ismoving = 5;
		// });

		// root.positionChanged.connect(function(){
		// 	settings.ismoving = 1;
		// });

		// root.wheel.connect(function(wheel){
		// 	VPlayer3D.Core.log('WHEEL!');
		// 	wheel.accepted = false;
		// });

		// root.pressAndHold.connect(function(mouse){
		// 	VPlayer3D.Core.log('pressAndHold!', mouse);
		// 	pressAndHold.accepted = false;
		// });
	}


}