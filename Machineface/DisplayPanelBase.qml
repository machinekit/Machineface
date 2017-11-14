import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

ScrollView {
    default property alias data: layout.data
    id: root
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    implicitWidth: container.width

    Item {
        id: container
        implicitWidth: layout.width + Screen.pixelDensity * 8
        implicitHeight: layout.height + Screen.pixelDensity * 2

        ColumnLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            id: layout
            spacing: Screen.pixelDensity
        }
    }
}
