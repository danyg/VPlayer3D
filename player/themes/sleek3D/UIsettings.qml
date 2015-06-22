import QtQuick 2.1

import "VPlayer3D" as VPlayer3D

Rectangle {

	property var done: false;

	property variant variables: {

		'settings': {
			'iconFont': "fonts/glyphicons.ttf",
			'faIconFont': "fonts/fontawesome-webfont.ttf",
			// 'defaultFont': "http://fonts.gstatic.com/s/sourcesanspro/v9/toadOcfmlt9b38dHJxOBGNNE-IuDiR70wI4zXaKqWCM.ttf",
			// 'secondaryFont': "http://fonts.gstatic.com/s/opensans/v10/k3k702ZOKiLJc3WVjuplzInF5uFdDttMLvmWuJdhhgs.ttf",
			'defaultFont': "fonts/sourcesanspro.ttf",
			'secondaryFont': "fonts/opensans.ttf",

			'toolbar': {
				'borderVisible': true,
				'buttonWidth': 59,
				'buttonMuteWidth': 40,
				'opacity': 0.9,

				// this is the space between the time/length (00:00/00:00) in the toolbar and the mute button
				'timeMargin': 11
			},
			'caching': false, // If cache progress bar is visible or not
			'titleBar': "fullscreen", // When should the title bar be visible, possible values are: "fullscreen", "minimized", "both", "none"
			'buttonGlow': true // if button icons should glow when hovered
		},

		'icon': {

			// Playback Button Icons
			'prev': "\ue80a",
			'next': "\ue809",
			'play': "\ue87f",
			'pause': "\ue880",
			'replay': "\ue8a7",

			// Audio Related Button Icons
			'mute': "\ue877",
			'volume': {
				'low': "\ue876",
				'medium': "\ue875",
				'high': "\ue878"
			},

			// Playlist Button Icon
			'playlist': "\ue833",

			// Subtitle Menu Button Icon
			'subtitles': "\ue83a",

			// Fullscreen Button Icons
			'minimize': "\ue805",
			'maximize': "\ue804",

			// Big Play/Pause Icons (appear in the center of the screen when Toggle Pause)
			'bigPlay': "\ue82d",
			'bigPause': "\ue82e",

			// Appears when hovering over progress bar
			'timeBubble': {
				'big': "\ue802",
				'small': "\ue803"
			},

			// Close Playlist Button
			'closePlaylist': "\ue896",

			// Settings Button (for advanced playlist feature)
			'settings': "\ue801",

			// Picture in Picture Button (playlist menu)
			'pip': "\ue800",

			// contextmenu
			'selected': '\ue207'

		},


		'iconFa': {
			// contextmenu
			'selected': '\uf00c',

			'prev': "\uf049",
			'next': "\uf050",
			'play': "\uf04b",
			'pause': "\uf04c",
			'replay': "\uf021",

			'poweroff': "\uf011",
			'questionmark': "\uf128",
			'close': "\uf00d",
			'menu': "\uf0c9",
			'config': "\uf1de",

			'spinner': "\uf110",

			'toggleoff': "\uf204",
			'toggleon': "\uf205",

			'warning': "\uf071",
			'clock': "\uf017",

			'mute': "\uf026",
			'volume': {
				'low': "\uf026",
				'medium': "\uf027",
				'high': "\uf028"
			},

			'search': '\uf002',

			'contrast': '\uf042',
			'bright': '\uf185',
			'gamma': '\uf1fe'

		},


		'colors': {

			// Video Background Color
			'videoBackground': "#000000",

			// UI Background Color (toolbar, playlist menu)
			'base': "#050529",
			'basefont': "#e5e5e5",
			// 'base': "#00c0ff",
			// 'basefont': "#add8e6",

			'background': "#020212",
			'selected': "#0A0A42",

			// Default Font Colors
			'font': "#ffffff",
			'fontShadow': "#000000",

			// Default Font Colors
			'subtitles': "#ffff00",
			'subtitlesShadow': "#222222",

			// Top Title Bar Colors
			'titleBar': {
				'background': "#000000",
				'font': "#cbcbcb"
			},

			// Progress Bar Colors
			'progress': {
				'background': "#050522",
				'viewed': "#08758F",
				'position': "#e5e5e5",
				'cache': "#3e3e3e"
			},

			// Appears when hovering over progress bar
			'timeBubble': {
				'background': "#000000",
				'border': "#898989",
				'font': "#ffffff"
			},

			// Toolbar colors
			'toolbar': {
				'border': "#262626",
				'button': "#7b7b7b",
				'buttonHover': "#ffffff",

				// Color for Current Time Text in Toolbar (first part of "00:00 / 00:00")
				'currentTime': "#9a9a9a",

				// Color for Total Length Time Text in Toolbar (second part of "00:00 / 00:00")
				'lengthTime': "#9a9a9a"
			},

			// Big Play/Pause Icon (appears in center of screen when Toggle Pause)
			'bigIcon': "#ffffff",
			'bigIconBackground': "#1c1c1c",

			// Playlist Menu Colors
			'playlistMenu': {
				'background': "#292929",
				'scroller': "#696969",
				'drag': "#e5e5e5",
				'header': "#1C1C1C",
				'headerFont': "#d5d5d5",

				// Playlist Menu Close Button
				'close': "#c0c0c0",
				'closeHover': "#eaeaea",

				// Playlist Menu Close Button Background
				'closeBackground': "#1C1C1C",
				'closeBackgroundHover': "#151515"
			},

			'volumeHeat': {
				'background': "#0A0A42",
				'color': "#1A1A82"
			}

		}
	}
	// hack to force property notify for .skin()
	Component.onCompleted: { ui = variables; done = true; }
	Timer {
         interval: 0; running: done === true && VPlayer3D.Core.getComponent('toolbarButton_mutebut').get('width') != ui.settings.toolbar.buttonMuteWidth ? true : false; repeat: false
         onTriggered: { ui = ui }
    }
	Timer {
         interval: 0; running: done === true && VPlayer3D.Core.getComponent('toolbarButton_prevBut').get('width') != buttonWidth ? true : false; repeat: false
         onTriggered: { buttonWidth = buttonWidth }
    }
	// end hack to force property notify for .skin()
}