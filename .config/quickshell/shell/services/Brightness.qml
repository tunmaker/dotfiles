pragma Singleton

import Quickshell
import Quickshell.Io

// Backlight control via brightnessctl.
//
// Every invocation passes an argv array, never a shell string, so no value
// here is ever parsed by a shell.
//
// `available` is false on machines with no backlight class device (desktops).
// Consumers should hide their UI rather than show a dead control. External
// monitor brightness would require DDC/CI and membership of the i2c group,
// which this shell deliberately does not use.
Singleton {
    id: root

    readonly property bool available: _available
    readonly property real value: _value // 0..1

    property bool _available: false
    property real _value: 0

    function refresh(): void {
        probe.running = true;
    }

    function setFraction(fraction: real): void {
        if (!root._available)
            return;

        const percent = Math.max(1, Math.min(100, Math.round(fraction * 100)));
        root._value = percent / 100;

        setter.command = ["brightnessctl", "--class=backlight", "--machine-readable", "set", `${percent}%`];
        setter.running = true;
    }

    // brightnessctl -m prints: device,class,current,percent,max
    Process {
        id: probe

        command: ["brightnessctl", "--class=backlight", "--machine-readable", "info"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.trim().split("\n")[0] ?? "";
                const fields = line.split(",");

                if (fields.length >= 4 && fields[1] === "backlight") {
                    root._available = true;
                    root._value = (parseInt(fields[3]) || 0) / 100;
                } else {
                    root._available = false;
                }
            }
        }
    }

    Process {
        id: setter
    }
}
