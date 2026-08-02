import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "root:/"
import "root:/panel"
import "root:/services"
import "root:/notifications"
import "root:/launcher"

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

        // The clock is anchored to the window centre rather than laid out
        // between the side clusters, so it stays centred on the screen no
        // matter how the clusters differ in width.
        RowLayout {
            anchors.left: parent.left
            anchors.leftMargin: Config.gap
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14

            Workspaces { screenName: root.modelData.name }
        }

        Clock {
            anchors.centerIn: parent
        }

        RowLayout {
            anchors.right: parent.right
            anchors.rightMargin: Config.gap
            anchors.verticalCenter: parent.verticalCenter
            spacing: Config.gap

            SysMonitor {}

            Tray {}

            // MouseArea wraps rather than nests inside StatusIcons: an anchored
            // item directly inside a layout is undefined behaviour in Qt Quick.
            MouseArea {
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
