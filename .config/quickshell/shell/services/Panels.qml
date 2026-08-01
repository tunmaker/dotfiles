pragma Singleton

import Quickshell

// Shared open/closed state for shell popups.
//
// Held globally rather than per-Bar so that IPC and Hyprland global shortcuts
// can drive it. Each popup additionally checks it is on the focused monitor, so
// a multi-monitor setup shows exactly one.
Singleton {
    id: root

    property bool quickSettingsOpen: false

    function toggleQuickSettings(): void {
        root.quickSettingsOpen = !root.quickSettingsOpen;
    }

    function closeAll(): void {
        root.quickSettingsOpen = false;
    }
}
