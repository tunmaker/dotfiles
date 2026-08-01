pragma Singleton

import QtQuick
import Quickshell

Singleton {
    // Metrics
    readonly property int barHeight: 36
    readonly property int gap: 8
    readonly property int radius: 11
    readonly property int tileRadius: 16
    readonly property int panelRadius: 22
    readonly property int panelWidth: 380
    readonly property int panelPadding: 14

    // Type
    readonly property string uiFont: "Adwaita Sans"
    readonly property string iconFont: "Symbols Nerd Font"
    readonly property int fontLabel: 13
    readonly property int fontSub: 11
    readonly property int fontIcon: 15

    // Palette
    readonly property color bg: "#14141b"
    readonly property color surface: "#1e1e28"
    readonly property color surfaceHover: "#2a2a36"
    readonly property color outline: "#32323f"
    readonly property color accent: "#3584e4"
    readonly property color accentHover: "#4a94ea"
    readonly property color accentText: "#ffffff"
    readonly property color text: "#eceff4"
    readonly property color textDim: "#98a0ae"
    readonly property color urgent: "#e05f65"

    // Nerd Font glyphs as escapes, so every other file stays plain ASCII.
    // Each codepoint is verified present in Symbols Nerd Font; check a new one
    // with:  fc-list ':charset=<hex>:family=Symbols Nerd Font'
    readonly property string iconBluetooth: "\uf294"
    readonly property string iconWifi: "\uf1eb"
    readonly property string iconEthernet: "\uf0e8"
    readonly property string iconDisconnected: "\uf127"
    readonly property string iconVolumeHigh: "\uf028"
    readonly property string iconVolumeLow: "\uf027"
    readonly property string iconVolumeMuted: "\uf026"
    readonly property string iconBrightness: "\uf185"
    readonly property string iconBattery: "\uf240"
    readonly property string iconClock: "\uf017"
    readonly property string iconLock: "\uf023"
    readonly property string iconLogout: "\uf08b"
    readonly property string iconPower: "\uf011"
    readonly property string iconPlay: "\uf04b"
    readonly property string iconPause: "\uf04c"
    readonly property string iconNext: "\uf051"
    readonly property string iconPrevious: "\uf048"
    readonly property string iconMusic: "\uf001"
    readonly property string iconPowerSaver: "\uf06c"
    readonly property string iconBalanced: "\uf0e7"
    readonly property string iconPerformance: "\uf135"
    readonly property string iconDisplay: "\uf26c"
    readonly property string iconChevron: "\uf054"
}
