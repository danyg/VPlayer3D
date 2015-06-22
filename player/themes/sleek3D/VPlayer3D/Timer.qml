/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1

Rectangle {
	id: root
	signal triggered
	property alias interval: timer.interval
	property alias repeat: timer.repeat

	function start(){
		return timer.start();
	}

	function stop(){
		return timer.stop();
	}

	Timer{
		id: timer
		onTriggered: root.onTriggered()

	}

}