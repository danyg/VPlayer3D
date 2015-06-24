import QtQuick 2.1
import QmlVlc 0.1

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'OSD'

	property alias fontColor: textBox.color
	property alias fontShadow: textBoxShadow.color
	property alias changeText: textBox.text
	property alias align: textBox.horizontalAlignment

	property var fontSize: parent.height * 0.025;

	width: parent.width;
	// height: 2 * root.fontSize;
	height: 30;

	color: "transparent"

	function setText(text, notClean){
		_setText(text, notClean);
		_bindedComponent._setText(text, notClean);
	}

	function _setText(text, notClean){
		if(notClean !== true){
			timer.start();
		}
		root.changeText = text;
		root.show();
	}

	Text {
		id: textBoxShadow;

		anchors.left: parent.left
		anchors.top: parent.top

		anchors.rightMargin: 2;
		anchors.topMargin: 2;

		width: textBox.width;

		font.pointSize: textBox.font.pointSize;

		horizontalAlignment: textBox.horizontalAlignment;
		verticalAlignment: textBox.verticalAlignment;

		text: textBox.text;

		style: textBox.style;
		styleColor: textBoxShadow.color;

		font.weight: textBox.font.weight;
		font.family: textBox.font.family;
		smooth: textBox.smooth;

		opacity: 0.5;
	}

	Text {
		id: textBox;

		anchors.left: parent.left
		anchors.top: parent.top

		width: parent.width;

		font.pointSize: root.fontSize;

		horizontalAlignment: Text.AlignRight
		verticalAlignment: Text.AlignVCenter;

		text: "";

		style: Text.Outline;
		styleColor: textBoxShadow.color;

		font.weight: Font.Light;
		font.family: fonts.defaultFont.name;
		smooth: true;

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

	Timer {
		id: timer
		interval: 3000;
		running: false;
		repeat: false;

		onTriggered: {
			root.hide();
		}
	}

	Component.onCompleted: {
		// VPlayer3D.Core.log('!!! INITIATED', root.componentType);
		root.show();
	}
}