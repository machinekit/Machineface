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
    property var numberModel: numberModelBase.concat(["∞"])
    property var numberModelBase: status.synced ? status.config.increments.split(" ") : []
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
        visible: root.status.synced

        Item {
            id: container
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(width / 1.6, parent.height)

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

                HomeButton {
                    id: homeXButton
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: parent.height * 0.2
                    height: width
                    axis: 0
                    axisName: "X"
                    color: axisColors[0]
                }

                HomeButton {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: parent.height * 0.2
                    height: width
                    axis: 1
                    axisName: "Y"
                    color: axisColors[1]
                }

                HomeButton {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width: parent.height * 0.2
                    height: width
                    axis: 2
                    axisName: "Z"
                    color: axisColors[2]
                }

                HomeButton {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: parent.height * 0.2
                    height: width
                    axis: -1
                    axisName: "All"
                    color: "white"
                }

                RowLayout {
                    id: xAxisRightLayout
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.height / (numberModel.length*2+1) * numberModel.length
                    height: width
                    spacing: 0
                    Repeater {
                        model: numberModel
                        JogButton {
                            Layout.fillWidth: true
                            Layout.preferredHeight: xAxisRightLayout.height / numberModel.length * (index+1)
                            text: numberModel[index]
                            axis: 0
                            distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                            direction: 1
                            style: CustomStyle { baseColor: axisColors[0]; darkness: index*0.06 }
                        }
                    }
                }

                RowLayout {
                    id: xAxisLeftLayout
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.height / (numberModel.length*2+1) * numberModel.length
                    height: width
                    spacing: 0
                    Repeater {
                        model: numberModelReverse
                        JogButton {
                            Layout.fillWidth: true
                            Layout.preferredHeight: xAxisLeftLayout.width / numberModel.length * (numberModel.length-index)
                            text: "-" + numberModelReverse[index]
                            axis: 0
                            distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                            direction: -1
                            style: CustomStyle { baseColor: axisColors[0]; darkness: (numberModel.length-index-1)*0.06 }
                        }
                    }
                }

                ColumnLayout {
                    id: yAxisTopLayout
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height / (numberModel.length*2+1) * numberModel.length
                    width: height
                    spacing: 0
                    Repeater {
                        model: numberModelReverse
                        JogButton {
                            Layout.preferredWidth: yAxisTopLayout.width / numberModel.length * (numberModel.length-index)
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
                    id: yAxisBottomLayout
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height / (numberModel.length*2+1) * numberModel.length
                    width: height
                    spacing: 0
                    Repeater {
                        model: numberModel
                        JogButton {
                            Layout.preferredWidth: yAxisBottomLayout.width / numberModel.length * (index+1)
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
                property int axes: status.synced ? status.config.axes - 2 : 2

                id: axisRowLayout
                anchors.left: mainItem.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.leftMargin: parent.height * 0.03
                width: parent.height * 0.20 * axisRowLayout.axes
                spacing: parent.height * 0.03

                Repeater {
                    model: axisRowLayout.axes

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
                            id: axisTopLayout
                            anchors.top: parent.top
                            anchors.left: parent.left
                            height: parent.height / (numberModel.length*2+1) * numberModel.length
                            width: parent.width
                            spacing: 0
                            Repeater {
                                model: numberModelReverse
                                JogButton {
                                    Layout.preferredWidth: axisTopLayout.height / numberModel.length * ((numberModel.length - index - 1) * 0.2 + 1)
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
                            id: axisBottomLayout
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: parent.height / (numberModel.length*2+1) * numberModel.length
                            width: parent.width
                            spacing: 0
                            Repeater {
                                model: numberModel
                                JogButton {
                                    Layout.preferredWidth: axisBottomLayout.height / numberModel.length * (index*0.2+1)
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

              }
            Item {
                property int axisIndex: status.synced ? status.config.axes : 0
                property double extruderVelocity: 5.0

                id: extruderControl
                anchors.left: axisRowLayout.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.leftMargin: parent.height * 0.03
                width: parent.height * 0.20
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

                Label {
                    anchors.centerIn: parent
                    text: eName
                    font.bold: true
                }

                ColumnLayout {
                    id: extruderTopLayout
                    anchors.top: parent.top
                    anchors.left: parent.left
                    height: parent.height / (numberModel.length*2+1) * numberModel.length
                    width: parent.width
                    spacing: 0

                    Repeater {
                        model: numberModelReverse
                        ExtruderJogButton {
                            Layout.preferredWidth: extruderBottomLayout.height / numberModel.length * ((numberModel.length - index - 1) * 0.2 + 1)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                            direction: true
                            enabled: homeXButton.enabled
                            text: "-" + numberModelReverse[index]
                            style: CustomStyle {
                                baseColor: axisColors[extruderControl.axisIndex];
                                darkness: (numberModel.length-index-1)*0.06 }
                        }
                    }
                }

                ColumnLayout {
                    id: extruderBottomLayout
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height / (numberModel.length*2+1) * numberModel.length
                    width: parent.width
                    spacing: 0

                    Repeater {
                        model: numberModel
                        ExtruderJogButton {
                            Layout.preferredWidth: extruderBottomLayout.height / numberModel.length * (index*0.2+1)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                            direction: false
                            enabled: homeXButton.enabled
                            text: numberModel[index]
                            style: CustomStyle {
                                baseColor: axisColors[extruderControl.axisIndex];
                                darkness: index*0.06
                            }
                        }
                    }
                }
            }

        }
        Item {
            Layout.fillHeight: true
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
