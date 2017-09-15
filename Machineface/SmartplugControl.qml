import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0

ColumnLayout {
    id: root
    property string componentName: "smartplug-control"
    property bool wasConnected: false
    property bool folded: false

    visible: halRemoteComponent.connected || wasConnected

    HalRemoteComponent {
        id: halRemoteComponent
        halrcmdUri: halrcmdService.uri
        halrcompUri: halrcompService.uri
        ready: (halrcmdService.ready && halrcompService.ready) || connected
        name: root.componentName
        containerItem: container
        create: false
        onErrorStringChanged: console.log(componentName + " " + errorString)
        onConnectedChanged: root.wasConnected = true
    }

    ColumnLayout {
        id: container

        Label {
            id: smartLabel
            font.bold: true
            text: qsTr("Smartplugs")

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.folded = !root.folded
            }
        }

        GridLayout {
            Layout.fillWidth: true
            visible: !root.folded
            columns: 2

            Label {
                Layout.fillWidth: true
                text: qsTr("Power enable:")
            }

            HalSwitch {
                name: "power-enable"
                halPin.direction: HalPin.IO
            }

            Label {
                Layout.fillWidth: true
                text: qsTr("Fan enable:")
            }

            HalSwitch {
                name: "fan-enable"
                halPin.direction: HalPin.IO
            }

            Label {
                Layout.fillWidth: true
                text: qsTr("Power:")
            }

            TextField {
                Layout.preferredWidth: root.width * 0.4
                readOnly: true
                text: powerPin.value.toFixed(1) + "W"

                HalPin {
                    id: powerPin
                    name: "power"
                    type: HalPin.Float
                    direction: HalPin.In
                }
            }

            Label {
                Layout.fillWidth: true
                text: qsTr("Energy:")
            }

            TextField {
                Layout.preferredWidth: root.width * 0.4
                readOnly: true
                text: energyPin.value.toFixed(2) + "kWh"

                HalPin {
                    id: energyPin
                    name: "energy"
                    type: HalPin.Float
                    direction: HalPin.In
                }
            }
        }
    }
}
