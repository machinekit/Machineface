import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Application.Controls 1.0

Tab {
    title: qsTr("Extras")
    active: true
    Item {
        ColumnLayout {
            id: column1
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.margins: Screen.pixelDensity
            width: parent.width / 2
            spacing: Screen.pixelDensity

            /*Button {
                Layout.fillWidth: true
                text: qsTr("Remove Filament")
                enabled: filamentAction.enabled
                onClicked: {
                    filamentAction.mdiCommand = "G92 A0"
                    filamentAction.trigger()
                    filamentAction.mdiCommand = "G1 A-70 F200"
                    filamentAction.trigger()
                }
            }*/

            Item {
                Layout.fillHeight: true
            }

            MdiCommandAction {
                id: filamentAction
                enableHistory: false
            }
        }
    }
}
