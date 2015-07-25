import QtQuick 2.0
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls 1.2
import QtQuick.Window 2.0

ButtonStyle {
    property double darkness: 0.0
    property color baseColor: "red"
    property color textColor: systemPalette.text
    property int radius: -1
    property bool boldFont: false
    property int fontSize: 10
    property string fontIcon: ""
    property color fontIconColor: systemPalette.text
    property int fontIconSize: Math.min(control.width, control.height) * 0.5

    id: root

    SystemPalette {
        id: systemPalette
    }

    background: Rectangle {
        id: rect
        implicitWidth: 100
        implicitHeight: 25
        border.width: control.activeFocus ? 2 : 1
        border.color: Qt.darker(baseColor, 1.1+darkness)
        radius: root.radius == -1 ? Math.min(control.width, control.height) * 0.1 : root.radius
        gradient: Gradient {
            GradientStop { position: 0 ; color: (control.pressed || control.checked) ?
                                                    Qt.darker(baseColor, 1.05+darkness) :
                                                    Qt.darker(baseColor, 0.85+darkness) }
            GradientStop { position: 1 ; color: (control.pressed || control.checked) ?
                                                    Qt.darker(baseColor, 1.2+darkness) :
                                                    Qt.darker(baseColor, 1+darkness) }
        }
    }
    label: Item {
        opacity: control.enabled ? 1.0 : 0.4
        Label {
            id: label
            anchors.fill: parent
            anchors.margins: control.iconSource == "" ? 0 : parent.width * 0.06
            horizontalAlignment: control.iconSource == "" ? "AlignHCenter" : "AlignRight"
            verticalAlignment: control.iconSource == "" ? "AlignVCenter" : "AlignBottom"
            text: control.text
            color: root.textColor
            font.bold: root.boldFont
            font.pixelSize: root.fontSize
        }

        FontIcon {
            font.pixelSize: root.fontIconSize
            text: root.fontIcon; color: root.fontIconColor
            visible: root.fontIcon != ""
        }
    }
}
