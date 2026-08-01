import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "root:/"

PanelWindow {
    id: root

    required property var modelData

    screen: modelData
    color: "transparent"
    implicitHeight: Config.barHeight

    WlrLayershell.namespace: "qs-bar"
    WlrLayershell.layer: WlrLayer.Top

    anchors {
        top: true
        left: true
        right: true
    }

    Rectangle {
        anchors.fill: parent
        color: Config.bg

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Config.gap
            anchors.rightMargin: Config.gap
            spacing: Config.gap

            Workspaces {
                screenName: root.modelData.name
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            Clock { Layout.alignment: Qt.AlignVCenter }

            Item { Layout.fillWidth: true }

            Tray { Layout.alignment: Qt.AlignVCenter }

            StatusIcons { Layout.alignment: Qt.AlignVCenter }
        }
    }
}
