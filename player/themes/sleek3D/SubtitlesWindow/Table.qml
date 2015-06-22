/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/
import QtQuick 2.1
import QtQuick.Controls 1.3

import "../VPlayer3D" as VPlayer3D

TableView {
	id: table;

	highlightOnFocus: false;
	horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff;
	selectionMode: SelectionMode.MultiSelection;
	activeFocusOnTab: false;

	TableViewColumn {
		role: "MovieName"
		title: "Title"
		width: parent.width * .5
	}
	TableViewColumn {
		role: "LanguageName"
		title: "Language"
		width: parent.width * .25
	}
	TableViewColumn {
		role: "SubRating"
		title: "Raiting"
		width: parent.width * .23
	}

	itemDelegate: Rectangle {
		width: parent.width
		height: 30
		color: styleData.selected ? VPlayer3D.Core.color(ui.colors.base, .8) : ui.colors.base;
		opacity: 1;

		Text {
			anchors.verticalCenter: parent.verticalCenter;
			color: styleData.selected ? VPlayer3D.Core.color(ui.colors.basefont) : VPlayer3D.Core.color(ui.colors.basefont, 40);
			elide: styleData.elideMode;
			text: styleData.value;
		}
	}

	// Timer {
	// 	interval: 1000;
	// 	running: true;
	// 	repeat: true;
	// 	onTriggered: {
	// 		try{
	// 			VPlayer3D.Core.log('------>>> ', table.__viewTopMargin);
	// 		}catch(e){}
	// 	}
	// }

}