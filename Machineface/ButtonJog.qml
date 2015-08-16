import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.0
import QtQml 2.2
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Service 1.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0

ApplicationItem {
    property var numberModel: defaultHandler.incrementsModel //numberModelBase.concat(["inf"])
    property var numberModelReverse: defaultHandler.incrementsModelReverse
    property var axisColors: ["#F5A9A9", "#A9F5F2", "#81F781", "#D2B48C", "#D28ED0", "#CFCC67"]
    property color allColor: "#DDD"
    property color specialColor: "#BBBBBB"
    property var axisNames: ["X", "Y", "Z", "A", "B", "C", "U", "V", "W"] // should come from INI/config
    property string eName: "E"
    property string eUnits: "mm/s"
    property bool zVisible: status.synced ? status.config.axes > 2 : true
    property bool aVisible: status.synced ? status.config.axes > 3 : true
    property bool eVisible: halRemoteComponent.connected || eWasConnected
    property bool eWasConnected: false
    property bool eEnabled: halRemoteComponent.connected
    property int buttonBaseHeight: container.height / (numberModel.length*2+1)

    property int baseSize: Math.min(width, height)
    property int fontSize: baseSize * 0.028

    id: root

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

    JogDistanceHandler {
        id: defaultHandler
        continousText: "inf"
        core: root.core
        axis: -1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity
        visible: root.status.synced

        Item {
            id: container
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: Math.min(width / 1.6, parent.height)

            Item {
                id: mainItem
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: height

                JogDistanceHandler {
                    property int buttonBaseSize: container.height / (incrementsModel.length*2+1)

                    id: xyHandler
                    continousText: "inf"
                    core: root.core
                    axis: 0
                }

                JogKeyHandler {
                    baseKey: "Right"
                    axis: 0
                    axisHandler: xyHandler
                    direction: 1
                }

                JogKeyHandler {
                    baseKey: "Left"
                    axis: 0
                    axisHandler: xyHandler
                    direction: -1
                }

                JogKeyHandler {
                    baseKey: "Up"
                    axis: 1
                    axisHandler: xyHandler
                    direction: 1
                }

                JogKeyHandler {
                    baseKey: "Down"
                    axis: 1
                    axisHandler: xyHandler
                    direction: -1
                }

                Button {
                    anchors.centerIn: parent
                    height: xyHandler.buttonBaseSize * 0.95
                    width: height
                    text: axisNames[0] + axisNames[1]
                    style: CustomStyle { baseColor: root.specialColor; radius: 1000; boldFont: true; fontSize: root.fontSize }
                    enabled: xyZeroAction.enabled
                    tooltip: qsTr("Move ") + axisNames[0] + qsTr(" and ") + axisNames[1] + qsTr(" axis to 0")

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
                    fontSize: root.fontSize
                }

                HomeButton {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: parent.height * 0.2
                    height: width
                    axis: 1
                    axisName: axisNames[1]
                    color: axisColors[1]
                    fontSize: root.fontSize
                }

                HomeButton {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width: parent.height * 0.2
                    height: width
                    axis: 2
                    axisName: axisNames[2]
                    color: axisColors[2]
                    fontSize: root.fontSize
                }

                HomeButton {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: parent.height * 0.2
                    height: width
                    axis: -1
                    axisName: "All"
                    color: "white"
                    fontSize: root.fontSize
                }

                RowLayout {
                    id: xAxisRightLayout
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: xyHandler.buttonBaseSize * xyHandler.incrementsModel.length
                    height: width
                    spacing: 0

                    Repeater {
                        model: xyHandler.incrementsModel
                        JogButton {
                            property string modelText: xyHandler.incrementsModel[index]
                            Layout.fillWidth: true
                            Layout.preferredHeight: xAxisRightLayout.height / xyHandler.incrementsModel.length * (index+1)
                            text: modelText === "inf" ? "" : modelText
                            axis: 0
                            distance: modelText === "inf" ? 0 : modelText
                            direction: 1
                            style: CustomStyle {
                                baseColor: axisColors[0]
                                darkness: index*0.06
                                fontSize: root.fontSize
                                fontIcon: modelText == "inf" ? "\ue315" : ""
                                fontIconSize: root.fontSize * 2.5
                            }
                        }
                    }
                }

                RowLayout {
                    id: xAxisLeftLayout
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: xyHandler.buttonBaseSize * xyHandler.incrementsModelReverse.length
                    height: width
                    spacing: 0
                    Repeater {
                        model: xyHandler.incrementsModelReverse
                        JogButton {
                            property string modelText: xyHandler.incrementsModelReverse[index]
                            Layout.fillWidth: true
                            Layout.preferredHeight: xAxisLeftLayout.width / xyHandler.incrementsModelReverse.length * (xyHandler.incrementsModelReverse.length-index)
                            text: modelText === "inf" ? "" : "-" + modelText
                            axis: 0
                            distance: modelText === "inf" ? 0 : modelText
                            direction: -1
                            style: CustomStyle {
                                baseColor: axisColors[0]
                                darkness: (numberModel.length-index-1)*0.06
                                fontSize: root.fontSize
                                fontIcon: modelText == "inf" ? "\ue314" : ""
                                fontIconSize: root.fontSize * 2.5
                            }
                        }
                    }
                }

                ColumnLayout {
                    id: yAxisTopLayout
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: xyHandler.buttonBaseSize * xyHandler.incrementsModelReverse.length
                    height: width
                    spacing: 0
                    Repeater {
                        model: xyHandler.incrementsModelReverse
                        JogButton {
                            property string modelText: xyHandler.incrementsModelReverse[index]
                            Layout.preferredWidth: yAxisTopLayout.width / xyHandler.incrementsModelReverse.length * (xyHandler.incrementsModelReverse.length-index)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            text: modelText == "inf" ? "" : modelText
                            axis: 1
                            distance: modelText == "inf" ? 0 : modelText
                            direction: 1
                            style: CustomStyle {
                                baseColor: axisColors[1]
                                darkness: (xyHandler.incrementsModelReverse.length-index-1)*0.06
                                fontSize: root.fontSize
                                fontIcon: modelText == "inf" ? "\ue316" : ""
                                fontIconSize: root.fontSize * 2.5
                            }
                        }
                    }
                }

                ColumnLayout {
                    id: yAxisBottomLayout
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: xyHandler.buttonBaseSize * xyHandler.incrementsModel.length
                    width: height
                    spacing: 0
                    Repeater {
                        model: xyHandler.incrementsModel
                        JogButton {
                            property string modelText: xyHandler.incrementsModel[index]
                            Layout.preferredWidth: yAxisBottomLayout.width / xyHandler.incrementsModel.length * (index+1)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            text: modelText == "inf" ? "" : "-" + modelText
                            axis: 1
                            distance: modelText == "inf" ? 0 : modelText
                            direction: -1
                            style: CustomStyle {
                                baseColor: axisColors[1]
                                darkness: index*0.06
                                fontSize: root.fontSize
                                fontIcon: modelText == "inf" ? "\ue313" : ""
                                fontIconSize: root.fontSize * 2.5
                            }
                        }
                    }
                }
            }

            RowLayout {
                property int axes: status.synced ? status.config.axes - 2 : 1

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

                        JogDistanceHandler {
                            property int buttonBaseHeight: container.height / (incrementsModel.length*2+1)

                            id: axisHandler
                            continousText: "inf"
                            core: root.core
                            axis: axisIndex+2
                        }

                        JogKeyHandler {
                            baseKey: "PgUp"
                            axis: axisIndex+2
                            axisHandler: axisHandler
                            direction: 1
                            enabled: axis == 2
                        }

                        JogKeyHandler {
                            baseKey: "PgDown"
                            axis: axisIndex+2
                            axisHandler: axisHandler
                            direction: -1
                            enabled: axis == 2
                        }

                        Button {
                            anchors.centerIn: parent
                            height: axisHandler.buttonBaseHeight * 0.95
                            width: height
                            text: axisNames[2+index]
                            style: CustomStyle { baseColor: root.axisColors[2+index]; radius: 1000; boldFont: true; fontSize: root.fontSize }
                            enabled: zZeroAction.enabled
                            tooltip: qsTr("Select axis action")

                            onClicked: zActionMenu.popup()

                            MdiCommandAction {
                                id: zZeroAction
                                enableHistory: false
                            }

                            Menu {
                                id: zActionMenu
                                title: qsTr("Select Action")

                                MenuItem {
                                    text: qsTr("Touch off ") + axisNames[2+index] + qsTr(" axis")
                                    onTriggered: {
                                        zZeroAction.mdiCommand = "G10 L20 P0 " + axisNames[2+index] + "0"
                                        zZeroAction.trigger()
                                    }
                                }

                                MenuItem {
                                    text: qsTr("Move ") + axisNames[2+index] + qsTr(" axis to 0")
                                    onTriggered: {
                                        zZeroAction.mdiCommand = "G0 " + axisNames[2+index] + "0"
                                        zZeroAction.trigger()
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            id: axisTopLayout
                            anchors.top: parent.top
                            anchors.left: parent.left
                            height: axisHandler.buttonBaseHeight * axisHandler.incrementsModelReverse.length
                            width: parent.width
                            spacing: 0
                            Repeater {
                                model: axisHandler.incrementsModelReverse
                                JogButton {
                                    property string modelText: axisHandler.incrementsModelReverse[index]
                                    Layout.preferredWidth: axisTopLayout.height / axisHandler.incrementsModelReverse.length * ((axisHandler.incrementsModelReverse.length - index - 1) * 0.2 + 1)
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter
                                    text: modelText == "inf" ? "" : modelText
                                    axis: 2 + axisIndex
                                    distance: modelText === "inf" ? 0 : modelText
                                    direction: 1
                                    style: CustomStyle {
                                        baseColor: axisColors[axisIndex+2]
                                        darkness: (axisHandler.incrementsModelReverse.length-index-1)*0.06
                                        fontSize: root.fontSize
                                        fontIcon: modelText == "inf" ? "\ue316" : ""
                                        fontIconSize: root.fontSize * 2.5
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            id: axisBottomLayout
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: axisHandler.buttonBaseHeight * axisHandler.incrementsModel.length
                            width: parent.width
                            spacing: 0
                            Repeater {
                                model: axisHandler.incrementsModel
                                JogButton {
                                    property string modelText: axisHandler.incrementsModel[index]
                                    Layout.preferredWidth: axisBottomLayout.height / axisHandler.incrementsModel.length * (index*0.2+1)
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter
                                    text: modelText == "inf" ? "" : "-" + modelText
                                    axis: axisIndex + 2
                                    distance: modelText === "inf" ? 0 : modelText
                                    direction: -1
                                    style: CustomStyle {
                                        baseColor: axisColors[axisIndex+2]
                                        darkness: index*0.06
                                        fontSize: root.fontSize
                                        fontIcon: modelText == "inf" ? "\ue313" : ""
                                        fontIconSize: root.fontSize * 2.5
                                    }
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

                Button {
                    anchors.centerIn: parent
                    height: root.buttonBaseHeight * 0.95
                    width: height
                    text: eName + jogExtruderSelPin.value
                    style: CustomStyle {
                        baseColor: axisColors[extruderControl.axisIndex];
                        radius: 1000
                        boldFont: true
                        fontSize: root.fontSize
                    }
                    onClicked: toolSelectMenu.popup()
                    enabled: toolSelectAction.enabled
                    tooltip: qsTr("Change extruder")

                    MdiCommandAction {
                        property int index: 0

                        id: toolSelectAction
                        mdiCommand: "T" + index
                        enableHistory: false
                    }

                    Menu {
                        id: toolSelectMenu
                        title: qsTr("Select extruder")

                        Instantiator {
                                model: jogExtruderCountPin.value
                                MenuItem {
                                    text: qsTr("Extruder ") + index
                                    checkable: true
                                    checked: jogExtruderSelPin.value === index
                                    onTriggered: {
                                        toolSelectAction.index = index
                                        toolSelectAction.trigger()
                                    }
                                }
                                onObjectAdded: toolSelectMenu.insertItem(index, object)
                                onObjectRemoved: toolSelectMenu.removeItem(object)
                            }
                    }
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
                            property string modelText: numberModelReverse[index]
                            Layout.preferredWidth: extruderBottomLayout.height / numberModel.length * ((numberModel.length - index - 1) * 0.2 + 1)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            distance: modelText === "inf" ? 0 : modelText
                            direction: true
                            enabled: homeXButton.enabled && !jogTriggerPin.value
                                     && (!jogContinousPin.value || (distance == 0 && jogDirectionPin.value))
                            text: modelText == "inf" ? "" : "-" + modelText
                            style: CustomStyle {
                                baseColor: axisColors[extruderControl.axisIndex];
                                darkness: (numberModel.length-index-1)*0.06
                                fontSize: root.fontSize
                                fontIcon: modelText == "inf" ? "\ue316" : ""
                                fontIconSize: root.fontSize * 2.5
                            }
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
                            property string modelText: numberModel[index]
                            Layout.preferredWidth: extruderBottomLayout.height / numberModel.length * (index*0.2+1)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            distance: modelText === "inf" ? 0 : modelText
                            direction: false
                            enabled: homeXButton.enabled && !jogTriggerPin.value
                                     && (!jogContinousPin.value || (distance == 0 && !jogDirectionPin.value))
                            text: modelText == "inf" ? "" : modelText
                            style: CustomStyle {
                                baseColor: axisColors[extruderControl.axisIndex];
                                darkness: index*0.06
                                fontSize: root.fontSize
                                fontIcon: modelText == "inf" ? "\ue313" : ""
                                fontIconSize: root.fontSize * 2.5
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            spacing: Screen.pixelDensity * 3
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.preferredHeight: root.baseSize * 0.18

            Label {
                text: qsTr("Velocity" )
                font.bold: true
                font.pixelSize: root.fontSize
            }

            Repeater {
                model: status.synced ? status.config.axes : 0

                JogVelocityKnob {
                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                    color: axisColors[index]
                    axis: index
                    axisName: axisNames[index]
                    font.pixelSize: root.fontSize
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
                defaultValue: 3.0
                color: axisColors[extruderControl.axisIndex]
                axisName: eName + jogExtruderSelPin.value
                font.pixelSize: root.fontSize

                Binding { target: jogVelocityPin; property: "value"; value: jogVelocityKnob.value }
                Binding { target: jogVelocityKnob; property: "value"; value: jogVelocityPin.value }
            }

            JogKnob {
                id: feedrateKnob
                Layout.fillHeight: true
                Layout.preferredWidth: height
                minimumValue: feedrateHandler.minimumValue
                maximumValue: feedrateHandler.maximumValue
                defaultValue: 1.0
                enabled: feedrateHandler.enabled
                color: allColor
                axisName: ""
                font.pixelSize: root.fontSize
                stepSize: 0.05
                decimals: 2
                text: (value * 100).toFixed(0) + "%"

                FeedrateHandler {
                    id: feedrateHandler
                }

                Binding { target: feedrateKnob; property: "value"; value: feedrateHandler.value }
                Binding { target: feedrateHandler; property: "value"; value: feedrateKnob.value }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
