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
    property color specialColor: "#BBBBBB"
    property color specialColor2: "#FFFF88"
    property var axisNames: ["X", "Y", "Z", "A"]
    property string eName: "E"
    property string eUnits: "mm/s"
    property bool zVisible: status.synced ? status.config.axes > 2 : true
    property bool aVisible: status.synced ? status.config.axes > 3 : true
    property bool eVisible: halRemoteComponent.connected || eWasConnected
    property bool eWasConnected: false
    property bool eEnabled: halRemoteComponent.connected
    property int buttonBaseHeight: container.height / (numberModel.length*2+1)

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
        onConnectedChanged: root.eWasConnected = true
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

                Button {
                    anchors.centerIn: parent
                    height: root.buttonBaseHeight * 0.95
                    width: height
                    text: axisNames[0] + axisNames[1]
                    style: CustomStyle { baseColor: root.specialColor; radius: 1000; boldFont: true }
                    enabled: xyZeroAction.enabled
                    tooltip: qsTr("Move to X0 Y0")

                    onClicked: xyZeroAction.trigger()

                    MdiCommandAction {
                        id: xyZeroAction
                        mdiCommand: "G0 " + axisNames[0] + "0 " + axisNames[1] + "0"
                        enableHistory: false
                    }
                }

                HomeButton {
                    id: homeXButton
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: parent.height * 0.2
                    height: width
                    axis: 0
                    axisName: axisNames[0]
                    color: axisColors[0]
                }

                HomeButton {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: parent.height * 0.2
                    height: width
                    axis: 1
                    axisName: axisNames[1]
                    color: axisColors[1]
                }

                HomeButton {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width: parent.height * 0.2
                    height: width
                    axis: 2
                    axisName: axisNames[2]
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
                    width: root.buttonBaseHeight * numberModel.length
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
                    width: root.buttonBaseHeight * numberModel.length
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
                    height: root.buttonBaseHeight * numberModel.length
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
                    height: root.buttonBaseHeight * numberModel.length
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

                        Button {
                            anchors.centerIn: parent
                            height: root.buttonBaseHeight * 0.95
                            width: height
                            text: axisNames[2+index]
                            style: CustomStyle { baseColor: root.specialColor2; radius: 1000; boldFont: true }
                            enabled: zZeroAction.enabled
                            tooltip: qsTr("Set current Z position to 0")

                            onClicked: zZeroAction.trigger()

                            MdiCommandAction {
                                id: zZeroAction
                                mdiCommand: "G10 L20 P0 " + axisNames[2+index] + "0"
                                enableHistory: false
                            }
                        }

                        ColumnLayout {
                            id: axisTopLayout
                            anchors.top: parent.top
                            anchors.left: parent.left
                            height: root.buttonBaseHeight * numberModel.length
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
                            height: root.buttonBaseHeight * numberModel.length
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
                enabled: eEnabled

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
                    name: "continuous"
                    direction: HalPin.IO
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
                    id: jogExtruderCountPin
                    name: "extruder-count"
                    direction: HalPin.In
                    type: HalPin.U32
                }

                HalPin {
                    id: jogExtruderSelPin
                    name: "extruder-sel"
                    direction: HalPin.In
                    type: HalPin.S32
                }

                Label {
                    anchors.centerIn: parent
                    text: eName
                    font.bold: true
                    enabled: homeXButton.enabled
                }

                ColumnLayout {
                    id: extruderTopLayout
                    anchors.top: parent.top
                    anchors.left: parent.left
                    height: root.buttonBaseHeight * numberModel.length
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
                            enabled: homeXButton.enabled && !jogTriggerPin.value
                                     && (!jogContinousPin.value || (distance == 0 && jogDirectionPin.value))
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
                    height: root.buttonBaseHeight * numberModel.length
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
                            enabled: homeXButton.enabled && !jogTriggerPin.value
                                     && (!jogContinousPin.value || (distance == 0 && !jogDirectionPin.value))
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

        RowLayout {
            spacing: Screen.pixelDensity * 3

            Label {
                text: qsTr("Velocity" )
                font.bold: true
            }

            Repeater {
                model: status.synced ? status.config.axes : 0

                JogVelocityKnob {
                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                    color: axisColors[index]
                    axis: index
                    axisName: axisNames[index]
                }
            }

            JogKnob {
                id: jogVelocityKnob
                Layout.fillHeight: true
                Layout.preferredWidth: height
                visible: eVisible
                enabled: eEnabled
                minimumValue: 1
                maximumValue: jogMaxVelocityPin.value
                color: axisColors[extruderControl.axisIndex]
                axisName: eName

                Binding { target: jogVelocityPin; property: "value"; value: jogVelocityKnob.value }
                Binding { target: jogVelocityKnob; property: "value"; value: jogVelocityPin.value }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                RowLayout {
                    anchors.fill: parent
                    spacing: Screen.pixelDensity * 1
                    visible: eVisible && (jogExtruderCountPin.value > 1)
                    enabled: eEnabled

                    Repeater {
                        model: jogExtruderCountPin.value

                        Button {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: index
                            style: CustomStyle { baseColor: axisColors[extruderControl.axisIndex] }
                            enabled: toolSelectAction.enabled
                            checked: jogExtruderSelPin.value === index

                            onClicked: toolSelectAction.trigger()

                            MdiCommandAction {
                                id: toolSelectAction
                                mdiCommand: "T" + index
                                enableHistory: false
                            }
                        }
                    }
                }
            }
        }
    }
}
