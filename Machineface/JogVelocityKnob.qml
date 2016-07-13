import QtQuick 2.0
import Machinekit.Controls 1.0
import Machinekit.Application.Controls 1.0

JogKnob {
    property int axis: 0
    property alias units: velocityHandler.units

    id: root
    enabled: velocityHandler.enabled
    minimumValue: velocityHandler.minimumValue
    maximumValue: velocityHandler.maximumValue

    Binding { target: root; property: "value"; value: velocityHandler.value }
    Binding { target: velocityHandler; property: "value"; value: root.value }

    JogVelocityHandler {
        id: velocityHandler
        axis: root.axis
    }

    TooltipArea {
        text: qsTr("Set " + axis + " axis velocity")
        interval: 1000
    }
}

