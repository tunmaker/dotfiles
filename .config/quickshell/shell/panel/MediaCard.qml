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

    Layout.fillWidth: true
    visible: player !== null
    implicitHeight: visible ? 84 : 0
    radius: Config.radius
    color: Config.surface

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Rectangle {
            implicitWidth: 60
            implicitHeight: 60
            radius: 8
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
            spacing: 2

            Text {
                Layout.fillWidth: true
                font.family: Config.uiFont
                font.pixelSize: 12
                font.weight: Font.DemiBold
                color: Config.text
                text: root.player?.trackTitle || "Nothing playing"
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                font.family: Config.uiFont
                font.pixelSize: 11
                color: Config.textDim
                text: root.player?.trackArtist ?? ""
                elide: Text.ElideRight
            }

            RowLayout {
                Layout.topMargin: 4
                spacing: 16

                component Control: Text {
                    font.family: Config.iconFont
                    font.pixelSize: 13
                    color: Config.text
                    opacity: enabled ? 1 : 0.35
                }

                Control {
                    text: Config.iconPrevious
                    enabled: root.player?.canGoPrevious ?? false
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6
                        cursorShape: Qt.PointingHandCursor
                        enabled: parent.enabled
                        onClicked: root.player.previous()
                    }
                }

                Control {
                    text: root.player?.isPlaying ? Config.iconPause : Config.iconPlay
                    enabled: root.player?.canTogglePlaying ?? false
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6
                        cursorShape: Qt.PointingHandCursor
                        enabled: parent.enabled
                        onClicked: root.player.togglePlaying()
                    }
                }

                Control {
                    text: Config.iconNext
                    enabled: root.player?.canGoNext ?? false
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6
                        cursorShape: Qt.PointingHandCursor
                        enabled: parent.enabled
                        onClicked: root.player.next()
                    }
                }
            }
        }
    }
}
