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
    property string labelName: "Velocity Extrusion"
    property bool wasConnected: false

    visible: halRemoteComponent.ready || wasConnected

    HalRemoteComponent {
        id: halRemoteComponent
        halrcmdUri: halrcmdService.uri
        halrcompUri: halrcompService.uri
        ready: (halrcmdService.ready && halrcompService.ready) || connected
        name: "fdm-ve-params"
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
                text: qsTr("Filament diameter:")
            }

            HalSpinBox {
                Layout.fillWidth: true
                name: "filament-dia"
                suffix: "mm"
                minimumValue: 0.0
                maximumValue: 10.0
                decimals: 3
                stepSize: 0.05
                halPin.direction: HalPin.IO
            }

            Label {
                text: qsTr("Retract velocity:")
            }

            HalSpinBox {
                Layout.fillWidth: true
                name: "retract-vel"
                suffix: "mm/s"
                minimumValue: 0.0
                maximumValue: 100.0
                decimals: 1
                stepSize: 1.0
                halPin.direction: HalPin.IO
            }

            Label {
                text: qsTr("Retract length:")
            }

            HalSpinBox {
                Layout.fillWidth: true
                name: "retract-len"
                suffix: "mm"
                minimumValue: 0.0
                maximumValue: 10.0
                decimals: 2
                stepSize: 0.05
                halPin.direction: HalPin.IO
            }

            Label {
                text: qsTr("Extrude scale:")
            }

            HalSpinBox {
                Layout.fillWidth: true
                name: "extrude-scale"
                minimumValue: 0.0
                maximumValue: 10.0
                decimals: 2
                stepSize: 0.05
                halPin.direction: HalPin.IO
            }

            Label {
                text: qsTr("Accel. adj. gain:")
            }

            HalSpinBox {
                Layout.fillWidth: true
                name: "accel-adj-gain"
                minimumValue: 0.0
                maximumValue: 10.0
                decimals: 3
                stepSize: 0.01
                halPin.direction: HalPin.IO
            }
        }
    }
}
