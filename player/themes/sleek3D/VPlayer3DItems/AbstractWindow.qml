/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems
import "./WindowImpl.js" as Manager

VPlayer3DItems.BindedItem {
	id: root;

	componentType: 'abstractWindow';

	property var _3dOffset: (settings.subtitles3DOffset * _offset);

	color: "transparent";

	function close(){
		_close();
		_bindedComponent._close();
	}

	function _close(){
		root.hide();
	}

	function open(){
		Manager.onOpen(root);
		_open();
		_bindedComponent._open();
	}

	function _open(){
		// root.visible = true;
		root.show();
	}

	function toggle(){
		if(root.get('visible')){
			close();
		} else {
			open();
		}
	}

	function show(){
		root.visible = true;
		root.state = 'visible';
	}
	function hide(){
		root.state = 'hidden';
	}

	states: [
		State {
			name: "visible"
			PropertyChanges {
				target: root;
				opacity: 1;
			}
		},
		State {
			name: "hidden"
			PropertyChanges {
				target: root;
				opacity: 0;
			}
		}
	]
	transitions: Transition {
		id: trans
		PropertyAnimation {
			id: anim
			duration: root.animTime
			targets: [root]
			properties: 'opacity';
		}

		onRunningChanged: {
			if(!trans.running){
				root.visible = root.state === 'hidden' ? false : true;
			}
		}
	}

	Component.onCompleted: {
		Manager.init(root);

		root.state = 'hidden';
	}
}