import QtQuick 2.1
import QmlVlc 0.1

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'buftext'

	property alias fontColor: textLayer.color
	property alias fontShadow: bufshadow.color
	property alias changeText: textLayer.text

	function isVisible(){
		return textLayer.text.length > 0;
	}

	anchors.fill: parent
	color: "transparent"
	Rectangle {
		visible: isVisible()
		color: 'transparent'
		width: fullscreen ? parent.width -4 : parent.width -2
		anchors.top: parent.top
		anchors.topMargin: fullscreen ? 37 : 11
		anchors.horizontalCenter: parent.horizontalCenter
		Text {
			id: bufshadow
			visible: isVisible()
			anchors.horizontalCenter: parent.horizontalCenter
			text: textLayer.text
			font.pointSize: textLayer.font.pointSize
			style: Text.Outline
			styleColor: bufshadow.color
			font.weight: Font.DemiBold
			font.family: fonts.secondaryFont.name
			smooth: true
			opacity: 0.5
		}
	}
	Rectangle {
		visible: isVisible()
		color: 'transparent'
		width: parent.width
		anchors.top: parent.top
		anchors.topMargin: fullscreen ? 35 : 10
		anchors.horizontalCenter: parent.horizontalCenter
		Text {
			id: textLayer
			visible: isVisible()
			anchors.horizontalCenter: parent.horizontalCenter
			text: ""
			font.pointSize: fullscreen ? mousesurface.height * 0.030 : (mousesurface.height * 0.035) < 16 ? 16 : mousesurface.height * 0.035
			style: Text.Outline
			styleColor: bufshadow.color
			font.weight: Font.DemiBold
			font.family: fonts.secondaryFont.name
			smooth: true
		}
	}
}