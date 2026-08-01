import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import "root:/"

// Identity and uptime on the left, session actions on the right.
RowLayout {
    id: root

    readonly property var battery: UPower.displayDevice

    property string uptime: ""

    Layout.fillWidth: true
    Layout.topMargin: 2
    spacing: 10

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

    Rectangle {
        implicitWidth: 34
        implicitHeight: 34
        radius: height / 2
        color: Config.accent

        Text {
            anchors.centerIn: parent
            font.family: Config.uiFont
            font.pixelSize: 14
            font.weight: Font.DemiBold
            color: Config.accentText
            text: (Quickshell.env("USER") || "?").charAt(0).toUpperCase()
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 1

        Text {
            font.family: Config.uiFont
            font.pixelSize: Config.fontSub
            color: Config.text
            text: root.uptime === "" ? "" : `Up ${root.uptime}`
        }

        Text {
            visible: root.battery?.isLaptopBattery ?? false
            font.family: Config.uiFont
            font.pixelSize: Config.fontSub
            color: Config.textDim
            text: root.battery ? `${Math.round(root.battery.percentage * 100)}%` : ""
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
            ColorAnimation { duration: 130 }
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
