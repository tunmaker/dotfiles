import QtQuick
import QtQuick.Layouts
import "root:/"

// A quick-settings tile: icon, label, and a status line underneath.
Rectangle {
    id: root

    property string glyph: ""
    property string label: ""
    property string sublabel: ""
    property bool active: false

    signal toggled

    Layout.fillWidth: true
    implicitHeight: 52
    radius: Config.radius
    color: active ? Config.accent : mouse.containsMouse ? Config.surfaceHover : Config.surface

    Behavior on color {
        ColorAnimation { duration: 120 }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 10

        Text {
            font.family: Config.iconFont
            font.pixelSize: 15
            color: root.active ? Config.text : Config.textDim
            text: root.glyph
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Text {
                Layout.fillWidth: true
                font.family: Config.uiFont
                font.pixelSize: 12
                font.weight: Font.DemiBold
                color: Config.text
                text: root.label
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                visible: root.sublabel !== ""
                font.family: Config.uiFont
                font.pixelSize: 10
                color: root.active ? Qt.rgba(1, 1, 1, 0.75) : Config.textDim
                text: root.sublabel
                elide: Text.ElideRight
            }
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }
}
