import QtQuick 2.1

Rectangle {
	property alias icons: glyphs
	property alias iconsFa: fontawesome
	property alias defaultFont: defaultFont
	property alias secondaryFont: defaultFont2

	FontLoader {
		id: glyphs
		source: ""
	}
	// onStatusChanged does not seem to work, so we add a timer to find out when the glyphicons have loaded
	Timer {
		interval: 0; running:  glyphs.source != "" ? glyphs.status == FontLoader.Ready ? true : false : false; repeat: false
		onTriggered: { settings.glyphsLoaded = true; }
	}

	FontLoader {
		id: fontawesome
		source: ""
	}

	// onStatusChanged does not seem to work, so we add a timer to find out when the glyphicons have loaded
	Timer {
		interval: 0; running:  fontawesome.source != "" ? fontawesome.status == FontLoader.Ready ? true : false : false; repeat: false
		onTriggered: { settings.faFontLoaded = true; }
	}
	// End onStatusChanged does not seem to work, so we add a timer to find out when the glyphicons have loaded

	FontLoader {
		id: defaultFont
		source: ""
	}
	FontLoader {
		id: defaultFont2
		source: ""
	}
}