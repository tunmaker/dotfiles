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
}
