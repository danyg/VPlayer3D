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

VPlayer3DItems.AbstractWindow {
	id: root;
	componentType: 'window';

	default property alias content: container.children
	property alias buttons: buttonsPlacement.children

	property var debug: false;

	property var windowTitle: 'No Name Window';
	property Item container;
	property Item scrollSyncItem;

	width: 800;
	height: 350;

	anchors.left: parent.left;
	anchors.verticalCenter: parent.verticalCenter;
	anchors.leftMargin: ((parent.width - root.width)/2) + _3dOffset;

	VPlayer3DItems.Background{}

	VPlayer3DItems.Titlebar{
		id: title;
		text: root.windowTitle;
		kind: root.componentType + 'titleBar';
		onCloseClicked: {
			close();
		}
	}

	Rectangle {
		visible: root.debug;

		color: '#90ee90';
		opacity: .2;

		anchors.fill: container;
	}

	Flickable{
		id: container;

		anchors.top: title.bottom;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: buttonsLayer.visible ? buttonsLayer.top : parent.bottom
		// anchors.bottom: buttonsLayer.top

		anchors.leftMargin: 5;
		anchors.rightMargin: 5;
		anchors.bottomMargin: buttons.visible ? 0 : 5;

		clip: true;
	}

	Rectangle {
	    color: "transparent";
	    id: buttonsLayer;
	    visible: buttons.length > 0;
	    // visible: true;

		anchors.left: parent.left;
		anchors.right: parent.right;
	   	anchors.bottom: parent.bottom;

	   	anchors.leftMargin: 5;
		anchors.rightMargin: 5;

	   	height: 30;

		anchors.bottomMargin: 5;

		Row {
			id: buttonsPlacement;
			anchors.fill: parent;
			spacing: 2;
			layoutDirection: Qt.RightToLeft;
		}
	}

	property var _completed: false;
	property var _changed: false;
	property var _ignoreScrollChanged: false;

	function scrollY(y){
		_scrollY(y);
		_bindedComponent._scrollY(y);
	}

	function _scrollY(y){
		root._ignoreScrollChanged = true;
		scrollSyncItem.contentY = y;
		root._ignoreScrollChanged = false;
	}

	function scrollX(x){
		_scrollX(x);
		_bindedComponent._scrollX(x);
	}

	function _scrollX(x){
		root._ignoreScrollChanged = true;
		scrollSyncItem.contentX = x;
		root._ignoreScrollChanged = false;
	}

	Component.onCompleted: {
		VPlayer3D.Core.log('3DWINDOW ', root.componentType);

		if(!scrollSyncItem){
			scrollSyncItem = container;
		}

		scrollSyncItem.contentYChanged.connect(function(){
			if(!root._ignoreScrollChanged){
				root._bindedComponent._scrollY(scrollSyncItem.contentY);
			}
		});
		scrollSyncItem.contentXChanged.connect(function(){
			if(!root._ignoreScrollChanged){
				root._bindedComponent._scrollX(scrollSyncItem.contentX);
			}
		});
	}
}