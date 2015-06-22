/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1

import "SubtitlesWindowImpl.js" as Manager
import "./" as SW
import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems
import "./TableElements" as TableElements

VPlayer3DItems.Window {
	id: root
	componentType: 'subtitlesWindow';
	windowTitle: 'Subtitles';
	scrollSyncItem: table;

	width: 800;
	height: 350;

	anchors.left: parent.left;
	anchors.verticalCenter: parent.verticalCenter;
	anchors.leftMargin: ((parent.width - root.width)/2) + _3dOffset;

	Rectangle{
		color: "transparent"
		anchors.fill: parent;

		TableElements.Header{
			id: header;
		}

		ListView{
			// visible: false;
			id: table;
			clip: true;

			anchors.left: parent.left;
			anchors.top: header.bottom;
			anchors.right: parent.right;
			anchors.bottom: parent.bottom;

			anchors.topMargin: 2;


			delegate: TableElements.Row{
				kind: 'subtitle_elm_' + index;
				modelData: Manager.getItem(index);
			}
		}

		Item {
			visible: false;

			id: tempLM
			// SW.SubObj{}
		}
	}

	buttons: [
		VPlayer3DItems.Button{
			kind: 'sub_search';
			icon: ui.iconFa.search;
			text: 'Search Online';

			onButtonClicked: {
				app.trigger('searchSubtitlesOnline')
			}
		}
	]


	Component.onCompleted: {
		Manager.init(root, table, tempLM);

	}

}