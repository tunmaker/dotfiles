import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Networking
import Quickshell.Bluetooth
import "root:/"

RowLayout {
    id: root

    spacing: 10

    readonly property var sinkAudio: Pipewire.defaultAudioSink?.audio ?? null
    readonly property var battery: UPower.displayDevice

    // Active link: prefer a connected wired device, else a connected wifi device.
    readonly property var netDevice: {
        const devices = Networking.devices?.values ?? [];
        let wired = null;
        let wifi = null;
        for (const device of devices) {
            if (!device.connected)
                continue;
            if (device.type === DeviceType.Wired)
                wired = device;
            else if (device.type === DeviceType.Wifi)
                wifi = device;
        }
        return wired ?? wifi ?? null;
    }

    // Keep the default sink bound so its audio properties stay live.
    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    component Glyph: Text {
        font.family: Config.iconFont
        font.pixelSize: 13
        color: Config.textDim
        verticalAlignment: Text.AlignVCenter
    }

    Glyph {
        visible: Bluetooth.defaultAdapter?.enabled ?? false
        text: ""
        color: Config.accent
    }

    Glyph {
        text: {
            if (root.netDevice === null)
                return "";
            return root.netDevice.type === DeviceType.Wired ? "" : "";
        }
        color: root.netDevice === null ? Config.urgent : Config.textDim
    }

    RowLayout {
        spacing: 4

        Glyph {
            text: {
                if (!root.sinkAudio || root.sinkAudio.muted)
                    return "";
                return root.sinkAudio.volume > 0.5 ? "" : "";
            }
            color: root.sinkAudio?.muted ? Config.urgent : Config.textDim
        }

        Text {
            visible: root.sinkAudio !== null
            font.family: Config.uiFont
            font.pixelSize: 12
            color: Config.textDim
            text: root.sinkAudio ? Math.round(root.sinkAudio.volume * 100) + "%" : ""
        }
    }

    RowLayout {
        spacing: 4
        visible: root.battery?.isLaptopBattery ?? false

        Glyph {
            text: ""
            color: (root.battery?.percentage ?? 1) <= 0.15 ? Config.urgent : Config.textDim
        }

        Text {
            font.family: Config.uiFont
            font.pixelSize: 12
            color: Config.textDim
            text: root.battery ? Math.round(root.battery.percentage * 100) + "%" : ""
        }
    }
}
