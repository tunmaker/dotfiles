import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/"
import "root:/services"
import "root:/notifications"

// Notification history inside the quick settings panel.
ColumnLayout {
    id: root

    // Cap the list height so the panel cannot outgrow the screen.
    property int maxHeight: 260

    Layout.fillWidth: true
    spacing: 6

    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: 4
        Layout.rightMargin: 4
        spacing: 6

        Text {
            font.family: Config.iconFont
            font.pixelSize: 12
            color: Config.textDim
            text: Config.iconBell
        }

        Text {
            Layout.fillWidth: true
            font.family: Config.uiFont
            font.pixelSize: Config.fontSub
            font.weight: Font.DemiBold
            color: Config.text
            text: Notifications.count === 0 ? "Notifications" : `Notifications (${Notifications.count})`
        }

        Text {
            visible: Notifications.count > 0
            font.family: Config.uiFont
            font.pixelSize: Config.fontSub
            color: clearMouse.containsMouse ? Config.urgent : Config.textDim
            text: "Clear"

            MouseArea {
                id: clearMouse

                anchors.fill: parent
                anchors.margins: -6
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Notifications.clearAll()
            }
        }
    }

    Text {
        Layout.fillWidth: true
        Layout.leftMargin: 4
        Layout.bottomMargin: 4
        visible: Notifications.count === 0
        font.family: Config.uiFont
        font.pixelSize: Config.fontSub
        color: Config.textDim
        text: "No notifications"
    }

    ListView {
        Layout.fillWidth: true
        visible: Notifications.count > 0
        implicitHeight: Math.min(contentHeight, root.maxHeight)
        clip: true
        spacing: 6
        boundsBehavior: Flickable.StopAtBounds
        model: Notifications.list

        delegate: NotificationCard {
            required property var modelData

            width: ListView.view.width
            notification: modelData
            compact: true

            onDismissed: Notifications.dismiss(modelData)
        }
    }
}
