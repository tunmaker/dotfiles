import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import "root:/"

// Paired and nearby Bluetooth devices. Tapping connects or disconnects.
ColumnLayout {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool blocked: (root.adapter?.state ?? -1) === BluetoothAdapterState.Blocked
    readonly property bool usable: (root.adapter?.enabled ?? false) && !root.blocked

    // Connected first, then paired, then the rest; each group alphabetical.
    readonly property var entries: {
        const devices = (root.adapter?.devices?.values ?? []).slice();
        return devices.sort((a, b) => {
            const rank = device => device.connected ? 0 : device.paired ? 1 : 2;
            const delta = rank(a) - rank(b);
            return delta !== 0 ? delta : (a.name ?? "").localeCompare(b.name ?? "");
        });
    }

    Layout.fillWidth: true
    spacing: 2

    Text {
        Layout.fillWidth: true
        Layout.leftMargin: 10
        Layout.bottomMargin: 2
        visible: !root.usable || root.entries.length === 0
        font.family: Config.uiFont
        font.pixelSize: Config.fontSub
        color: Config.textDim
        text: {
            if (!root.adapter)
                return "No Bluetooth adapter";
            if (root.blocked)
                return "Bluetooth is blocked (rfkill unblock bluetooth)";
            if (!root.adapter.enabled)
                return "Bluetooth is off";
            return root.adapter.discovering ? "Scanning..." : "No devices found";
        }
    }

    Repeater {
        model: root.entries

        delegate: ListRow {
            required property var modelData

            glyph: Config.iconBluetooth
            label: modelData.name || modelData.deviceName || "Unknown device"
            selected: modelData.connected
            interactive: root.usable
            busy: modelData.state === BluetoothDeviceState.Connecting || modelData.state === BluetoothDeviceState.Disconnecting || modelData.pairing

            sublabel: {
                switch (modelData.state) {
                case BluetoothDeviceState.Connecting:
                    return "Connecting...";
                case BluetoothDeviceState.Disconnecting:
                    return "Disconnecting...";
                case BluetoothDeviceState.Connected:
                    return "Connected";
                default:
                    return modelData.paired ? "Paired" : "Available";
                }
            }

            trailing: modelData.batteryAvailable ? `${Math.round(modelData.battery * 100)}%` : ""

            onActivated: {
                if (modelData.connected)
                    modelData.disconnect();
                else
                    modelData.connect();
            }
        }
    }
}
