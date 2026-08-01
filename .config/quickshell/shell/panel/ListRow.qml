import QtQuick
import QtQuick.Layouts
import "root:/"

// A single selectable row inside an expanded picker.
Rectangle {
    id: root

    property string glyph: ""
    property string label: ""
    property string sublabel: ""
    property string trailing: ""
    property bool selected: false
    property bool busy: false
    property bool interactive: true

    signal activated

    Layout.fillWidth: true
    implicitHeight: 42
    radius: 10
    color: mouse.containsMouse && root.interactive ? Config.surfaceHover : "transparent"
    opacity: root.interactive ? 1 : 0.45

    Behavior on color {
        ColorAnimation { duration: 110 }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 12
        spacing: 10

        Text {
            font.family: Config.iconFont
            font.pixelSize: 13
            color: root.selected ? Config.accent : Config.textDim
            text: root.glyph
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Text {
                Layout.fillWidth: true
                font.family: Config.uiFont
                font.pixelSize: Config.fontSub + 1
                font.weight: root.selected ? Font.DemiBold : Font.Normal
                color: root.selected ? Config.accent : Config.text
                text: root.label
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                visible: root.sublabel !== ""
                font.family: Config.uiFont
                font.pixelSize: 10
                color: Config.textDim
                text: root.sublabel
                elide: Text.ElideRight
            }
        }

        Text {
            visible: root.trailing !== ""
            font.family: Config.uiFont
            font.pixelSize: 10
            color: Config.textDim
            text: root.trailing
        }

        // Indeterminate spinner while a connect/disconnect is in flight.
        Rectangle {
            visible: root.busy
            implicitWidth: 12
            implicitHeight: 12
            radius: 6
            color: "transparent"
            border.width: 2
            border.color: Config.accent
            opacity: 0.35

            SequentialAnimation on opacity {
                running: root.busy
                loops: Animation.Infinite
                NumberAnimation { to: 1; duration: 450 }
                NumberAnimation { to: 0.35; duration: 450 }
            }
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        enabled: !root.busy && root.interactive
        cursorShape: root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.activated()
    }
}
