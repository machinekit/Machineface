import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Application 1.0
import "./Singletons"

Dialog {
    id: aboutDialog
    title: qsTr("About Machineface")

    SystemPalette { id: systemPalette }

    contentItem: Rectangle {
        implicitWidth: Screen.pixelDensity * 140
        implicitHeight: dialogColumn.implicitHeight + Screen.pixelDensity*2
        color: systemPalette.window

        Label {
            id: dummyLabel
        }

        ColumnLayout {
            id: dialogColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Screen.pixelDensity

            Label {
                Layout.fillWidth: true
                text: "Machineface " + Info.version
                font.pixelSize: dummyLabel.font.pixelSize * 1.5
                font.bold: true
            }

            Label {
                id: infoText
                Layout.fillWidth: true
                text: "Copyright 2014-2017 by Alexander Rössler<br>"
                      + "This UI is based on <a href='https://github.com/qtquickvcp/qtquickvcp'>QtQuickVcp</a> Revision: " + Revision.name + "<br>"
                      + "<br>"
                      + "Development sponsored by:<br>"
                      + "TheCoolTool GmbH (<a href='http://www.thecooltool.com/'>http://www.thecooltool.com/</a>)<br>"
                      + "<br>"
                      + "<a href='https://github.com/qtquickvcp/Machineface'>Machineface</a> is licensed under the <a href='http://www.gnu.org/licenses/agpl-3.0.html'>GNU Affero General Public License, version 3</a>."
                textFormat: Text.StyledText
                elide: Text.ElideRight
                onLinkActivated: Qt.openUrlExternally(link)
            }

            RowLayout {
                Layout.fillWidth: true

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    Layout.alignment: Layout.Right
                    text: qsTr("Close")
                    onClicked: aboutDialog.close()
                }
            }
        }
    }

    standardButtons: StandardButton.Close
}
