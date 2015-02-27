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
            Button {
                Layout.fillWidth: true
                text: qsTr("Remove Filament")
                enabled: filamentAction.enabled
                onClicked: {
                    filamentAction.mdiCommand = "G92 A0"
                    filamentAction.trigger()
                    filamentAction.mdiCommand = "G1 A-70 F200"
                    filamentAction.trigger()
                }
            }
            Button {
                Layout.fillWidth: true
                text: qsTr("Insert Filament")
                enabled: filamentAction.enabled
                onClicked: {
                    filamentAction.mdiCommand = "G92 A0"
                    filamentAction.trigger()
                    filamentAction.mdiCommand = "G1 A110 F200"
                    filamentAction.trigger()
                }
            }
            Button {
                Layout.fillWidth: true
                text: qsTr("Calibrate")
                enabled: filamentAction.enabled
                onClicked: {
                    filamentAction.mdiCommand = "G29"
                    filamentAction.trigger()
                }
            }

            Button {
                Layout.fillWidth: true
                text: qsTr("Probe")
                enabled: filamentAction.enabled
                onClicked: {
                    filamentAction.mdiCommand = "G30"
                    filamentAction.trigger()
                }
            }

            Item {
                Layout.fillHeight: true
            }

            MdiCommandAction {
                id: filamentAction
                enableHistory: false
            }
        }
        ColumnLayout {
            id: column2
            anchors.left: column1.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.margins: Screen.pixelDensity
            width: parent.width / 2
            spacing: Screen.pixelDensity
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: false

                Label {
                    text: qsTr("Feed Override")
                }

                Item {
                    Layout.fillWidth: true
                }

                Label {
                    text: (feedrateSlider.value * 100).toFixed(0) + "%"
                }
            }

            FeedrateSlider {
                id: feedrateSlider
                Layout.fillWidth: true
                Layout.fillHeight: false
            }

            VelocityExtrudingControl {
                id: velocityExtrudingControl
            }

            GantryConfigControl {
                id: gantryConfigControl
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
