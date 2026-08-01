pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// Freedesktop notification server.
//
// Owns org.freedesktop.Notifications, so no other daemon (dunst, mako) may run
// at the same time.
//
// Two views of the same data:
//   list   - everything kept, newest first, shown in the quick settings panel
//   popups - the subset currently on screen as toasts
Singleton {
    id: root

    readonly property var list: [...server.trackedNotifications.values].reverse()
    property var popups: []

    readonly property int count: server.trackedNotifications.values.length
    readonly property bool hasCritical: root.list.some(n => n.urgency === NotificationUrgency.Critical)

    // Arrival times, keyed by notification id. Notifications carry no timestamp
    // of their own, and this is cheaper than wrapping every one in an object.
    property var arrivals: ({})

    readonly property int defaultTimeout: 5000
    readonly property int lowTimeout: 3000

    function timeFor(id: int): string {
        const arrived = root.arrivals[id];
        if (arrived === undefined)
            return "";

        const seconds = Math.floor((Date.now() - arrived) / 1000);
        if (seconds < 60)
            return "now";
        if (seconds < 3600)
            return `${Math.floor(seconds / 60)}m ago`;
        return `${Math.floor(seconds / 3600)}h ago`;
    }

    function popupTimeout(notification): int {
        // Critical notifications stay until acted on.
        if (notification.urgency === NotificationUrgency.Critical)
            return 0;
        if (notification.expireTimeout > 0)
            return notification.expireTimeout;
        return notification.urgency === NotificationUrgency.Low ? root.lowTimeout : root.defaultTimeout;
    }

    function hidePopup(notification): void {
        root.popups = root.popups.filter(candidate => candidate !== notification);
    }

    function dismiss(notification): void {
        root.hidePopup(notification);
        notification.dismiss();
    }

    function clearAll(): void {
        root.popups = [];
        for (const notification of [...server.trackedNotifications.values])
            notification.dismiss();
    }

    function clearPopups(): void {
        root.popups = [];
    }

    NotificationServer {
        id: server

        // Survive a config reload without dropping the user's notifications.
        keepOnReload: true

        actionsSupported: true
        actionIconsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: notification => {
            // Without this the notification is discarded as soon as the handler
            // returns, and never reaches trackedNotifications.
            notification.tracked = true;

            root.arrivals[notification.id] = Date.now();

            // `transient` means the sender only wants a toast, not a history entry.
            root.popups = [...root.popups, notification];

            notification.closed.connect(() => {
                root.hidePopup(notification);
                delete root.arrivals[notification.id];
            });
        }
    }
}
