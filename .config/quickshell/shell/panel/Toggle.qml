import QtQuick
import QtQuick.Layouts
import "root:/"

// A quick-settings tile: circular icon, label, and a status line underneath.
Rectangle {
    id: root

    property string glyph: ""
    property string label: ""
    property string sublabel: ""
    property bool active: false

    signal toggled

    Layout.fillWidth: true
    implicitHeight: 58
    radius: Config.tileRadius
    color: active ? (mouse.containsMouse ? Config.accentHover : Config.accent) : (mouse.containsMouse ? Config.surfaceHover : Config.surface)

    Behavior on color {
        ColorAnimation { duration: 130 }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 10

        Rectangle {
            implicitWidth: 30
            implicitHeight: 30
            radius: height / 2
            color: root.active ? Qt.rgba(1, 1, 1, 0.22) : Config.surfaceHover

            Behavior on color {
                ColorAnimation { duration: 130 }
            }

            Text {
                anchors.centerIn: parent
                font.family: Config.iconFont
                font.pixelSize: 14
                color: root.active ? Config.accentText : Config.textDim
                text: root.glyph
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
                color: root.active ? Config.accentText : Config.text
                text: root.label
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                visible: root.sublabel !== ""
                font.family: Config.uiFont
                font.pixelSize: Config.fontSub
                color: root.active ? Qt.rgba(1, 1, 1, 0.72) : Config.textDim
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
