import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.Controls 1.0
import Machinekit.Service 1.0

ColumnLayout {
    id: root
    property string labelName: "Gantry Configuration"
    property bool wasConnected: false

    visible: halRemoteComponent.ready || wasConnected

    HalRemoteComponent {
        id: halRemoteComponent
        halrcmdUri: halrcmdService.uri
        halrcompUri: halrcompService.uri
        ready: (halrcmdService.ready && halrcompService.ready) || connected
        name: "gantry-config"
        containerItem: container
        create: false
        onErrorStringChanged: console.log(errorString)
        onConnectedChanged: root.wasConnected = true
    }

    ColumnLayout {
        id: container
        enabled:  halRemoteComponent.connected
        Layout.fillWidth: true

        Label {
            font.bold: true
            text: root.labelName
        }
        GridLayout {
            columns: 2

            Label {
                text: qsTr("Left offset:")
            }

            HalSpinBox {
                Layout.fillWidth: true
                name: "offset-left"
                suffix: "mm"
                minimumValue: 0.0
                maximumValue: 999.9
                decimals: 3
                stepSize: 0.05
                halPin.direction: HalPin.IO
            }

            Label {
                text: qsTr("Right offset:")
            }

            HalSpinBox {
                Layout.fillWidth: true
                name: "offset-right"
                suffix: "mm"
                minimumValue: 0.0
                maximumValue: 999.9
                decimals: 3
                stepSize: 0.05
                halPin.direction: HalPin.IO
            }
        }
    }
}

