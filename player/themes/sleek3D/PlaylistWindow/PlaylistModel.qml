/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1
import "./PlaylistWindowImpl.js" as Manager
import "../VPlayer3D" as VPlayer3D

Item {
	id: root;

	property var selected: false;

	property var ix: "";
	property var filename: "";
	property var duration: "";
	property var rawData: "";

	function getIx(){
		return root.ix;
	}

	function setFromData(data, ix){
		root.ix = ix;
		root.filename = data.title.replace('[custom]', '');
		root.duration = '00:00:00';
		root.rawData = data;
	}

	function isSelected(){
		return root.selected;
	}

	function toggleSelect(){
		if(root.selected){
			unselect()
		} else {
			select();
		}
	}

	function select(){
		Manager.setSelect(root);
		_select();
	}

	function _select(){
		root.selected = true;
	}

	function unselect(){
		root.selected = false;
	}

}