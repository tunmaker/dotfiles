import QtQuick
import QtQuick.Layouts
import "root:/"

// Icon + horizontal fill slider. Emits `moved` with a 0..1 fraction.
RowLayout {
    id: root

    property string glyph: ""
    property real value: 0

    signal moved(real fraction)

    Layout.fillWidth: true
    spacing: 12

    Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        radius: height / 2
        color: Config.surface

        Text {
            anchors.centerIn: parent
            font.family: Config.iconFont
            font.pixelSize: 13
            color: Config.textDim
            text: root.glyph
        }
    }

    Rectangle {
        id: track

        Layout.fillWidth: true
        implicitHeight: 12
        radius: height / 2
        color: Config.surface

        Rectangle {
            id: fill

            width: Math.max(height, track.width * Math.max(0, Math.min(1, root.value)))
            height: parent.height
            radius: height / 2
            color: drag.pressed ? Config.accentHover : Config.accent

            Behavior on width {
                enabled: !drag.pressed
                NumberAnimation { duration: 110; easing.type: Easing.OutCubic }
            }
        }

        MouseArea {
            id: drag

            anchors.fill: parent
            anchors.margins: -8
            cursorShape: Qt.PointingHandCursor

            function apply(x: real): void {
                root.moved(Math.max(0, Math.min(1, (x - 8) / track.width)));
            }

            onPressed: event => apply(event.x)
            onPositionChanged: event => {
                if (pressed)
                    apply(event.x);
            }
        }
    }

    Text {
        Layout.preferredWidth: 34
        horizontalAlignment: Text.AlignRight
        font.family: Config.uiFont
        font.pixelSize: Config.fontSub
        color: Config.textDim
        text: `${Math.round(root.value * 100)}%`
    }
}
