import QtQuick 2.1
import QmlVlc 0.1

// Draw Pause Icon (appears in center of screen when Toggle Pause)
import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'pausetog'

	property alias icon: icon.text
	property alias iconColor: icon.color

	property var animTime: 300

	anchors.left: parent.left
	anchors.top: parent.top
	// anchors.centerIn: parent

	property var _baseLeft: (parent.width - root.width) / 2
	property var _baseTop: (parent.height - root.height) / 2
	anchors.leftMargin: root._baseLeft
	anchors.topMargin: root._baseTop

	visible: false

	height: 75
	width: 75
	opacity: 1

	radius: 10
	smooth: true

	states: [
		State {
			name: "basestate"
			PropertyChanges {
				target: root
				anchors.leftMargin: root._baseLeft
				height: 75
				width: 75
				// opacity: 1
			}
			PropertyChanges {
				target: icon
				anchors.leftMargin: root._baseLeft
				font.pointSize: 36
				// opacity: 1
			}
		},
		State {
			name: "vanishing"
			PropertyChanges {
				target: root
				anchors.leftMargin: root._baseLeft + (_offset * 10)
				height: 170
				width: 170
				opacity: 0
			}
			PropertyChanges {
				target: icon
				anchors.leftMargin: root._baseLeft
				font.pointSize: 92
				opacity: 0
			}
		}
	]
	transitions: Transition {
		id: trans
		PropertyAnimation {
			id: anim
			duration: root.animTime
			targets: [root, icon]
			properties: 'anchors.leftMargin, font.pointSize, height, width, opacity';
		}

		onRunningChanged: {
			if(!trans.running){
				root.visible = false;
			}
		}
	}

	// End Play Icon Effect when Visible

	function show(){
		_show();
		_bindedComponent._show();
	}

	property var count: 0

	function _show(){
		root.visible = true;

		trans.enabled = false;
		root.state = 'basestate';

		trans.enabled = true;
		root.state = 'vanishing';
	}

	Text {
		id: icon
		anchors.centerIn: parent
		font.family: fonts.icons.name
		text: ui.icon.bigPause
		font.pointSize: 36
		opacity: 1
	}

	Component.onCompleted: {
		trans.enabled = false;
		root.state = 'basestate'
	}
}
// End Draw Pause Icon (appears in center of screen when Toggle Pause)