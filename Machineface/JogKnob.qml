import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.Controls 1.0
import Machinekit.Application.Controls 1.0

Knob {
    property string axisName: ""

    id: root
    style: "Pie"
    pieType: "Flat"
    suffix: ""
    textColor: systemPalette.text
    foregroundColor: Qt.lighter(root.color, 1.2)
    borderColor: Qt.darker(root.color, 1.1)
    backgroundColor: systemPalette.light
    stepSize: 1.0
    decimals: 0

    SystemPalette {
        id: systemPalette
    }

    Label {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: -parent.width * 0.1
        font.bold: true
        text: root.axisName
    }
}

