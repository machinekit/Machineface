import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.HalRemote 1.0
import Machinekit.Service 1.0
import Machinekit.HalRemote.Controls 1.0

Rectangle {
    property color lightColor: lightColorDialog.color

    id: root

    border.color: systemPalette.shadow
    border.width: 1
    color: systemPalette.window
    visible: false

    SystemPalette { id: systemPalette }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity
        spacing: Screen.pixelDensity

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: false

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Ok")
                onClicked: root.visible = false
            }
        }
    }
}
