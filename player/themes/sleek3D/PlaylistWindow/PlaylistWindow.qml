/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1

import "PlaylistWindowImpl.js" as Manager
import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems
import "./TableElements" as TableElements
import "./" as PL

VPlayer3DItems.Window {
	id: root;
	componentType: 'playlistWindow';
	windowTitle: 'Playlist';
	scrollSyncItem: table;

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
				kind: 'playlist_elm_' + index;
				modelData: Manager.getItem(index);
			}
		}

		Item {
			visible: false;

			id: tempLM
		}
	}

	Component.onCompleted: {
		Manager.init(root, table, tempLM);

	}
}