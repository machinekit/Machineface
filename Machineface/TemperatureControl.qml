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
    property string componentName: "fdm-e0"
    property string labelName: "E0"
    property double spinMinimumValue: minTemperaturePin.value
    property double spinMaximumValue: maxTemperaturePin.value
    property double gaugeMinimumValue: spinMinimumValue
    property double gaugeMaximumValue: spinMaximumValue * 1.1
    property double gaugeZ0BorderValue: 50.0
    property double gaugeZ1BorderValue: spinMaximumValue * 0.9
    property int logHeight: 200
    property bool wasConnected: false

    visible: halRemoteComponent.connected || wasConnected
    enabled:  halRemoteComponent.connected

    HalRemoteComponent {
        id: halRemoteComponent
        halrcmdUri: halrcmdService.uri
        halrcompUri: halrcompService.uri
        ready: (halrcmdService.ready && halrcompService.ready) || connected
        name: root.componentName
        containerItem: root
        create: false
        onErrorStringChanged: console.log(errorString)
        onConnectedChanged: root.wasConnected = true
    }

    RowLayout {
        Label {
            id: tempSetLabel
            font.bold: true
            text: root.labelName
        }

        Item {
            Layout.fillWidth: true
        }

        HalLed {
            id: activeLed
            name: "active"
            onColor: "orange"
            Layout.preferredHeight: tempSetLabel.height * 0.9
            Layout.preferredWidth: tempSetLabel.height * 0.9
        }

        HalLed {
            id: inTempRangeLed
            name: "temp.in-range"
            onColor: "green"
            Layout.preferredHeight: tempSetLabel.height * 0.9
            Layout.preferredWidth: tempSetLabel.height * 0.9
        }

        HalLed {
            id: errorLed
            name: "error"
            onColor: "red"
            Layout.preferredHeight: tempSetLabel.height * 0.9
            Layout.preferredWidth: tempSetLabel.height * 0.9
        }
    }

    HalPin {
        id: maxTemperaturePin
        name: "temp.limit.max"
        direction: HalPin.In
        type: HalPin.Float
    }

    HalPin {
        id: minTemperaturePin
        name: "temp.limit.min"
        direction: HalPin.In
        type: HalPin.Float
    }

    HalPin {
        id: standbyTemperaturePin
        name: "temp.standby"
        direction: HalPin.In
        type: HalPin.Float
    }

    HalGauge {
        id: tempGauge
        Layout.fillWidth: true
        name: "temp.meas"
        suffix: "°C"
        decimals: 1
        valueVisible: !errorLed.value
        minimumValueVisible: false
        maximumValueVisible: false
        minimumValue: root.gaugeMinimumValue
        maximumValue: root.gaugeMaximumValue
        z0BorderValue: root.gaugeZ0BorderValue
        z1BorderValue: root.gaugeZ1BorderValue
        z0Color: valueVisible ? "green" : "white"
        z1Color: valueVisible ? "yellow" : "white"
        z2Color: valueVisible ? "red" : "white"

        Label {
            anchors.centerIn: parent
            text: qsTr("N/A")
            visible: !tempGauge.valueVisible
        }

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: tempChart.visible = !tempChart.visible
            onClicked: control.visible = !control.visible
            cursorShape: "PointingHandCursor"
        }
    }

    LogChart {
        id: tempChart
        Layout.fillWidth: true
        Layout.preferredHeight: root.logHeight
        visible: false
        value: tempGauge.value
        minimumValue: tempGauge.minimumValue
        maximumValue: tempGauge.maximumValue
        leftTextVisible: false
        rightTextVisible: false
        autoSampling: (tempGauge.halPin.synced) && visible
        autoUpdate: autoSampling
        updateInterval: 500
        timeSpan: 120000
    }

    RowLayout {
        Layout.fillWidth: true
        id: control
        visible: true

        HalSpinBox {
            Layout.fillWidth: true
            id: tempSetSpin
            enabled: errorLed.value === false
            name: "temp.set"
            halPin.direction: HalPin.IO
            minimumValue: root.spinMinimumValue
            maximumValue: root.spinMaximumValue
            decimals: 1
            suffix: "°C"

            onEditingFinished: {            // remove the focus from this control
                parent.forceActiveFocus()
                parent.focus = true
            }
        }

        Switch {
            id: onOffSwitch
            enabled: errorLed.value === false
            onCheckedChanged: {
                if (checked) {
                    if (tempSetSpin.value == 0) {
                        tempSetSpin.value = standbyTemperaturePin.value
                    }
                }
                else {
                    tempSetSpin.value = 0
                }
            }

            Binding {
                target: onOffSwitch
                property: "checked"
                value: tempSetSpin.value > 0.0
            }
        }
    }
}

