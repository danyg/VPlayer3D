/*
* Copyright (C) 2015 VPlayer3D
* based on code by Sergey Radionov <rsatom_gmail.com> Copyright © 2014-2015 WebChimera
* License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher
*
* @author Daniel Goberitz <dalgo86@gmail.com>
*/

.import "../Core.js" as Core
.import "../Subtitles.js" as SubtitlesCore
.import "./subtitlesSize.js" as FontSize

var subSelected;

function addMenu(list){
	var subs;

	try{
		subs = JSON.parse(
			vlcPlayer.playlist.items[vlcPlayer.playlist.currentItem].setting
		);
		subs = subs.subtitles;
	}catch(e){}

	var item = {
		text: 'Subtitles',
		kind: 'subtitles',
		subitems: []
	};

	FontSize.addMenu(item.subitems);

	item.subitems.push({
		text: vlcPlayer.subtitle.description(0),
		kind: 'subtitle_disabled',
		isSelected: _getIsSelected( -1 ),
		click: _getClick(-1)
	});

	for(var i = 0; i < settings.subtitleTracks.length; i++){
		item.subitems.push({
			text: settings.subtitleTracks[i].name,
			kind: 'subtitle_' + i,
			isSelected: _getIsSelected(i),
			click: _getClick(i)
		});
	}

	list.push(item);
}

function _getIsSelected(ix){
	return function(){
		return settings.curSubtitleTrack === ix;
	}
}

function _getClick(ix){
	return function(){
		SubtitlesCore.select(ix);
	}
}
