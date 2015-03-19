import QtQuick 2.0
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls 1.2
import QtQuick.Window 2.0

ButtonStyle {
    property double darkness: 0.0
    property color baseColor: "red"

    id: root

    SystemPalette {
        id: systemPalette
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 25
        border.width: control.activeFocus ? 2 : 1
        border.color: Qt.darker(baseColor, 1.1+darkness)
        radius: Screen.pixelDensity
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
        Image {
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: width
            source: control.iconSource
            smooth: true
            sourceSize: Qt.size(width, height)
        }
        Label {
            anchors.fill: parent
            anchors.margins: parent.width * 0.06
            horizontalAlignment: control.iconSource == "" ? "AlignHCenter" : "AlignRight"
            verticalAlignment: control.iconSource == "" ? "AlignVCenter" : "AlignBottom"
            text: control.text
            font.bold: control.iconSource == "" ? false : true
        }
    }
}
