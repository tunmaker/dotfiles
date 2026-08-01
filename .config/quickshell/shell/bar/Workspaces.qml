import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "root:/"

RowLayout {
    id: root

    required property string screenName

    spacing: 6

    Repeater {
        model: Hyprland.workspaces

        delegate: Rectangle {
            id: pill

            required property var modelData

            readonly property bool onThisScreen: modelData.monitor === null || modelData.monitor.name === root.screenName
            readonly property bool isActive: modelData.focused

            visible: onThisScreen
            implicitWidth: isActive ? 26 : 10
            implicitHeight: 10
            radius: height / 2
            color: modelData.urgent ? Config.urgent : isActive ? Config.accent : Config.surfaceHover

            Behavior on implicitWidth {
                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
            }
            Behavior on color {
                ColorAnimation { duration: 160 }
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                onClicked: pill.modelData.activate()
            }
        }
    }
}
