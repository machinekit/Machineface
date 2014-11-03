import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import Machinekit.Application.Controls 1.0

RowLayout {
    Label {
        id: label1
        text: qsTr("X/Y:")
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
            label1.forceActiveFocus()
            label1.focus = true
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
        text: qsTr("Z:")
        font.bold: true
    }

    SpinBox {
        Layout.fillWidth: true
        id: zVelocitySpin
        enabled: zVelocityHandler.enabled
        minimumValue: zVelocityHandler.minimumValue
        maximumValue: zVelocityHandler.maximumValue
        suffix: zVelocityHandler.units

        onEditingFinished: {            // remove the focus from this control
            label1.forceActiveFocus()
            label1.focus = true
        }

        Binding { target: zVelocitySpin; property: "value"; value: zVelocityHandler.value }
        Binding { target: zVelocityHandler; property: "value"; value: zVelocitySpin.value }

        JogVelocityHandler {
            id: zVelocityHandler
            axis: 2
        }
    }

    Label {
        text: qsTr("A:")
        font.bold: true
    }

    SpinBox {
        Layout.fillWidth: true
        id: aVelocitySpin
        enabled: aVelocityHandler.enabled
        minimumValue: aVelocityHandler.minimumValue
        maximumValue: aVelocityHandler.maximumValue
        suffix: aVelocityHandler.units

        onEditingFinished: {            // remove the focus from this control
            label1.forceActiveFocus()
            label1.focus = true
        }

        Binding { target: aVelocitySpin; property: "value"; value: aVelocityHandler.value }
        Binding { target: aVelocityHandler; property: "value"; value: aVelocitySpin.value }

        JogVelocityHandler {
            id: aVelocityHandler
            axis: 3
        }
    }
}
