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

ColumnLayout {
    DigitalReadOut {
        Layout.fillWidth: true
    }

    TemperatureControl {
        componentName: "fdm-hbp"
        labelName: qsTr("Heated Bed")
        logHeight: parent.height * 0.25
    }

    TemperatureControl {
        componentName: "fdm-hbc"
        labelName: qsTr("Heated Chamber")
        logHeight: parent.height * 0.25
    }

    Repeater {
        model: 10
        TemperatureControl {
            componentName: "fdm-e" + index
            labelName: qsTr("Extruder %1").arg(index)
            logHeight: parent.height * 0.25
        }
    }

    Repeater {
        model: 10
        FanControl {
            componentName: "fdm-f" + index
            labelName: qsTr("Fan %1").arg(index)
        }
    }

    Repeater {
        model: 3
        LightControl {
            componentName: "fdm-l" + index
            labelName: qsTr("Light %1").arg(index)
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
