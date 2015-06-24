import QtQuick 2.1

import "../VPlayer3D" as VPlayer3D

QtObject {
	property alias data: root;

	id: root;
	property var gobigplay: false;
	property var gobigpause: false;
	property var dragging: false;
	property var ismoving: 1;
	property var buffering: 0;
	property var toolbar: 1;
	property var uiVisible: 1;
	property var autoloop: 0;
	property var automute: 0;
	property var autoplay: 0;
	property var allowfullscreen: 1;
	property var playlistmenu: false;
	property var subtitlemenu: false;
	property var totalSubs: 0;
	property var title: "";
    property var multiscreen: 0;
	property var timervolume: 0;
	property var glyphsLoaded: false;
	property var faFontLoaded: false;
	property var firsttime: 1;
	property var firstvolume: 1;
	property var cache: 0;
	property var lastTime: 0;
	property var cursorX: 0;
	property var cursorY: 0;
	property var contextmenu: false;
	property var curZoom: 3;
	property var defaultZoom: 3;
	property var curCrop: "Default";
	property var curAspect: "Default";
	property var mouseevents: 0;
	property var downloaded: 0;
	property var customLength: 0;
	property var newProgress: 0;
	property var openingText: "";
	property variant preventKey: [];
	property variant preventClicked: [];
	property variant aspectRatios: ["Default", "1:1", "4:3", "16:9", "16:10", "2.21:1", "2.35:1", "2.39:1", "5:4"];
	property variant crops: ["Default", "16:10", "16:9", "1.85:1", "2.21:1", "2.35:1", "2.39:1", "5:3", "4:3", "5:4", "1:1"];
	property variant zooms: [
		[0.25,	"0.25x"],
		[0.5,	"0.50x"],
		[0.5,	"0.75x"],
		[1,		"1.00x"],
		[1.25,	"1.25x"],
		[1.5,	"1.50x"],
		[1.75,	"1.75x"],
		[2,		"2.00x"]
	];
	property variant subPresets: [
		["0.05",	"X-Large"],
		["0.045",	"Large"],
		["0.037",	"Normal"],
		["0.03",	"Small"],
		["0.025",	"X-Small"]
	];
	property variant titleCache: [];
	property var debugPlaylist: false;
	property var selectedItem: 0;
	property var subSize: 2;
	property var subDelay: 0;
	property var subSelected: 0;
	property var audioDelay: 0;
	property var digitalzoom: 0;
	property var digiZoomClosed: false;
	property var pip: 0;
	property var pipClosed: false;
	property var refreshTime: false;
	property var refreshPlaylistItems: false;

	property var curSubtitleTrack: null;
	property var subtitleTracks;
	property var subtitlesBottomOffset: 50;
	property var subtitles3DOffset: 2;
	property var toolbarBottomMargin: 30;

	property var mode3D: VPlayer3D.Settings3D.c_MODE_2D;
	// property var mode3D: VPlayer3D.Settings3D.c_MODE_HSBS;
	// property var mode3D: VPlayer3D.Settings3D.c_MODE_HALFOU;



	property var brightness: 1;
	property var contrast: 1;
	property var gamma: 1;

}