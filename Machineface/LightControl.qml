import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.Controls 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Service 1.0

ColumnLayout {
    id: root
    property string componentName: "fdm-l0"
    property string labelName: "Light"
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
        onConnectedChanged:  root.wasConnected = true
    }

    ColumnLayout {
        id: container
        Layout.fillWidth: true
        enabled:  halRemoteComponent.connected

        Label {
            text: qsTr("<b>" + root.labelName + "</b>")
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
            property color color: Qt.rgba(r,g,b,w)
            property real r
            property real g
            property real b
            property real w

            id: lightColorItem

            ColorDialog {
                property color saveColor

                id: colorDialog
                showAlphaChannel: true

                onVisibleChanged: {
                    if (visible) {
                        saveColor = lightColorItem.color
                        color = saveColor
                    }
                }
                onAccepted: {
                    lightColorItem.r = color.r
                    lightColorItem.g = color.g
                    lightColorItem.b = color.b
                    lightColorItem.w = color.a
                }
                onRejected: {
                    lightColorItem.r = saveColor.r
                    lightColorItem.g = saveColor.g
                    lightColorItem.b = saveColor.b
                    lightColorItem.w = saveColor.a
                }
                onCurrentColorChanged: {
                    if (visible) {
                        lightColorItem.r = currentColor.r
                        lightColorItem.g = currentColor.g
                        lightColorItem.b = currentColor.b
                        lightColorItem.w = currentColor.a
                    }
                }
            }

            Binding { target: lightColorItem; property: "r"; value: rHalPin.value }
            Binding { target: rHalPin; property: "value"; value: lightColorItem.r }
            Binding { target: lightColorItem; property: "g"; value: gHalPin.value }
            Binding { target: gHalPin; property: "value"; value: lightColorItem.g }
            Binding { target: lightColorItem; property: "b"; value: bHalPin.value }
            Binding { target: bHalPin; property: "value"; value: lightColorItem.b }
            Binding { target: lightColorItem; property: "w"; value: wHalPin.value }
            Binding { target: wHalPin; property: "value"; value: lightColorItem.w }

            HalPin {
                id: rHalPin
                type: HalPin.Float
                direction: HalPin.IO
                name: "r"
            }

            HalPin {
                id: gHalPin
                type: HalPin.Float
                direction: HalPin.IO
                name: "g"
            }

            HalPin {
                id: bHalPin
                type: HalPin.Float
                direction: HalPin.IO
                name: "b"
            }

            HalPin {
                id: wHalPin
                type: HalPin.Float
                direction: HalPin.IO
                name: "w"
            }
        }
    }
}

