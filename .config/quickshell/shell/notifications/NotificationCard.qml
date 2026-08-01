import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "root:/"
import "root:/services"

// One notification, used both as a toast and as a row in the panel list.
Rectangle {
    id: root

    required property var notification
    property bool compact: false

    signal dismissed
    signal actionInvoked

    readonly property bool critical: notification?.urgency === NotificationUrgency.Critical

    Layout.fillWidth: true
    implicitHeight: body.implicitHeight + 20
    radius: Config.tileRadius
    color: hover.hovered ? Config.surfaceHover : Config.surface
    border.width: critical ? 1 : 0
    border.color: Config.urgent

    Behavior on color {
        ColorAnimation { duration: 120 }
    }

    HoverHandler {
        id: hover
    }

    ColumnLayout {
        id: body

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // Prefer the notification's own image, fall back to the app icon.
            Item {
                implicitWidth: 32
                implicitHeight: 32

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: root.critical ? Config.urgent : Config.surfaceHover
                    visible: !image.visible && !appIcon.visible

                    Text {
                        anchors.centerIn: parent
                        font.family: Config.uiFont
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: Config.text
                        text: (root.notification?.appName || "?").charAt(0).toUpperCase()
                    }
                }

                Image {
                    id: image

                    anchors.fill: parent
                    source: root.notification?.image ?? ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: source != "" && status === Image.Ready
                }

                IconImage {
                    id: appIcon

                    anchors.centerIn: parent
                    implicitSize: 24
                    source: root.notification?.appIcon ?? ""
                    visible: !image.visible && source != ""
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        Layout.fillWidth: true
                        font.family: Config.uiFont
                        font.pixelSize: Config.fontSub
                        color: root.critical ? Config.urgent : Config.textDim
                        text: root.notification?.appName ?? ""
                        elide: Text.ElideRight
                    }

                    Text {
                        font.family: Config.uiFont
                        font.pixelSize: 10
                        color: Config.textDim
                        text: Notifications.timeFor(root.notification?.id ?? -1)
                    }
                }

                Text {
                    Layout.fillWidth: true
                    font.family: Config.uiFont
                    font.pixelSize: Config.fontLabel
                    font.weight: Font.DemiBold
                    color: Config.text
                    text: root.notification?.summary ?? ""
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }
            }

            // Close affordance, revealed on hover.
            Rectangle {
                implicitWidth: 20
                implicitHeight: 20
                radius: 10
                opacity: hover.hovered ? 1 : 0
                color: closeMouse.containsMouse ? Config.urgent : Config.surfaceHover

                Behavior on opacity {
                    NumberAnimation { duration: 120 }
                }

                Text {
                    anchors.centerIn: parent
                    font.family: Config.uiFont
                    font.pixelSize: 12
                    color: Config.text
                    text: "×"
                }

                MouseArea {
                    id: closeMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.dismissed()
                }
            }
        }

        Text {
            Layout.fillWidth: true
            visible: text !== ""
            font.family: Config.uiFont
            font.pixelSize: Config.fontSub
            color: Config.textDim
            text: root.notification?.body ?? ""
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: root.compact ? 2 : 5
            textFormat: Text.PlainText
        }

        Flow {
            Layout.fillWidth: true
            Layout.topMargin: 2
            visible: (root.notification?.actions?.length ?? 0) > 0
            spacing: 6

            Repeater {
                model: root.notification?.actions ?? []

                delegate: Rectangle {
                    required property var modelData

                    implicitWidth: actionLabel.implicitWidth + 20
                    implicitHeight: 26
                    radius: 8
                    color: actionMouse.containsMouse ? Config.accent : Config.surfaceHover

                    Behavior on color {
                        ColorAnimation { duration: 110 }
                    }

                    Text {
                        id: actionLabel

                        anchors.centerIn: parent
                        font.family: Config.uiFont
                        font.pixelSize: Config.fontSub
                        color: Config.text
                        text: modelData.text
                    }

                    MouseArea {
                        id: actionMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            modelData.invoke();
                            root.actionInvoked();
                        }
                    }
                }
            }
        }
    }
}
