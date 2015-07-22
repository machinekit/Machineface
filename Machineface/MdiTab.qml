import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Application.Controls 1.0

Tab {
    id: tab
    title: qsTr("MDI")

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity

        RowLayout {
            MdiHistoryTable {
                Layout.fillHeight: true
                Layout.fillWidth: true
                onCommandSelected: {
                    mdiCommandEdit.text = command
                }

                onCommandTriggered: {
                    mdiCommandEdit.text = command
                    mdiCommandEdit.action.trigger()
                }
            }

            ListView {
                Layout.fillHeight: true
                Layout.preferredWidth: (count > 0) ? dummyButton.width : 0 // 20 characters
                model: userCommandAction.commands
                spacing: Screen.pixelDensity
                enabled: userCommandAction.enabled

                delegate: Button {
                    Layout.fillWidth: true
                    anchors.left: parent.left
                    anchors.right: parent.right
                    text: userCommandAction.commands[index].name
                    onClicked: userCommandAction.executeCommand(index)
                }

                Button {
                    id: dummyButton
                    text: "12345678901234567890"
                    visible: false
                }

                UserCommandAction {
                    id: userCommandAction
                }
            }
        }

        MdiCommandEdit {
            Layout.fillWidth: true
            id: mdiCommandEdit
        }
    }
}
