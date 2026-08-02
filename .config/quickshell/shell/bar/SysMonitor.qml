import QtQuick
import QtQuick.Layouts
import "root:/"
import "root:/services"

// Inline system stats: network traffic, CPU, temperature, RAM.
RowLayout {
    id: root

    spacing: 12

    component Stat: RowLayout {
        property string glyph: ""
        property string value: ""
        property bool hot: false

        spacing: 5

        Text {
            font.family: Config.iconFont
            font.pixelSize: 11
            color: parent.hot ? Config.urgent : Config.textDim
            text: parent.glyph
        }

        Text {
            font.family: Config.uiFont
            font.pixelSize: 12
            color: parent.hot ? Config.urgent : Config.textDim
            text: parent.value
        }
    }

    // Traffic: down then up, fixed-ish width so the bar does not jitter.
    RowLayout {
        spacing: 4

        Text {
            font.family: Config.iconFont
            font.pixelSize: 10
            color: Config.textDim
            text: Config.iconDown
        }

        Text {
            font.family: Config.uiFont
            font.pixelSize: 12
            color: Config.textDim
            text: SysStats.fmtRate(SysStats.rxRate)
        }

        Text {
            font.family: Config.iconFont
            font.pixelSize: 10
            color: Config.textDim
            text: Config.iconUp
        }

        Text {
            font.family: Config.uiFont
            font.pixelSize: 12
            color: Config.textDim
            text: SysStats.fmtRate(SysStats.txRate)
        }
    }

    Stat {
        glyph: Config.iconCpu
        value: `${Math.round(SysStats.cpuPercent)}%`
        hot: SysStats.cpuPercent >= 90
    }

    Stat {
        visible: SysStats.tempAvailable
        glyph: Config.iconTemp
        value: `${SysStats.tempC}°`
        hot: SysStats.tempC >= 85
    }

    Stat {
        glyph: Config.iconRam
        value: `${Math.round(SysStats.memPercent)}%`
        hot: SysStats.memPercent >= 90
    }
}
