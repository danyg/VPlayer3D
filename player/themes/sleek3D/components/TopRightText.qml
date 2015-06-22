import QtQuick 2.1
import QmlVlc 0.1

import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'topRightText'

	property alias fontColor: volumebox.color
	property alias fontShadow: volumeBoxShadow.color
	property alias changeText: volumebox.text
	property alias shadowEffectDuration: shadowTextEffect.duration
	property alias textEffectDuration: volTextEffect.duration
	property alias shadowHolder: shadowHolder
	property alias textHolder: textHolder

	function setText(text, notClean){
		_setText(text, notClean);
		_bindedComponent._setText(text, notClean);
	}

	function _setText(text, notClean){
		if(notClean !== true){
			timer.start();
		}
		root.changeText = text;
		root.shadowEffectDuration = 1;
		root.textEffectDuration = 0;
		root.textHolder.opacity = 1;
		root.shadowHolder.opacity = 1;
		root.textEffectDuration = 300;
	}

	anchors.fill: parent
	color: "transparent"
	Rectangle {
		id: shadowHolder
		color: "transparent"
		opacity: 0
		anchors.right: parent.right
		anchors.rightMargin: fullscreen ? volumebox.paintedWidth +38 : volumebox.paintedWidth +24
		anchors.top: parent.top
		anchors.topMargin: fullscreen ? 37 : 11
        Behavior on opacity { PropertyAnimation { id: shadowTextEffect; duration: 500 } }
		Text {
			id: volumeBoxShadow
			horizontalAlignment: Text.AlignHRight
			text: volumebox.text
			font.pointSize: fullscreen ? mousesurface.height * 0.035 : mousesurface.height * 0.045
			style: Text.Outline
			styleColor: volumeBoxShadow.color
			font.weight: Font.DemiBold
			font.family: fonts.defaultFont.name
			smooth: true
			opacity: 0.5
            Behavior on visible { PropertyAnimation { duration: 0 } }
		}
	}
	Rectangle {
		id: textHolder
		visible: true
		color: 'transparent'
		anchors.right: parent.right
		anchors.rightMargin: fullscreen ? volumebox.paintedWidth +40 : volumebox.paintedWidth +25
		anchors.top: parent.top
		anchors.topMargin: fullscreen ? 35 : 10
		opacity: 0
		Behavior on opacity { PropertyAnimation { id: volTextEffect; duration: 0 } }
		Text {
			id: volumebox
			horizontalAlignment: Text.AlignHRight
			text: ""
			font.pointSize: fullscreen ? mousesurface.height * 0.035 : mousesurface.height * 0.045
			style: Text.Outline
			styleColor: volumeBoxShadow.color
			font.weight: Font.DemiBold
			font.family: fonts.defaultFont.name
			smooth: true
		}
	}
	// Fade Out Top Right text box after 3 seconds
	Timer {
		id: timer
		interval: 3000;
		running: false;
		repeat: false;

		onTriggered: {
			shadowTextEffect.duration = 150;
			shadowHolder.opacity = 0;
			textHolder.opacity = 0;
		}
	}
	// End Fade Out Top Right text box after 3 seconds
}