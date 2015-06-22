import QtQuick 2.1
import QmlVlc 0.1
import QtGraphicalEffects 1.0

import "../VPlayer3DItems" as VPlayer3DItems

VPlayer3DItems.BindedItem {
	id: root
	componentType: 'toolbarButton'


	property alias icon: icon.text
	property alias fontFamily: icon.font.family
	property alias iconSize: icon.font.pointSize
	property alias iconElem: icon
	property alias hover: mouseAreaButton
	// property alias glow: glowEffect.visible
	property alias glow: root._glow
	property var _glow

	property alias myName: root._myName
	property var _myName: "NoName"

	signal buttonClicked
	signal buttonEntered
	signal buttonExited

	function getContainsMouse(){
		return (!!_bindedComponent ? _bindedComponent.hover.containsMouse : false) || mouseAreaButton.containsMouse;
	}

	function isVisible() {
		return root.visible;
	}

	function setVisible(status){
		set('visible', status);
	}

	height: parent.height
	width: buttonWidth
	clip: false
	color: 'transparent'
	Text {
		id: icon
		anchors.centerIn: parent
		font.family: fonts.icons.name
		color: getContainsMouse() ? ui.colors.toolbar.buttonHover : ui.colors.toolbar.button
		// height: paintedHeight + (glowEffect.radius * 2)
        // width: paintedWidth + (glowEffect.radius * 2)
		height: paintedHeight
        width: paintedWidth
		horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.weight: Font.Light
	}


	VPlayer3DItems.BindedMouseArea {
		id: mouseAreaButton
		kind: root._kind + '_mouseAreaButton'

		anchors.fill: parent
		hoverEnabled: true
		onClicked: root.buttonClicked()
		// onPressed: root.buttonClicked()
		onEntered: root.buttonEntered()
		onExited: root.buttonExited()
	}

}