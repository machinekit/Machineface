import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.Service 1.0
import Machinekit.Controls 1.0
import Machinekit.Application.Controls 1.0

Item {
    Service {
        id: halrcompService
        type: "halrcomp"
    }

    Service {
        id: halrcmdService
        type: "halrcmd"
    }

    HalRemoteComponent {
        id: printeruiHalRemoteComponent
        halrcmdUri: halrcmdService.uri
        halrcompUri: halrcompService.uri
        ready: (halrcmdService.ready && halrcompService.ready) || connected
        name: "printerui"
        containerItem: printerui
        onErrorStringChanged: console.log(errorString)
    }

    HalRemoteComponent {
        halrcmdUri: halrcmdService.uri
        halrcompUri: halrcompService.uri
        ready: (halrcmdService.ready && halrcompService.ready) || (state === HalRemoteComponent.Connected)
        name: "ledctrl"
        containerItem: lightColorItem
        onErrorStringChanged: console.log(errorString)
    }

    ColumnLayout {
        id: printerui
        anchors.fill: parent
        enabled: printeruiHalRemoteComponent.connected

        DigitalReadOut {
            Layout.fillWidth: true
            id: dro
        }

        HalLabel {
            id: tempSetLabel
            name: "e0.temp.set"
            prefix: qsTr("<b>E0 temp</b> - set to ")
            decimals: 1
            suffix: "°C"
            halPin.type: HalPin.Float
        }

        HalGauge {
            id: e0TempGauge
            Layout.fillWidth: true
            name: "e0.temp.meas"
            suffix: "°C"
            decimals: 1
            minimumValueVisible: false
            maximumValueVisible: false
            minimumValue: 0
            maximumValue: 280
            z0BorderValue: 50
            z1BorderValue: 230
            z0Color: "green"
            z1Color: "yellow"
            z2Color: "red"
            MouseArea {
                anchors.fill: parent
                onDoubleClicked: e0TempChart.visible = !e0TempChart.visible
                onClicked: e0Control.visible = !e0Control.visible
                cursorShape: "PointingHandCursor"
            }
        }

        LogChart {
            id: e0TempChart
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.25
            visible: false
            value: e0TempGauge.value
            minimumValue: e0TempGauge.minimumValue
            maximumValue: e0TempGauge.maximumValue
            leftTextVisible: false
            rightTextVisible: false
            autoSampling: (e0TempGauge.halPin.synced) && visible
            updateInterval: 500
            timeSpan: 120000
        }

        RowLayout {
            Layout.fillWidth: true
            id: e0Control
            visible: true

            SpinBox {
                Layout.fillWidth: true
                id: e0TempSetSpin
                minimumValue: 0.0
                maximumValue: 250.0
                decimals: 1
                suffix: "°C"

                Keys.onReturnPressed: {
                    e0TempAction.mdiCommand = "M204 P" + e0TempSetSpin.value.toFixed(1)
                    e0TempAction.trigger()
                }

                onEditingFinished: {            // remove the focus from this control
                    parent.forceActiveFocus()
                    parent.focus = true
                }
            }

            Switch {
                id: e0OnOffSwitch
                enabled: e0TempAction.enabled
                onCheckedChanged: {
                    if (checked) {
                        if (e0TempSetSpin.value == 0) {
                            checked = false
                            return
                        }

                        e0TempAction.mdiCommand = "M204 P" + e0TempSetSpin.value.toFixed(1)
                    }
                    else {
                        e0TempAction.mdiCommand = "M204 P0"
                    }
                    e0TempAction.trigger()
                }

                Binding {
                    target: e0OnOffSwitch
                    property: "checked"
                    value: tempSetLabel.halPin.value > 0.0
                }
            }

            MdiCommandAction {
                id: e0TempAction
                enableHistory: false
            }
        }

        HalLabel {
            id: bedTempSetLabel
            name: "hb.temp.set"
            prefix: qsTr("<b>Bed temp</b> - set to ")
            decimals: 1
            suffix: "°C"
            halPin.type: HalPin.Float
        }

        HalGauge {
            id: bedTempGauge
            Layout.fillWidth: true
            name: "hb.temp.meas"
            suffix: "°C"
            decimals: 1
            minimumValueVisible: false
            maximumValueVisible: false
            minimumValue: 0
            maximumValue: 160
            z0BorderValue: 50
            z1BorderValue: 120
            z0Color: "green"
            z1Color: "yellow"
            z2Color: "red"
            MouseArea {
                anchors.fill: parent
                onDoubleClicked: bedTempChart.visible = !bedTempChart.visible
                onClicked: bedControl.visible = !bedControl.visible
                cursorShape: "PointingHandCursor"
            }
        }

        LogChart {
            id: bedTempChart
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.25
            visible: false
            value: bedTempGauge.value
            minimumValue: bedTempGauge.minimumValue
            maximumValue: bedTempGauge.maximumValue
            leftTextVisible: false
            rightTextVisible: false
            autoSampling: (bedTempGauge.halPin.synced) && visible
            updateInterval: 500
            timeSpan: 120000
        }

        RowLayout {
            Layout.fillWidth: true
            id: bedControl
            visible: true

            SpinBox {
                Layout.fillWidth: true
                id: bedTempSetSpin
                minimumValue: 0.0
                maximumValue: 150.0
                decimals: 1
                suffix: "°C"

                Keys.onReturnPressed: {
                    bedTempAction.mdiCommand = "M240 P" + bedTempSetSpin.value.toFixed(1)
                    bedTempAction.trigger()
                }

                onEditingFinished: {            // remove the focus from this control
                    parent.forceActiveFocus()
                    parent.focus = true
                }
            }

            Switch {
                id: bedOnOffSwitch
                enabled: bedTempAction.enabled
                onCheckedChanged: {
                    if (checked) {
                        if (bedTempSetSpin.value == 0) {
                            checked = false
                            return
                        }

                        bedTempAction.mdiCommand = "M240 P" + bedTempSetSpin.value.toFixed(1)
                    }
                    else {
                        bedTempAction.mdiCommand = "M240 P0"
                    }
                    bedTempAction.trigger()
                }

                Binding {
                    target: bedOnOffSwitch
                    property: "checked"
                    value: bedTempSetLabel.halPin.value > 0.0
                }
            }

            MdiCommandAction {
                id: bedTempAction
                enableHistory: false
            }
        }

        Label {
            text: qsTr("<b>Fan speed</b>")
        }

        HalGauge {
            Layout.fillWidth: true
            name: "e0.fan.pwm"
            suffix: "%"
            valueLabel.text: (value * 100).toFixed(decimals) + suffix
            decimals: 0
            minimumValueVisible: false
            maximumValueVisible: false
            minimumValue: 0
            maximumValue: 1
            z0BorderValue: 1
            z1BorderValue: 1
            z0Color: "white"
            z1Color: "lightblue"
            z2Color: "lightblue"

            MouseArea {
                anchors.fill: parent
                onClicked: fanSpeedSlider.visible = !fanSpeedSlider.visible
                cursorShape: "PointingHandCursor"
            }
        }

        Slider {
            id: fanSpeedSlider
            visible: false
            Layout.fillWidth: true
            minimumValue: 0
            maximumValue: 100
            stepSize: 1
        }

        Label {
            text: qsTr("<b>Light</b>")
        }

        RowLayout {


            Led {
                Layout.preferredHeight: pickColorButton.height * 0.8
                Layout.preferredWidth: pickColorButton.height * 0.8
                color: Qt.rgba(lightColorItem.color.r, lightColorItem.color.g, lightColorItem.color.b, 1.0)
            }

            Led {
                Layout.preferredHeight: pickColorButton.height * 0.8
                Layout.preferredWidth: pickColorButton.height * 0.8
                color: Qt.rgba(lightColorItem.color.a, lightColorItem.color.a, lightColorItem.color.a, 1.0)
            }

            Button {
                id: pickColorButton
                Layout.fillWidth: true
                text: qsTr("Pick Color")
                onClicked: colorDialog.visible = true
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

    Item {
        property color color: colorDialog.visible ? colorDialog.currentColor : colorDialog.color

        id: lightColorItem

        ColorDialog {
            id: colorDialog
            color: "white"
            showAlphaChannel: true
        }

        HalPin {
            id: rHalPin
            type: HalPin.Float
            direction: HalPin.Out
            name: "color.r"
            value: lightColorItem.color.r
        }

        HalPin {
            id: gHalPin
            type: HalPin.Float
            direction: HalPin.Out
            name: "color.g"
            value: lightColorItem.color.g
        }

        HalPin {
            id: bHalPin
            type: HalPin.Float
            direction: HalPin.Out
            name: "color.b"
            value: lightColorItem.color.b
        }

        HalPin {
            id: wHalPin
            type: HalPin.Float
            direction: HalPin.Out
            name: "color.w"
            value: lightColorItem.color.a
        }
    }
}
