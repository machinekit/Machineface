import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.0
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Service 1.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0

ApplicationItem {
    property var numberModel: [0.1, 1, 10, "∞"]
    property var numberModelReverse: {
        var tmp = numberModel.slice()
        tmp.reverse()
        return tmp
    }
    property var axisColors: ["#F5A9A9", "#A9F5F2", "#81F781", "#D2B48C"]
    property color allColor: "#DDD"
    property var axisNames: ["X", "Y", "Z", "A"]
    property string eName: "E"
    property string eUnits: "mm/s"
    property bool zVisible: status.synced ? status.config.axes > 2 : true
    property bool aVisible: status.synced ? status.config.axes > 3 : true
    property bool eVisible: halRemoteComponent.connected

    id: root

    Service {
        id: halrcompService
        type: "halrcomp"
    }

    Service {
        id: halrcmdService
        type: "halrcmd"
    }

    HalRemoteComponent {
        id: halRemoteComponent
        halrcmdUri: halrcmdService.uri
        halrcompUri: halrcompService.uri
        ready: (halrcmdService.ready && halrcompService.ready) || connected
        name: "fdm-ve-jog"
        containerItem: extruderControl
        create: false
        onErrorStringChanged: console.log(errorString)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity

        Item {
            id: container
            anchors.left: parent.left
            anchors.right: parent.right
            //anchors.verticalCenter: parent.verticalCenter
            height: Math.min(width / 1.6, parent.height)

            Item {
                id: mainItem
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: height

                Label {
                    anchors.centerIn: parent
                    text: axisNames[0] + axisNames[1]
                    font.bold: true
                }

                Button {
                    id: homeXButton
                    anchors.left: parent.left
                    anchors.top: parent.top
                    action: HomeAxisAction {axis: 0}
                    text: "X"
                    width: parent.height * 0.2
                    height: width
                    style: CustomStyle { baseColor: axisColors[0] }
                    iconSource: "icons/ic_home_black_48dp.png"
                }

                Button {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    action: HomeAxisAction {axis: 1}
                    text: "Y"
                    width: parent.height * 0.2
                    height: width
                    style: CustomStyle { baseColor: axisColors[1] }
                    iconSource: "icons/ic_home_black_48dp.png"
                }

                Button {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    visible: zVisible
                    action: HomeAxisAction {axis: 2}
                    text: "Z"
                    width: parent.height * 0.2
                    height: width
                    style: CustomStyle { baseColor: axisColors[2] }
                    iconSource: "icons/ic_home_black_48dp.png"
                }

                Button {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    action: HomeAxisAction {axis: -1}
                    text: "All"
                    width: parent.height * 0.2
                    height: width
                    style: CustomStyle { baseColor: allColor }
                    iconSource: "icons/ic_home_black_48dp.png"
                }

                RowLayout {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.height / (numberModel.length*2+1) * numberModel.length
                    height: width
                    spacing: 0
                    Repeater {
                        model: numberModel
                        JogButton {
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height / numberModel.length * (index+1)
                            text: numberModel[index]
                            axis: 0
                            distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                            direction: 1
                            style: CustomStyle { baseColor: axisColors[0]; darkness: index*0.06 }
                        }
                    }
                }

                RowLayout {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.height / (numberModel.length*2+1) * numberModel.length
                    height: width
                    spacing: 0
                    Repeater {
                        model: numberModelReverse
                        JogButton {
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.width / numberModel.length * (numberModel.length-index)
                            text: "-" + numberModelReverse[index]
                            axis: 0
                            distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                            direction: -1
                            style: CustomStyle { baseColor: axisColors[0]; darkness: (numberModel.length-index-1)*0.06 }
                        }
                    }
                }

                ColumnLayout {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height / (numberModel.length*2+1) * numberModel.length
                    width: height
                    spacing: 0
                    Repeater {
                        model: numberModelReverse
                        JogButton {
                            Layout.preferredWidth: parent.width / numberModel.length * (numberModel.length-index)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            text: numberModelReverse[index]
                            axis: 1
                            distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                            direction: 1
                            style: CustomStyle { baseColor: axisColors[1]; darkness: (numberModel.length-index-1)*0.06 }
                        }
                    }
                }

                ColumnLayout {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height / (numberModel.length*2+1) * numberModel.length
                    width: height
                    spacing: 0
                    Repeater {
                        model: numberModel
                        JogButton {
                            Layout.preferredWidth: parent.width / numberModel.length * (index+1)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "-" + numberModel[index]
                            axis: 1
                            distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                            direction: -1
                            style: CustomStyle { baseColor: axisColors[1]; darkness: index*0.06 }
                        }
                    }
                }
            }

            RowLayout {
                anchors.left: mainItem.right
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.leftMargin: parent.height * 0.03

                Repeater {
                    model: status.synced ? status.config.axes - 2 : 2

                    Item {
                        property int axisIndex: index
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Label {
                            anchors.centerIn: parent
                            text: axisNames[2+axisIndex]
                            font.bold: true
                        }

                        ColumnLayout {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            height: parent.height / (numberModel.length*2+1) * numberModel.length
                            width: parent.width
                            spacing: 0
                            Repeater {
                                model: numberModelReverse
                                JogButton {
                                    Layout.preferredWidth: parent.height / numberModel.length * ((numberModel.length - index - 1) * 0.2 + 1)
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter
                                    text: numberModelReverse[index]
                                    axis: 2 + axisIndex
                                    distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                                    direction: 1
                                    style: CustomStyle { baseColor: axisColors[2+axisIndex]; darkness: (numberModel.length-index-1)*0.06 }
                                }
                            }
                        }

                        ColumnLayout {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: parent.height / (numberModel.length*2+1) * numberModel.length
                            width: parent.width
                            spacing: 0
                            Repeater {
                                model: numberModel
                                JogButton {
                                    Layout.preferredWidth: parent.height / numberModel.length * (index*0.2+1)
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "-" + numberModel[index]
                                    axis: 2 + axisIndex
                                    distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                                    direction: -1
                                    style: CustomStyle { baseColor: axisColors[2+axisIndex]; darkness: index*0.06 }
                                }
                            }
                        }
                    }
                }

                Item {
                    property int axisIndex: status.synced ? status.config.axes : 0
                    property double extruderVelocity: 5.0

                    id: extruderControl
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignRight
                    visible: eVisible

                    HalPin {
                        id: jogVelocityPin
                        name: "velocity"
                        direction: HalPin.IO
                        type: HalPin.Float
                    }

                    HalPin {
                        id: jogDistancePin
                        name: "distance"
                        direction: HalPin.IO
                        type: HalPin.Float
                    }

                    HalPin {
                        id: jogDirectionPin
                        name: "direction"
                        direction: HalPin.IO
                        type: HalPin.Bit
                    }

                    HalPin {
                        id: jogTriggerPin
                        name: "trigger"
                        direction: HalPin.IO
                        type: HalPin.Bit
                    }

                    HalPin {
                        id: jogContinousPin
                        name: "continous"
                        direction: HalPin.Out
                        type: HalPin.Bit
                    }

                    HalPin {
                        id: jogDtgPin
                        name: "dtg"
                        direction: HalPin.In
                        type: HalPin.Float
                    }

                    HalPin {
                        id: jogMaxVelocityPin
                        name: "max-velocity"
                        direction: HalPin.In
                        type: HalPin.Float
                    }

                    HalPin {
                        id: jogExtruderEnable
                        name: "extruder-en"
                        direction: HalPin.IO
                        type: HalPin.Bit
                    }

                    Label {
                        anchors.centerIn: parent
                        text: eName
                        font.bold: true
                    }

                    ColumnLayout {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        height: parent.height / (numberModel.length*2+1) * numberModel.length
                        width: parent.width
                        spacing: 0

                        Repeater {
                            model: numberModelReverse
                            Button {
                                property double distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                                property bool direction: false
                                Layout.preferredWidth: parent.height / numberModel.length * ((numberModel.length - index - 1) * 0.2 + 1)
                                Layout.fillHeight: true
                                Layout.alignment: Qt.AlignHCenter
                                enabled: homeXButton.enabled
                                text: numberModelReverse[index]
                                style: CustomStyle { baseColor: axisColors[extruderControl.axisIndex]; darkness: (numberModel.length-index-1)*0.06 }
                                onClicked: {
                                    if (distance !== 0) {
                                        jogDistancePin.value = distance
                                        jogDirectionPin.value = direction
                                        jogTriggerPin.value = !jogTriggerPin.value
                                    }
                                }
                                onPressedChanged: {
                                    if (distance === 0) {
                                        jogDirectionPin.value = direction
                                        jogContinousPin.value = pressed
                                    }
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height / (numberModel.length*2+1) * numberModel.length
                        width: parent.width
                        spacing: 0

                        Repeater {
                            model: numberModel
                            Button {
                                property double distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                                property bool direction: true
                                Layout.preferredWidth: parent.height / numberModel.length * (index*0.2+1)
                                Layout.fillHeight: true
                                Layout.alignment: Qt.AlignHCenter
                                enabled: homeXButton.enabled
                                text: "-" + numberModel[index]
                                style: CustomStyle { baseColor: axisColors[extruderControl.axisIndex]; darkness: index*0.06 }
                                onClicked: {
                                    if (distance !== 0) {
                                        jogDistancePin.value = distance
                                        jogDirectionPin.value = direction
                                        jogTriggerPin.value = !jogTriggerPin.value
                                    }
                                }
                                onPressedChanged: {
                                    if (distance === 0) {
                                        jogDirectionPin.value = direction
                                        jogContinousPin.value = pressed
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Label {
            text: qsTr("Jog Speed")
            id: label
        }

        RowLayout {
            Label {
                text: axisNames[0] + "/" + axisNames[1]
                font.bold: true
            }

            SpinBox {
                Layout.fillWidth: true
                id: xVelocitySpin
                enabled: xVelocityHandler.enabled
                minimumValue: xVelocityHandler.minimumValue
                maximumValue: xVelocityHandler.maximumValue
                suffix: xVelocityHandler.units

                onEditingFinished: {            // remove the focus from this control
                    label.forceActiveFocus()
                    label.focus = true
                }

                Binding { target: xVelocitySpin; property: "value"; value: xVelocityHandler.value }
                Binding { target: xVelocityHandler; property: "value"; value: xVelocitySpin.value }
                Binding { target: yVelocityHandler; property: "value"; value: xVelocitySpin.value }

                JogVelocityHandler {
                    id: xVelocityHandler
                    axis: 0
                }

                JogVelocityHandler {
                    id: yVelocityHandler
                    axis: 1
                }
            }

            Label {
                text: axisNames[2]
                font.bold: true
                visible: zVisible
            }

            SpinBox {
                Layout.fillWidth: true
                id: zVelocitySpin
                enabled: zVelocityHandler.enabled
                visible: zVisible
                minimumValue: zVelocityHandler.minimumValue
                maximumValue: zVelocityHandler.maximumValue
                suffix: zVelocityHandler.units

                onEditingFinished: {            // remove the focus from this control
                    label.forceActiveFocus()
                    label.focus = true
                }

                Binding { target: zVelocitySpin; property: "value"; value: zVelocityHandler.value }
                Binding { target: zVelocityHandler; property: "value"; value: zVelocitySpin.value }

                JogVelocityHandler {
                    id: zVelocityHandler
                    axis: 2
                }
            }

            Label {
                text: axisNames[3]
                font.bold: true
                visible: aVisible
            }

            SpinBox {
                Layout.fillWidth: true
                id: aVelocitySpin
                visible: aVisible
                enabled: aVelocityHandler.enabled
                minimumValue: aVelocityHandler.minimumValue
                maximumValue: aVelocityHandler.maximumValue
                suffix: aVelocityHandler.units

                onEditingFinished: {            // remove the focus from this control
                    label.forceActiveFocus()
                    label.focus = true
                }

                Binding { target: aVelocitySpin; property: "value"; value: aVelocityHandler.value }
                Binding { target: aVelocityHandler; property: "value"; value: aVelocitySpin.value }

                JogVelocityHandler {
                    id: aVelocityHandler
                    axis: 3
                }
            }

            Label {
                text: eName
                font.bold: true
                visible: eVisible
            }

            SpinBox {
                id: jogVelocitySpin
                Layout.fillWidth: true
                visible: eVisible
                minimumValue: 0
                maximumValue: jogMaxVelocityPin.value
                suffix: eUnits

                Binding { target: jogVelocityPin; property: "value"; value: jogVelocitySpin.value }
                Binding { target: jogVelocitySpin; property: "value"; value: jogVelocityPin.value }

                onEditingFinished: {            // remove the focus from this control
                    label.forceActiveFocus()
                    label.focus = true
                }
            }

        }
    }

}
