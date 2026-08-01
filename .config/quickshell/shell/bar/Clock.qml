import QtQuick
import Quickshell
import "root:/"

Text {
    id: root

    readonly property date now: clock.date

    font.family: Config.uiFont
    font.pixelSize: 13
    font.weight: Font.Medium
    color: Config.text
    text: Qt.formatDateTime(now, "HH:mm") + "  ·  " + Qt.formatDateTime(now, "ddd d")

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
