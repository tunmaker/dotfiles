//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "bar"
import "services"

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Bar {}
    }

    // qs -c shell ipc call panel toggle
    IpcHandler {
        target: "panel"

        function toggle(): void {
            Panels.toggleQuickSettings();
        }

        function close(): void {
            Panels.closeAll();
        }

        // name: "bluetooth" | "profile" | "" to collapse
        function expand(name: string): void {
            Panels.expandedSection = name;
        }
    }

    // qs -c shell ipc call notifications clear
    IpcHandler {
        target: "notifications"

        function clear(): void {
            Notifications.clearAll();
        }

        function dismissPopups(): void {
            Notifications.clearPopups();
        }

        function count(): int {
            return Notifications.count;
        }
    }

    // Bindable from Hyprland with hl.dsp.global("qs:quicksettings")
    GlobalShortcut {
        appid: "qs"
        name: "quicksettings"
        description: "Toggle quick settings panel"
        onPressed: Panels.toggleQuickSettings()
    }
}
