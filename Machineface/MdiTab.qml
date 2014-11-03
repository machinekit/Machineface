import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Application.Controls 1.0

Tab {
    title: qsTr("MDI")
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity * 1
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

        MdiCommandEdit {
            Layout.fillWidth: true
            id: mdiCommandEdit
        }
    }
}
