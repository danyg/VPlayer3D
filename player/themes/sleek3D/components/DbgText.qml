import QtQuick 2.1
import QmlVlc 0.1

Rectangle {
	property alias fontColor: dbgText.color
	property alias changeText: dbgText.text

	anchors.fill: parent
	color: "transparent"
	Rectangle {
		visible: dbgbox.text != "" ? true : false
		color: 'transparent'
		width: parent.width
		anchors.top: parent.top
		anchors.left: parent.left
		Text {
			id: dbgText
			visible: true
			anchors.horizontalCenter: parent.horizontalCenter
			horizontalAlignment: Text.AlignHCenter
			text: "DBG ACTIVATED"
			font.pointSize: fullscreen ? mousesurface.height * (parseFloat(settings.subPresets[settings.subSize]) -0.005) : mousesurface.height * parseFloat(settings.subPresets[settings.subSize])
			style: Text.Outline
			styleColor: "#FFFFFF"
			color: "#00FF00"
			font.weight: Font.DemiBold
			font.family: fonts.secondaryFont.name
			smooth: true
		}
	}
}