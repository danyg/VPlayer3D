/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1
import QmlVlc 0.1

import "./" as VPlayer3D

Item {
	id: root;

	function __export(){
		VPlayer3D.App.storeGlobalData(
			root,
			vlcPlayer,
			settings,
			fireQmlMessage,
			plugin,
			wjs
		);
	}
	function init(){
		__export();
		VPlayer3D.App.init();
	}

	function qmlLoaded(){
		__export();
		VPlayer3D.App._qmlLoaded();
	}

	function get(){
		return VPlayer3D.App.get.apply(VPlayer3D.App, arguments);
	}

	function set(){
		return VPlayer3D.App.set.apply(VPlayer3D.App, arguments);
	}

	function on(){
		return VPlayer3D.App.on.apply(VPlayer3D.App, arguments);
	}

	function trigger(){
		return VPlayer3D.App.trigger.apply(VPlayer3D.App, arguments);
	}


	function connectTo(){
		return VPlayer3D.App.connectTo.apply(VPlayer3D.App, arguments);
	}

	function infoMsg(){
		return VPlayer3D.App.infoMsg.apply(VPlayer3D.App, arguments);
	}

	function setVolume(){
		return VPlayer3D.App.setVolume.apply(VPlayer3D.App, arguments);
	}

	function setGamma(){
		return VPlayer3D.App.setGamma.apply(VPlayer3D.App, arguments);
	}

	function setBrightness(){
		return VPlayer3D.App.setBrightness.apply(VPlayer3D.App, arguments);
	}

	function setContrast(){
		return VPlayer3D.App.setContrast.apply(VPlayer3D.App, arguments);
	}

	function setVideoTime(){
		return VPlayer3D.App.setVideoTime.apply(VPlayer3D.App, arguments);
	}

	function pause(){
		return VPlayer3D.App.pause.apply(VPlayer3D.App, arguments);
	}

	function play(){
		return VPlayer3D.App.play.apply(VPlayer3D.App, arguments);
	}


}