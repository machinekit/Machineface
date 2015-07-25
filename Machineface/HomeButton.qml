import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.Application.Controls 1.0

Button {
    property int axis: 0
    property string axisName: "X"
    property string color: "green"
    property int fontSize: 10

    id: root

    SystemPalette { id: systemPalette }

    action: HomeAxisAction { id: homeAction; axis: root.axis }
    text: axisName
    style: CustomStyle {
        baseColor: color
        textColor: !homeAction.homed ? systemPalette.text : "gray"
        boldFont: true
        fontSize: root.fontSize
        fontIcon: "\ue88a"
        fontIconColor: !homeAction.homed ? systemPalette.text : "gray"
    }
    iconSource: " "
}

