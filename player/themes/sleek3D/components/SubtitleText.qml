import QtQuick 2.1
import QmlVlc 0.1

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'subsBox'

	property alias fontColor: subtitlebox.color
	property alias fontShadow: subtitleboxShadow.color
	property alias changeText: subtitlebox.text
	property var fontSize: parent.height * parseFloat(settings.subPresets[settings.subSize][0])

	anchors.fill: parent
	color: "transparent"

	Rectangle {
		visible: subtitlebox.text != "" ? true : false
		color: 'transparent'
		width: parent.width - 30

		anchors.bottom: parent.bottom
		anchors.bottomMargin: subtitlebox.paintedHeight + settings.subtitlesBottomOffset -2
		anchors.left: parent.left
		anchors.leftMargin: (settings.subtitles3DOffset * _offset) + 2

		Text {
			id: subtitleboxShadow
			opacity: 0.5

			visible: subtitlebox.text != "" ? true : false
			anchors.horizontalCenter: parent.horizontalCenter
			horizontalAlignment: Text.AlignHCenter
			text: subtitlebox.text

			style: Text.Outline
			styleColor: subtitleboxShadow.color
			font.weight: Font.Light

			font.family: "Helvetica, Arial, Serif, Sans-Serif, "+fonts.secondaryFont.name
			font.pointSize: root.fontSize

			smooth: true

			wrapMode: Text.WordWrap
			textFormat: Text.StyledText
		}
	}
	Rectangle {
		visible: subtitlebox.text != "" ? true : false
		color: 'transparent'
		width: parent.width - 30
		anchors.bottom: parent.bottom
		anchors.bottomMargin: subtitlebox.paintedHeight + settings.subtitlesBottomOffset
		anchors.left: parent.left
		anchors.leftMargin: (settings.subtitles3DOffset * _offset)

		Text {
			id: subtitlebox

			visible: subtitlebox.text != "" ? true : false
			anchors.horizontalCenter: parent.horizontalCenter
			horizontalAlignment: Text.AlignHCenter
			text: ""

			style: Text.Outline
			styleColor: subtitleboxShadow.color

			font.family: "Helvetica, Arial, Serif, Sans-Serif, "+fonts.secondaryFont.name
			font.pointSize: root.fontSize
			font.weight: Font.Light

			smooth: true

			wrapMode: Text.WordWrap
			textFormat: Text.StyledText
		}
	}

}