import QtQuick 2.1
import QmlVlc 0.1

import "../VPlayer3D" as VPlayer3D
import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'splashScreen'

	property alias fontColor: openingtext.color
	property alias fontShadow: loadingFont.styleColor
	property alias iconOpacity: playerlogo.opacity
	property alias changeText: loadingFont.text

	property var eye;

	anchors.fill: parent
	visible: vlcPlayer.state < 3 ? true : false
	// If Playlist is Open Show Top Text
	Text {
		id: openingtext
		visible: playlistblock.visible === true || subMenublock.visible === true ? true : false
		anchors.top: parent.top
		anchors.topMargin: 10
		anchors.horizontalCenter: parent.horizontalCenter
		text: "Opening"
		font.pointSize: 15
	}
	// End If Playlist is Open Show Top Text

	Rectangle {
		anchors.centerIn: parent
		width: parent.height * .75
		height: parent.height * .75
		color: "transparent"


		Image {
			id: playerlogo
			anchors.fill: parent
			anchors.top: parent.top
			anchors.horizontalCenter: parent.horizontalCenter

			fillMode: Image.PreserveAspectFit;

			source: '../images/Logo' + (root.eye === VPlayer3D.Settings3D.c_LEFT_EYE ? 'L' : 'R') + '.png'
			// source: '../images/arrow.png';
			opacity: .5;

			Behavior on opacity { PropertyAnimation { duration: 2000} }
		}
		Text {
			id: loadingFont
			visible: settings.multiscreen == 1 ? fullscreen ? vlcPlayer.state == 1 || vlcPlayer.state == 0 ? true : settings.buffering > 0 && settings.buffering < 100 ? true : false : false : vlcPlayer.state == 1 || vlcPlayer.state == 0 ? true : settings.buffering > 0 && settings.buffering < 100 ? true : false // Required for Multiscreen

			anchors.bottom: parent.bottom
			anchors.bottomMargin: 40;
			anchors.leftMargin: 5 + root._offset;

			anchors.horizontalCenter: parent.horizontalCenter

			text: settings.openingText
			font.pointSize: fullscreen ? 14 : 13
			font.weight: Font.DemiBold
			color: openingtext.color
			style: Text.Outline
			styleColor: UI.colors.fontShadow
		}

		Timer {
			id: timer;
			interval: 2500;
			running: root.visible;
			repeat: true;
			triggeredOnStart: true;

			onTriggered: {
				VPlayer3D.Core.log('SplashScreen Timer:', playerlogo.opacity);
				playerlogo.opacity = playerlogo.opacity !== .5 ? .5 : .2;
			}
		}
	}


	// Component.onCompleted: {
	// 	VPlayer3D.Core.log('SplashScreen OnComplete:');
	// 	root.visibleChanged.connect(function(){
	// 		VPlayer3D.Core.log('SplashScreen Timer START:');
	// 		timer.start();
	// 	})
	// }
}