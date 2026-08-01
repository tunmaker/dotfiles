import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import "root:/"

// Battery / uptime on the left, session actions on the right.
RowLayout {
    id: root

    readonly property var battery: UPower.displayDevice

    property string uptime: ""

    Layout.fillWidth: true
    spacing: 12

    // /proc/uptime holds seconds since boot in field 1.
    FileView {
        id: uptimeFile

        path: "/proc/uptime"

        onLoaded: {
            const seconds = parseFloat(text().trim().split(" ")[0]);
            if (isNaN(seconds))
                return;

            const hours = Math.floor(seconds / 3600);
            const minutes = Math.floor((seconds % 3600) / 60);
            root.uptime = `${hours}h ${String(minutes).padStart(2, "0")}m`;
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: uptimeFile.reload()
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 2

        RowLayout {
            spacing: 6
            visible: root.battery?.isLaptopBattery ?? false

            Text {
                font.family: Config.iconFont
                font.pixelSize: 12
                color: Config.textDim
                text: Config.iconBattery
            }

            Text {
                font.family: Config.uiFont
                font.pixelSize: 11
                color: Config.text
                text: root.battery ? `${Math.round(root.battery.percentage * 100)}%` : ""
            }
        }

        RowLayout {
            spacing: 6

            Text {
                font.family: Config.iconFont
                font.pixelSize: 12
                color: Config.textDim
                text: Config.iconClock
            }

            Text {
                font.family: Config.uiFont
                font.pixelSize: 11
                color: Config.textDim
                text: root.uptime
            }
        }
    }

    component Action: Rectangle {
        id: action

        property string glyph: ""
        property color hoverColor: Config.surfaceHover

        signal activated

        implicitWidth: 34
        implicitHeight: 34
        radius: height / 2
        color: hover.containsMouse ? hoverColor : Config.surface

        Behavior on color {
            ColorAnimation { duration: 120 }
        }

        Text {
            anchors.centerIn: parent
            font.family: Config.iconFont
            font.pixelSize: 13
            color: Config.text
            text: action.glyph
        }

        MouseArea {
            id: hover

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: action.activated()
        }
    }

    Action {
        glyph: Config.iconLock
        onActivated: session.run(["hyprlock"])
    }

    Action {
        glyph: Config.iconLogout
        onActivated: session.run(["hyprctl", "dispatch", "hl.dsp.exit()"])
    }

    Action {
        glyph: Config.iconPower
        hoverColor: Config.urgent
        onActivated: session.run(["systemctl", "poweroff"])
    }

    // Session actions, each spawned with an explicit argv array.
    Process {
        id: session

        function run(argv: list<string>): void {
            session.command = argv;
            session.running = true;
        }
    }
}
