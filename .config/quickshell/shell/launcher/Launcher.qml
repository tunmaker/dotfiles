import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "root:/"
import "root:/services"

// Centered application launcher.
//
// Covers the screen so a click anywhere outside the card dismisses it, and
// takes exclusive keyboard focus so typing goes here rather than to the window
// underneath.
PanelWindow {
    id: root

    required property var launcherScreen

    readonly property int maxResults: 8

    property string query: ""
    property int selected: 0

    screen: launcherScreen
    visible: Panels.launcherOpen
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "qs-launcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    // Rank: exact prefix beats substring beats keyword beats subsequence.
    function scoreOf(entry, needle: string): int {
        const name = (entry.name ?? "").toLowerCase();
        if (name === needle)
            return 10000;
        if (name.startsWith(needle))
            return 5000 - name.length;

        const at = name.indexOf(needle);
        if (at >= 0)
            return 3000 - at * 10 - name.length;

        const haystack = `${entry.genericName ?? ""} ${entry.keywords ?? ""} ${entry.comment ?? ""}`.toLowerCase();
        if (haystack.includes(needle))
            return 1500;

        // Subsequence: "gimp" matches "GNU Image Manipulation Program".
        let cursor = 0;
        for (const character of needle) {
            cursor = name.indexOf(character, cursor);
            if (cursor === -1)
                return -1;
            cursor += 1;
        }
        return 500 - name.length;
    }

    readonly property var results: {
        const all = (DesktopEntries.applications?.values ?? []).filter(entry => !entry.noDisplay);
        const needle = root.query.trim().toLowerCase();

        if (needle === "") {
            return all.slice().sort((a, b) => (a.name ?? "").localeCompare(b.name ?? "")).slice(0, root.maxResults);
        }

        return all
            .map(entry => ({ entry: entry, score: root.scoreOf(entry, needle) }))
            .filter(scored => scored.score >= 0)
            .sort((a, b) => b.score - a.score)
            .slice(0, root.maxResults)
            .map(scored => scored.entry);
    }

    function launch(entry): void {
        if (!entry)
            return;

        // command is already a parsed argv list, so nothing goes through a shell.
        if (entry.runInTerminal)
            Quickshell.execDetached(["kitty", "-e", ...entry.command]);
        else
            Quickshell.execDetached(entry.command);

        Panels.closeLauncher();
    }

    function move(delta: int): void {
        const count = root.results.length;
        if (count === 0)
            return;
        root.selected = (root.selected + delta + count) % count;
    }

    onVisibleChanged: {
        if (visible) {
            root.query = "";
            root.selected = 0;
            input.forceActiveFocus();
        }
    }

    onQueryChanged: root.selected = 0

    // Dim + click-away.
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.35

        MouseArea {
            anchors.fill: parent
            onClicked: Panels.closeLauncher()
        }
    }

    Rectangle {
        id: card

        anchors.horizontalCenter: parent.horizontalCenter
        y: Math.round(parent.height * 0.22)
        width: 560
        implicitHeight: layout.implicitHeight + 20
        radius: Config.panelRadius
        color: Config.bg
        border.width: 1
        border.color: Config.outline

        ColumnLayout {
            id: layout

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 6
                spacing: 10

                Text {
                    font.family: Config.iconFont
                    font.pixelSize: 15
                    color: Config.textDim
                    text: Config.iconSearch
                }

                TextInput {
                    id: input

                    Layout.fillWidth: true
                    font.family: Config.uiFont
                    font.pixelSize: 17
                    color: Config.text
                    selectionColor: Config.accent
                    selectByMouse: true
                    focus: true
                    onTextChanged: root.query = text

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        visible: input.text === ""
                        font: input.font
                        color: Config.textDim
                        text: "Search applications"
                    }

                    Keys.onEscapePressed: Panels.closeLauncher()
                    Keys.onUpPressed: root.move(-1)
                    Keys.onDownPressed: root.move(1)
                    Keys.onTabPressed: root.move(1)
                    Keys.onBacktabPressed: root.move(-1)
                    Keys.onReturnPressed: root.launch(root.results[root.selected])
                    Keys.onEnterPressed: root.launch(root.results[root.selected])
                }
            }

            Rectangle {
                Layout.fillWidth: true
                visible: root.results.length > 0
                implicitHeight: 1
                color: Config.outline
            }

            Text {
                Layout.fillWidth: true
                Layout.leftMargin: 6
                Layout.bottomMargin: 4
                visible: root.results.length === 0
                font.family: Config.uiFont
                font.pixelSize: Config.fontSub
                color: Config.textDim
                text: root.query === "" ? "No applications found" : `Nothing matches "${root.query}"`
            }

            Repeater {
                model: root.results

                delegate: Rectangle {
                    id: row

                    required property var modelData
                    required property int index

                    readonly property bool current: index === root.selected

                    Layout.fillWidth: true
                    implicitHeight: 48
                    radius: 12
                    color: current ? Config.accent : rowHover.containsMouse ? Config.surfaceHover : "transparent"

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 12
                        spacing: 12

                        // iconPath(..., true) returns "" when the theme has no
                        // such icon, instead of a URL that renders as Qt's
                        // missing-image checkerboard.
                        Item {
                            implicitWidth: 30
                            implicitHeight: 30

                            readonly property string resolved: row.modelData.icon ? Quickshell.iconPath(row.modelData.icon, true) : ""

                            IconImage {
                                anchors.fill: parent
                                source: parent.resolved
                                visible: parent.resolved !== ""
                            }

                            Rectangle {
                                anchors.fill: parent
                                visible: parent.resolved === ""
                                radius: 8
                                color: row.current ? Qt.rgba(1, 1, 1, 0.22) : Config.surfaceHover

                                Text {
                                    anchors.centerIn: parent
                                    font.family: Config.uiFont
                                    font.pixelSize: 14
                                    font.weight: Font.DemiBold
                                    color: row.current ? Config.accentText : Config.textDim
                                    text: (row.modelData.name || "?").charAt(0).toUpperCase()
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            Text {
                                Layout.fillWidth: true
                                font.family: Config.uiFont
                                font.pixelSize: Config.fontLabel
                                font.weight: Font.DemiBold
                                color: row.current ? Config.accentText : Config.text
                                text: row.modelData.name ?? ""
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                font.family: Config.uiFont
                                font.pixelSize: Config.fontSub
                                color: row.current ? Qt.rgba(1, 1, 1, 0.75) : Config.textDim
                                text: row.modelData.genericName || row.modelData.comment || ""
                                elide: Text.ElideRight
                            }
                        }

                        Text {
                            visible: row.current
                            font.family: Config.uiFont
                            font.pixelSize: 10
                            color: Qt.rgba(1, 1, 1, 0.75)
                            text: "Enter"
                        }
                    }

                    MouseArea {
                        id: rowHover

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: root.selected = row.index
                        onClicked: root.launch(row.modelData)
                    }
                }
            }
        }
    }
}
