import QtQuick 2.0
import Machinekit.Application.Controls 1.0

Item {
    id: keyHandler
    property string baseKey: "Right"
    property int axis: 0
    property var axisHandler: xyHandler
    property int direction: 1

    JogAction {
        property int index: 0
        property bool available: (keyHandler.axisHandler.distanceModel.length-1) > index
        shortcut: available ? "Alt+" + keyHandler.baseKey : ""
        axis: keyHandler.axis
        distance: available ? keyHandler.axisHandler.distanceModel[index] * keyHandler.direction : 0
    }

    JogAction {
        property int index: 1
        property bool available: (keyHandler.axisHandler.distanceModel.length-1) > index
        shortcut: available ? keyHandler.baseKey : ""
        axis: keyHandler.axis
        distance: available ? keyHandler.axisHandler.distanceModel[index] * keyHandler.direction : 0
    }

    JogAction {
        property int index: 2
        property bool available: (keyHandler.axisHandler.distanceModel.length-1) > index
        shortcut: available ? "Shift+" + keyHandler.baseKey : ""
        axis: keyHandler.axis
        distance: available ? keyHandler.axisHandler.distanceModel[index] * keyHandler.direction : 0
    }

    JogAction {
        property int index: 3
        property bool available: (keyHandler.axisHandler.distanceModel.length-1) > index
        shortcut: available ? "Ctrl+" + keyHandler.baseKey : ""
        axis: keyHandler.axis
        distance: available ? keyHandler.axisHandler.distanceModel[index] * keyHandler.direction : 0
    }
}
