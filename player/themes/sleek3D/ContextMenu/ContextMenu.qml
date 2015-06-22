/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

import QtQuick 2.1;
import QtQuick.Layouts 1.0;
import QmlVlc 0.1;

import "./" as ContextMenu
import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'contextMenu'

	property var _3dOffset: (settings.subtitles3DOffset * _offset)

	visible: false
	anchors.topMargin: 0
	anchors.leftMargin: root._3dOffset

	width: 150
	height: 0
	color: VPlayer3D.Core.color(ui.colors.base)

	property alias rootContainer: root._rootContainer;
	property var _rootContainer;

	property alias director: root._director;
	property var _director;

	property alias parentMenu: root._parentMenu;
	property var _parentMenu;
	property var contextMenuItem: Qt.createComponent("./ContextMenuItem.qml")
	property var contextMenu: Qt.createComponent("./ContextMenu.qml")

	property alias list: root._list
	property var _list
	property alias opener: root._opener
	property var _opener

	property var items: [];
	property var submenus: [];
	property alias cMouse: root._cMouse
	property var _cMouse: false;

	property alias subMenIdSeed: root._subMenIdSeed;
	property var _subMenIdSeed: 'main';
	property var _hoverEffect: false;

	signal mouseEnter
	signal mouseExit
	signal closed

	signal subMouseIn(string id)
	signal subMouseOut(string id)

	function subElementMouseIn(id){
		subMouseIn(id);
		_bindedComponent.subMouseIn(id);
	}

	function subElementMouseOut(id){
		subMouseOut(id);
		_bindedComponent.subMouseOut(id);
	}

	function subMenuHover(id){
		if(id.indexOf(root._subMenIdSeed) === 0){
			if(root._hoverEffect === false){
				open();
			}
			root._hoverEffect = true;
		} else {
			if(root._hoverEffect === true){
				close();
			}
			root._hoverEffect = false;
		}
	}

	function imRoot() {
		return !_parentMenu;
	}
	function imSubmenu() {
		return _parentMenu;
	}

	function clickItem(kind){
		_clickItem(kind);
		_bindedComponent._clickItem(kind);
	}

	function _clickItem(kind){
		if(imSubmenu()){
			_director.close();
		} else {
			close();
		}
	}

	function _mouseEnter(){
		_cMouse = true;
		mouseEnter()
		_bindedComponent.mouseEnter();
	}
	function _mouseExit(){
		// _cMouse = false;
		mouseExit()
		_bindedComponent.mouseExit();
	}

	function getContainsMouse(){
		return (!!_bindedComponent ? _bindedComponent.cMouse : false) || root._cMouse;
	}

	function addSubMenu(subMenu){
		submenus.push(subMenu);

		if(imSubmenu()){
			_director.addSubMenu(subMenu)
		}
	}

	function open() {
		if(imRoot()){
			openMain();
		} else {
			openSubMenu();
		}
	}

	function openMain(){
		if(root.visible) {
			eraseMe();
		}
		addContextItems();

		_open();
		_bindedComponent._open();
	}

	function openSubMenu() {
		if(items.length === 0){
			addContextItems();
		}

		_open();
		_bindedComponent._open();
	}

	function _open() {
		var resultantRight,
			resultantBottom
		;

		if(!!_opener){
			// SUBMENU MODE
			resultantRight = _parentMenu.x + _parentMenu.width + root.width;
			resultantBottom = _parentMenu.y + root.anchors.topMargin + root.height;

			if (resultantRight > mousesurface.width) {
				root.anchors.right = _parentMenu.left;
			} else {
				root.anchors.left = _parentMenu.right;
			}

			if (resultantBottom > mousesurface.height) {
				root.anchors.bottom = _parentMenu.bottom;
				root.anchors.topMargin = _opener.y + _opener.height;
			} else {
				root.anchors.top = _parentMenu.top;
				root.anchors.topMargin = _opener.y;
			}

		}else{
			// ROOT MODE
			resultantRight = settings.cursorX + root.width;
			resultantBottom = settings.cursorY + root.height;

			root.anchors.top = parent.top;
			root.anchors.left = parent.left;

			if (resultantRight > mousesurface.width) {
				root.anchors.leftMargin = (mousesurface.width - root.width) + root._3dOffset;
			} else {
				root.anchors.leftMargin = (settings.cursorX) + root._3dOffset;
			}

			if (resultantBottom > mousesurface.height) {
				root.anchors.topMargin = mousesurface.height - root.height;
			} else {
				root.anchors.topMargin = settings.cursorY;
			}
		}

		root.visible = true;

	}

	function close(){
		if(imRoot()){
			// root Menu is eraseMeed and all his hierarchy
			eraseMe();
		} else {
			_close();
			_bindedComponent._close();
		}
	}

	function _close(){
		root.visible = false;
		closed();
	}

	function eraseMe() {
		_eraseMe();
		_bindedComponent._eraseMe();
	}

	function _eraseMe() {
		root.visible = false;
		closed();

		_clearAll();

		if(imSubmenu()) {
			// eraseMe myself only if i'm not root
			_director.subMouseIn.disconnect(root.subMenuHover);
			VPlayer3D.Core.destroyComponent(componentType);
		}
	}

	function clearAll() {
		_clearAll()
		_bindedComponent._clearAll();
	}

	function _clearAll() {
		var item;

		if(imRoot()){
			root._list = null;
		}

		while(!!(item = root.items.pop())){
			VPlayer3D.Core.destroyComponent(item.getComponentType());
			item.destroy();
		}
		if(imRoot()){
			var subMenu;
			while(!!(subMenu = root.submenus.pop())){
				try{
					subMenu.eraseMe();
				} catch(e) {
					VPlayer3D.Core.error(e.message, e.stack);
				}
			}
		}
	}

	function addContextItems() {
		_addContextItems();
		_bindedComponent._addContextItems();
	}

	function _addContextItems() {
		_clearAll();

		if(!_list){
			_list = VPlayer3D.ContextMenu.calculateItems()
		}
		_drawItems(_list);
	}

	function _drawItems(list){
		if(_rootContainer == null){
			_rootContainer = parent;
		}

		for(var i = 0; i < list.length; i++){

			items.push( _createItem(list[i]) );

		}

		root.height = (items.length * 30);
	}

	function _createItem(opts){
		var top = items.length === 0 ? root.top : items[items.length-1].bottom;


		var item = contextMenuItem.createObject(root, {
			text: opts.text,
			kind: opts.kind,

			submenuId: root._subMenIdSeed + '_' + opts.kind,
			director: !!_director ? _director : root,

			'anchors.top': top
		});

		if(!!opts.subitems && opts.subitems.length > 0) {
			var subMenu = contextMenu.createObject(_rootContainer, {
				kind: 'subMenu_' + opts.kind,

				subMenIdSeed: root._subMenIdSeed + '_' + opts.kind,

				list: opts.subitems,
				rootContainer: !!_rootContainer ? _rootContainer : root.parent,
				director: !!_director ? _director : root,
				opener: item,

				parentMenu: root,
				color: root.color
			});

			root.addSubMenu(subMenu);
			item.setSubMenu(subMenu);
		}

		if(!!opts.isSelected){
			item.setSelected(opts.isSelected);
		}
		if(!!opts.click){
			item.setClick(opts.click);
		}

		return item;
	}

	Component.onCompleted: {
		if(!!_director){
			_director.subMouseIn.connect(root.subMenuHover);
		}
		if(_opener){
			root.anchors.topMargin = _opener.y;
		}
	}

}