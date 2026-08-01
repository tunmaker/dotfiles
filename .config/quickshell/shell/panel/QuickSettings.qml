import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import "root:/"
import "root:/services"

PanelWindow {
    id: root

    required property var panelScreen
    property bool open: false

    signal requestClose

    screen: panelScreen
    visible: open
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "qs-quicksettings"
    WlrLayershell.layer: WlrLayer.Overlay
    // The focus grab needs a focusable surface to hold onto; without this the
    // grab activates and clears immediately, closing the panel on its own.
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    anchors {
        top: true
        right: true
    }

    margins {
        top: Config.barHeight + 10
        right: 8
    }

    implicitWidth: Config.panelWidth
    implicitHeight: layout.implicitHeight + Config.panelPadding * 2

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var sinkAudio: Pipewire.defaultAudioSink?.audio ?? null

    // Desktops often have no wifi hardware at all; showing a dead "Wi-Fi: Off"
    // tile is misleading, so the tile is omitted entirely in that case.
    readonly property bool hasWifi: (Networking.devices?.values ?? []).some(device => device.type === DeviceType.Wifi)

    readonly property string btSublabel: {
        if (!(root.adapter?.enabled ?? false))
            return "Off";
        const connected = (root.adapter?.devices?.values ?? []).filter(device => device.connected);
        if (connected.length === 0)
            return "No devices";
        return connected.length === 1 ? connected[0].name : `${connected.length} devices`;
    }

    readonly property string wifiSublabel: {
        if (!Networking.wifiEnabled)
            return "Off";
        for (const device of Networking.devices?.values ?? []) {
            if (device.type !== DeviceType.Wifi)
                continue;
            for (const network of device.networks?.values ?? []) {
                if (network.connected)
                    return network.name;
            }
        }
        return "Not connected";
    }

    readonly property string profileLabel: {
        switch (PowerProfiles.profile) {
        case PowerProfile.PowerSaver:
            return "Power Saver";
        case PowerProfile.Performance:
            return "Performance";
        default:
            return "Balanced";
        }
    }

    // Close when focus moves elsewhere, so a click outside dismisses the panel.
    // Activation is deferred by one tick so the surface is mapped first,
    // otherwise the grab clears before it can take hold.
    HyprlandFocusGrab {
        id: grab

        windows: [root]
        onCleared: root.requestClose()
    }

    Timer {
        id: grabDelay

        interval: 120
        onTriggered: grab.active = true
    }

    onOpenChanged: {
        if (root.open) {
            grabDelay.restart();
        } else {
            grabDelay.stop();
            grab.active = false;
        }
    }

    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    Rectangle {
        anchors.fill: parent
        radius: Config.panelRadius
        color: Config.bg
        border.width: 1
        border.color: Config.outline

        ColumnLayout {
            id: layout

            anchors.fill: parent
            anchors.margins: Config.panelPadding
            spacing: 12

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 10
                rowSpacing: 10

                Toggle {
                    glyph: Config.iconBluetooth
                    label: "Bluetooth"
                    sublabel: root.btSublabel
                    active: root.adapter?.enabled ?? false
                    onToggled: {
                        if (root.adapter)
                            root.adapter.enabled = !root.adapter.enabled;
                    }
                }

                Toggle {
                    visible: root.hasWifi
                    glyph: Config.iconWifi
                    label: "Wi-Fi"
                    sublabel: root.wifiSublabel
                    active: Networking.wifiEnabled
                    onToggled: Networking.wifiEnabled = !Networking.wifiEnabled
                }

                Toggle {
                    glyph: {
                        switch (PowerProfiles.profile) {
                        case PowerProfile.PowerSaver:
                            return Config.iconPowerSaver;
                        case PowerProfile.Performance:
                            return Config.iconPerformance;
                        default:
                            return Config.iconBalanced;
                        }
                    }
                    label: root.profileLabel
                    sublabel: "Power profile"
                    active: PowerProfiles.profile !== PowerProfile.Balanced
                    onToggled: {
                        // Balanced -> Power Saver -> Performance (when supported) -> Balanced
                        if (PowerProfiles.profile === PowerProfile.Balanced)
                            PowerProfiles.profile = PowerProfile.PowerSaver;
                        else if (PowerProfiles.profile === PowerProfile.PowerSaver && PowerProfiles.hasPerformanceProfile)
                            PowerProfiles.profile = PowerProfile.Performance;
                        else
                            PowerProfiles.profile = PowerProfile.Balanced;
                    }
                }

                Toggle {
                    glyph: root.sinkAudio?.muted ? Config.iconVolumeMuted : Config.iconVolumeHigh
                    label: root.sinkAudio?.muted ? "Muted" : "Unmuted"
                    sublabel: Pipewire.defaultAudioSink?.description ?? ""
                    active: root.sinkAudio?.muted ?? false
                    onToggled: {
                        if (root.sinkAudio)
                            root.sinkAudio.muted = !root.sinkAudio.muted;
                    }
                }
            }

            SliderRow {
                glyph: Config.iconVolumeHigh
                value: root.sinkAudio?.volume ?? 0
                onMoved: fraction => {
                    if (root.sinkAudio)
                        root.sinkAudio.volume = fraction;
                }
            }

            // Hidden on machines with no backlight device.
            SliderRow {
                visible: Brightness.available
                glyph: Config.iconBrightness
                value: Brightness.value
                onMoved: fraction => Brightness.setFraction(fraction)
            }

            MediaCard {}

            UserRow {}
        }
    }
}
