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
    property bool launcherOpen: false

    // Which picker inside the quick settings panel is expanded:
    // "" | "bluetooth" | "profile". Only one at a time.
    property string expandedSection: ""

    function toggleSection(name: string): void {
        root.expandedSection = root.expandedSection === name ? "" : name;
    }

    function toggleQuickSettings(): void {
        root.quickSettingsOpen = !root.quickSettingsOpen;
    }

    function toggleLauncher(): void {
        root.launcherOpen = !root.launcherOpen;
        if (root.launcherOpen)
            root.quickSettingsOpen = false;
    }

    function closeLauncher(): void {
        root.launcherOpen = false;
    }

    function closeAll(): void {
        root.launcherOpen = false;
        root.quickSettingsOpen = false;
        root.expandedSection = "";
    }
}
