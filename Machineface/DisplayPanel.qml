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
        componentName: "fdm-e0"
        labelName: "Extruder 0"
        logHeight: parent.height * 0.25
    }

    TemperatureControl {
        componentName: "fdm-hbp"
        labelName: "Heated Bed"
        logHeight: parent.height * 0.25
    }

    FanControl {
        componentName: "fdm-f0"
        labelName: "Fan 0"
    }

    LightControl {
        componentName: "fdm-l0"
        labelName: "Light 0"
    }

    Item {
        Layout.fillHeight: true
    }
}
