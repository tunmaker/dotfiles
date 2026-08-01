import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "root:/"

RowLayout {
    id: root

    spacing: 4

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: entry

            required property var modelData

            implicitWidth: 22
            implicitHeight: 22

            IconImage {
                anchors.centerIn: parent
                implicitSize: 16
                source: entry.modelData.icon
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor

                onClicked: event => {
                    if (event.button === Qt.LeftButton && !entry.modelData.onlyMenu) {
                        entry.modelData.activate();
                    } else if (entry.modelData.hasMenu) {
                        menuAnchor.open();
                    }
                }
            }

            // PopupAnchor tracks the item's window itself; binding anchor.window to
            // QsWindow.window re-evaluates during teardown and segfaults on reload.
            QsMenuAnchor {
                id: menuAnchor
                menu: entry.modelData.menu
                anchor.item: entry
                anchor.edges: Edges.Bottom
            }
        }
    }
}
