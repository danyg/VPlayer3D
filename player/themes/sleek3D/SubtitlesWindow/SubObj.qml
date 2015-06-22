/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1
import "SubtitlesWindowImpl.js" as Manager;

Item {
	id: root;

	property var selected: false;

	property var __id: "";
	property var movieName: "";
	property var languageName: "";
	property var subRating: "";
	property var source: "";

	function getId(){
		return __id;
	}

	function setFromData(data){
		root.__id = data.id;
		root.movieName = data.movieName;
		root.languageName = data.languageName;
		root.subRating = data.subRating;
		root.source = data.source;
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