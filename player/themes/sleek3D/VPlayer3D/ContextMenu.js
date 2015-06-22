/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

.import 'menus/audio.js' as Audio
.import 'menus/aspectRatio.js' as AspectRatio
.import 'menus/crop.js' as Crop
.import 'menus/zoom.js' as Zoom
.import 'menus/mode3D.js' as Mode3D
.import 'menus/subtitles.js' as Subtitles

.import './Core.js' as Core
.import './Settings3D.js' as Settings3D

function calculateItems(){
	try{

		var list = [];

		if (_isVideoLoaded()) {
			Audio.addMenu(list);

			if (Settings3D.getMode() === Settings3D.c_MODE_2D){
				AspectRatio.addMenu(list);
				Crop.addMenu(list);
				Zoom.addMenu(list);
			}

			Subtitles.addMenu(list);
		}

		Mode3D.addMenu(list);

		list.push({
			text: 'VPlayer3D 0.1 Beta',
			kind: 'about'
		});
	} catch( e ){
		Core.error(e.message, e.stack);
	}

	return list;
}

function _isVideoLoaded(){
	return vlcPlayer.state >= 2 && vlcPlayer.state <= 4;
}
