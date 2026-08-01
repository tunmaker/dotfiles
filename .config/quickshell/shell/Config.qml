pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property int barHeight: 36
    readonly property int gap: 8
    readonly property int radius: 11

    readonly property string uiFont: "Adwaita Sans"
    readonly property string iconFont: "Symbols Nerd Font"

    readonly property color bg: "#16161d"
    readonly property color surface: "#22222c"
    readonly property color surfaceHover: "#2f2f3b"
    readonly property color accent: "#3584e4"
    readonly property color text: "#eceff4"
    readonly property color textDim: "#9aa0ac"
    readonly property color urgent: "#e05f65"

    // Nerd Font glyphs as escapes, so this source stays plain ASCII.
    // Every codepoint is verified present in Symbols Nerd Font; check a new one
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
    readonly property string iconDisplay: "\uf26c"
}
