import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

Tab {
    id: tab
    title: qsTr("Jog Control")
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity

        ButtonJog {
            Layout.fillWidth: true
            Layout.fillHeight: true
            id: buttonJog
        }

        Item {
            Layout.preferredHeight: Screen.pixelDensity
        }

        Label {
            text: qsTr("Jog Speed")
            id: label
        }

        JogSpeeds {
        }


        /*VirtualJoystick {
            id: xyJoystick
            anchors.centerIn: parent
            //height: 300
            patternVisible: false
            //xEnabled: false
        }
        VirtualJoystick {
            anchors.left: xyJoystick.right
            anchors.top: xyJoystick.top
            anchors.bottom: xyJoystick.bottom
            anchors.leftMargin: 10
            patternVisible: false
            xEnabled: false
        }*/
    }
}
