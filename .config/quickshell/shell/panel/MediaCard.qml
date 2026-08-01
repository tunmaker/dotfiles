import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "root:/"

// MPRIS media card. Hides itself when no player is present.
Rectangle {
    id: root

    readonly property var player: {
        const players = Mpris.players?.values ?? [];
        return players.find(candidate => candidate.isPlaying) ?? players[0] ?? null;
    }

    readonly property bool hasProgress: (player?.lengthSupported ?? false) && (player?.length ?? 0) > 0

    // Tracked locally and re-synced from the player, because MPRIS position is
    // not pushed continuously by every client.
    property real elapsed: 0

    function formatTime(seconds: real): string {
        if (!isFinite(seconds) || seconds < 0)
            return "0:00";
        const total = Math.floor(seconds);
        return `${Math.floor(total / 60)}:${String(total % 60).padStart(2, "0")}`;
    }

    Layout.fillWidth: true
    visible: player !== null
    implicitHeight: visible ? content.implicitHeight + 24 : 0
    radius: Config.tileRadius
    color: Config.surface

    Connections {
        target: root.player

        function onPositionChanged(): void {
            root.elapsed = root.player?.position ?? 0;
        }

        function onTrackTitleChanged(): void {
            root.elapsed = 0;
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.visible && (root.player?.isPlaying ?? false)
        onTriggered: {
            const reported = root.player?.position ?? 0;
            // Prefer the client's own position when it moves; otherwise tick.
            root.elapsed = Math.abs(reported - root.elapsed) > 1.5 ? reported : root.elapsed + 1;
        }
    }

    ColumnLayout {
        id: content

        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                implicitWidth: 56
                implicitHeight: 56
                radius: 10
                color: Config.surfaceHover
                clip: true

                Image {
                    anchors.fill: parent
                    source: root.player?.trackArtUrl ?? ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: status === Image.Ready
                }

                Text {
                    anchors.centerIn: parent
                    visible: !root.player?.trackArtUrl
                    font.family: Config.iconFont
                    font.pixelSize: 18
                    color: Config.textDim
                    text: Config.iconMusic
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                Text {
                    Layout.fillWidth: true
                    font.family: Config.uiFont
                    font.pixelSize: Config.fontLabel
                    font.weight: Font.DemiBold
                    color: Config.text
                    text: root.player?.trackTitle || "Nothing playing"
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    font.family: Config.uiFont
                    font.pixelSize: Config.fontSub
                    color: Config.textDim
                    text: root.player?.trackArtist ?? ""
                    elide: Text.ElideRight
                }
            }

            component Control: Text {
                font.family: Config.iconFont
                color: Config.text
                opacity: enabled ? 1 : 0.3
            }

            Control {
                font.pixelSize: 12
                text: Config.iconPrevious
                enabled: root.player?.canGoPrevious ?? false
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -7
                    cursorShape: Qt.PointingHandCursor
                    enabled: parent.enabled
                    onClicked: root.player.previous()
                }
            }

            Control {
                font.pixelSize: 15
                text: root.player?.isPlaying ? Config.iconPause : Config.iconPlay
                enabled: root.player?.canTogglePlaying ?? false
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -7
                    cursorShape: Qt.PointingHandCursor
                    enabled: parent.enabled
                    onClicked: root.player.togglePlaying()
                }
            }

            Control {
                font.pixelSize: 12
                text: Config.iconNext
                enabled: root.player?.canGoNext ?? false
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -7
                    cursorShape: Qt.PointingHandCursor
                    enabled: parent.enabled
                    onClicked: root.player.next()
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            visible: root.hasProgress
            spacing: 8

            Text {
                font.family: Config.uiFont
                font.pixelSize: 10
                color: Config.textDim
                text: root.formatTime(root.elapsed)
            }

            Rectangle {
                id: progressTrack

                Layout.fillWidth: true
                implicitHeight: 4
                radius: 2
                color: Config.surfaceHover

                Rectangle {
                    width: progressTrack.width * Math.max(0, Math.min(1, root.elapsed / (root.player?.length || 1)))
                    height: parent.height
                    radius: parent.radius
                    color: Config.accent
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    cursorShape: Qt.PointingHandCursor
                    enabled: root.player?.canSeek ?? false
                    onClicked: event => {
                        const target = (event.x - 6) / progressTrack.width * (root.player?.length ?? 0);
                        root.player.position = Math.max(0, target);
                        root.elapsed = Math.max(0, target);
                    }
                }
            }

            Text {
                font.family: Config.uiFont
                font.pixelSize: 10
                color: Config.textDim
                text: root.formatTime(root.player?.length ?? 0)
            }
        }
    }
}
