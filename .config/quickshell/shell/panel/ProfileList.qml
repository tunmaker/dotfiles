import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import "root:/"

// Direct power-profile selection, rather than cycling through the tile.
ColumnLayout {
    id: root

    readonly property var entries: {
        const list = [
            {
                profile: PowerProfile.PowerSaver,
                name: "Power Saver",
                hint: "Reduced performance, lower power",
                glyph: Config.iconPowerSaver
            },
            {
                profile: PowerProfile.Balanced,
                name: "Balanced",
                hint: "Default",
                glyph: Config.iconBalanced
            }
        ];

        if (PowerProfiles.hasPerformanceProfile) {
            list.push({
                profile: PowerProfile.Performance,
                name: "Performance",
                hint: "Higher performance, more power",
                glyph: Config.iconPerformance
            });
        }

        return list;
    }

    Layout.fillWidth: true
    spacing: 2

    Repeater {
        model: root.entries

        delegate: ListRow {
            required property var modelData

            glyph: modelData.glyph
            label: modelData.name
            sublabel: modelData.hint
            selected: PowerProfiles.profile === modelData.profile

            onActivated: PowerProfiles.profile = modelData.profile
        }
    }

    // Shown when the firmware or driver is throttling despite the chosen profile.
    Text {
        Layout.fillWidth: true
        Layout.leftMargin: 10
        Layout.topMargin: 2
        visible: PowerProfiles.degradationReason !== PerformanceDegradationReason.None
        font.family: Config.uiFont
        font.pixelSize: 10
        color: Config.urgent
        text: "Performance is currently degraded"
        wrapMode: Text.Wrap
    }
}
