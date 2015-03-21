import QtQuick 2.0
import QtKnobs 1.0
import Machinekit.Application.Controls 1.0

Knob {
    id: root
    style: Knob.Pie
    pieType: Knob.Flat
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
}

