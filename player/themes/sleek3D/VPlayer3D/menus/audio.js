/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

function addMenu(list){
	var item = {
		text: 'Audio',
		kind: 'audio',
		subitems: []
	};

	_addAudioTracksMenu(item.subitems);

	if(vlcPlayer.audio.track !== -1){
		item.subitems.push({
			text: 'Stereo',
			kind: 'setStereo',

			isSelected: function(){
				return vlcPlayer.audio.channel === 1;
			},
			click: function(){
				vlcPlayer.audio.channel = 1;
			}
		});
		item.subitems.push({
			text: 'Reverse Stereo',
			kind: 'setReverse',

			isSelected: function(){
				return vlcPlayer.audio.channel === 2;
			},
			click: function(){
				vlcPlayer.audio.channel = 2;
			}
		});
		item.subitems.push({
			text: 'Only Left',
			kind: 'setLeft',

			isSelected: function(){
				return vlcPlayer.audio.channel === 3;
			},
			click: function(){
				vlcPlayer.audio.channel = 3;
			}
		});
		item.subitems.push({
			text: 'Only Right',
			kind: 'setRight',

			isSelected: function(){
				return vlcPlayer.audio.channel === 4;
			},
			click: function(){
				vlcPlayer.audio.channel = 4;
			}
		});
		item.subitems.push({
			text: 'Dolby Surround',
			kind: 'setDolby',

			isSelected: function(){
				return vlcPlayer.audio.channel === 5;
			},
			click: function(){
				vlcPlayer.audio.channel = 5;
			}
		});
	}

	list.push(item);
}

function _addAudioTracksMenu(list){
	if(vlcPlayer.audio.count <= 0) {
		return;
	}

	var item = {
		text: 'Audio Tracks',
		kind: 'audioTracks',
		subitems: []
	};

	var i;
	for (i = 0; i < vlcPlayer.audio.count; i++) {
		item.subitems.push({
			text: vlcPlayer.audio.description(i),
			kind: 'audio_' + i,
			isSelected: _getIsSelectedAudioTrack( i===0 ? -1 : i),
			click: _getSelectAudioTrack(i)
		})
	}
	list.push(item);
}

function _getIsSelectedAudioTrack(audioTrackIx){
	return function(){
		return vlcPlayer.audio.track === audioTrackIx;
	}
}

function _getSelectAudioTrack(audioTrackIx){
	return function(){
		vlcPlayer.audio.track = audioTrackIx;
		app.infoMsg("Audio Track: " + vlcPlayer.audio.description(audioTrackIx));
	}
}
