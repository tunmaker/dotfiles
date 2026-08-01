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
    spacing: 10

    Text {
        font.family: Config.iconFont
        font.pixelSize: 14
        color: Config.textDim
        text: root.glyph
    }

    Rectangle {
        id: track

        Layout.fillWidth: true
        implicitHeight: 8
        radius: height / 2
        color: Config.surface

        Rectangle {
            width: Math.max(height, track.width * Math.max(0, Math.min(1, root.value)))
            height: parent.height
            radius: height / 2
            color: Config.accent
        }

        MouseArea {
            anchors.fill: parent
            anchors.margins: -6
            cursorShape: Qt.PointingHandCursor

            function apply(mouseX: real): void {
                root.moved(Math.max(0, Math.min(1, mouseX / track.width)));
            }

            onPressed: event => apply(event.x)
            onPositionChanged: event => {
                if (pressed)
                    apply(event.x);
            }
        }
    }
}
