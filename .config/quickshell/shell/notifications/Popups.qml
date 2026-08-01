import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "root:/"
import "root:/services"

// Transient toasts, top-right under the bar.
//
// Deliberately not focusable and click-through outside the cards, so toasts
// never steal focus from what you are doing.
PanelWindow {
    id: root

    required property var popupScreen

    screen: popupScreen
    color: "transparent"
    visible: Notifications.popups.length > 0
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "qs-notifications"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        right: true
    }

    margins {
        top: Config.barHeight + 10
        right: 8
    }

    implicitWidth: Config.panelWidth
    implicitHeight: Math.max(1, stack.implicitHeight)

    // Only the cards accept clicks; the gaps between them stay click-through.
    mask: Region {
        item: stack
    }

    ColumnLayout {
        id: stack

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 8

        Repeater {
            model: Notifications.popups

            delegate: NotificationCard {
                id: card

                required property var modelData

                notification: modelData
                compact: true

                // Slide in from the right.
                opacity: 0
                x: 40

                Component.onCompleted: {
                    card.opacity = 1;
                    card.x = 0;
                }

                Behavior on opacity {
                    NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                }
                Behavior on x {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }

                onDismissed: Notifications.dismiss(modelData)
                onActionInvoked: Notifications.hidePopup(modelData)

                // Auto-expire, paused while hovered so it can be read.
                Timer {
                    interval: Notifications.popupTimeout(card.modelData)
                    running: interval > 0 && !cardHover.hovered
                    onTriggered: Notifications.hidePopup(card.modelData)
                }

                HoverHandler {
                    id: cardHover
                }
            }
        }
    }
}
