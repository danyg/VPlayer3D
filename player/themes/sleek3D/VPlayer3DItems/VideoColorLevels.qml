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
	componentType: 'VideoColorLevelContainer'

	anchors.left: parent.left;
	anchors.bottom: parent.bottom;
	anchors.bottomMargin: 72;

	property var widthPercentage: 40;
	width: 175;
	anchors.leftMargin: ((parent.width - root.width)/2) + 250 + _3dOffset;
	// anchors.rightMargin: 100 - _3dOffset;

	height: 126;
	visible: false;

	opacity: settings.ismoving > 5 ? 0 : 1

	Column {
		spacing: 2;
		anchors.fill: parent

		VPlayer3DItems.IconRow{
			icon: ui.iconFa.bright

			VPlayer3DItems.Slider{
				kind: 'bright'

				width: parent.width

				minValue: 0;
				maxValue: 2;
				value: settings.brightness;

				onChanged: {
					app.setBrightness(value);
				}
			}
		}

		VPlayer3DItems.IconRow{
			icon: ui.iconFa.contrast

			VPlayer3DItems.Slider{
				kind: 'contrast'

				width: parent.width

				minValue: 0;
				maxValue: 2;
				value: settings.contrast;

				onChanged: {
					app.setContrast(value);
				}
			}
		}

		VPlayer3DItems.IconRow{
			icon: ui.iconFa.gamma

			VPlayer3DItems.Slider{
				kind: 'gamma'

				width: parent.width

				minValue: 0;
				maxValue: 4;
				value: settings.gamma;

				onChanged: {
					app.setGamma(value);
				}
			}
		}

		VPlayer3DItems.Button{
			height: 30;
			width: parent.width;

			icon: ui.iconFa.replay;
			text: 'Reset Values';
			kind: root.componentType + '_ResetButton';
			onButtonClicked: {
				VPlayer3D.App.setDefaultColorValues();
			}
		}

	}


}