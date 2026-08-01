import QtQuick
import QtQuick.Layouts
import "root:/"

// A quick-settings tile: circular icon, label, status line, and an optional
// chevron that opens a picker. The tile body and the chevron are separate
// targets: the body toggles, the chevron expands.
Rectangle {
    id: root

    property string glyph: ""
    property string label: ""
    property string sublabel: ""
    property bool active: false
    property bool expandable: false
    property bool expanded: false

    signal toggled
    signal expandRequested

    Layout.fillWidth: true
    implicitHeight: 58
    radius: Config.tileRadius
    color: active ? (bodyMouse.containsMouse ? Config.accentHover : Config.accent) : (bodyMouse.containsMouse ? Config.surfaceHover : Config.surface)

    Behavior on color {
        ColorAnimation { duration: 130 }
    }

    MouseArea {
        id: bodyMouse

        anchors.fill: parent
        anchors.rightMargin: root.expandable ? 30 : 0
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 8
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

        Item {
            visible: root.expandable
            implicitWidth: 22
            implicitHeight: 22

            Text {
                id: chevron

                anchors.centerIn: parent
                font.family: Config.iconFont
                font.pixelSize: 11
                color: root.active ? Config.accentText : Config.textDim
                text: Config.iconChevron
                rotation: root.expanded ? 90 : 0

                Behavior on rotation {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                cursorShape: Qt.PointingHandCursor
                onClicked: root.expandRequested()
            }
        }
    }
}
