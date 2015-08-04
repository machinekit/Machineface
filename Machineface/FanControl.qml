import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.Controls 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Service 1.0

ColumnLayout {
    id: root
    property string componentName: "fdm-f0"
    property string labelName: "Fan"
    property bool wasConnected: false

    visible: halRemoteComponent.connected || wasConnected

    HalRemoteComponent {
        id: halRemoteComponent
        halrcmdUri: halrcmdService.uri
        halrcompUri: halrcompService.uri
        ready: (halrcmdService.ready && halrcompService.ready) || connected
        name: root.componentName
        containerItem: container
        create: false
        onErrorStringChanged: console.log(errorString)
        onConnectedChanged: root.wasConnected = true
    }

    ColumnLayout {
        id: container
        Layout.fillWidth: true
        enabled:  halRemoteComponent.connected

        Label {
            text: root.labelName
            font.bold: true
        }

        Gauge {
            id: fanSpeedGauge
            Layout.fillWidth: true
            value: fanSpeedSlider.value
            suffix: "%"
            valueLabel.text: (value / 2.55 ).toFixed(decimals) + suffix
            decimals: 0
            minimumValueVisible: false
            maximumValueVisible: false
            minimumValue: 0
            maximumValue: 255
            z0BorderValue: 1
            z1BorderValue: 1
            z0Color: "#C9FDFF"
            z1Color: "#9ADAFF"
            z2Color: "#9ADAFF"

            MouseArea {
                anchors.fill: parent
                onClicked: fanSpeedSlider.visible = !fanSpeedSlider.visible
                cursorShape: "PointingHandCursor"
            }
        }

        HalSlider {
            id: fanSpeedSlider
            Layout.fillWidth: true
            name: "set"
            halPin.direction: HalPin.IO
            visible: false
            minimumValue: 0
            maximumValue: 255
            stepSize: 1
            updateValueWhileDragging: true
            tickmarksEnabled: false
            minimumValueVisible: false
            maximumValueVisible: false
            valueVisible: false
        }
    }
}

