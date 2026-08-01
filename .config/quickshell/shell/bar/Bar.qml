import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "root:/"
import "root:/panel"
import "root:/notifications"
import "root:/launcher"
import "root:/services"

PanelWindow {
    id: root

    required property var modelData

    // Only the focused monitor shows the popup.
    readonly property bool panelOpen: Panels.quickSettingsOpen && Hyprland.focusedMonitor?.name === modelData.name

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

            // MouseArea wraps rather than nests inside StatusIcons: an anchored
            // item directly inside a layout is undefined behaviour in Qt Quick.
            MouseArea {
                Layout.alignment: Qt.AlignVCenter
                implicitWidth: statusIcons.implicitWidth
                implicitHeight: statusIcons.implicitHeight
                cursorShape: Qt.PointingHandCursor
                onClicked: Panels.toggleQuickSettings()

                StatusIcons {
                    id: statusIcons
                    anchors.fill: parent
                }
            }
        }
    }

    Launcher {
        launcherScreen: root.modelData
    }

    Popups {
        popupScreen: root.modelData
    }

    QuickSettings {
        panelScreen: root.modelData
        open: root.panelOpen
        onRequestClose: Panels.closeAll()
    }
}
