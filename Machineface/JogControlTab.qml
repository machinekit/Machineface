import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

Tab {
    id: tab
    title: qsTr("Jog")

    Item {
        ButtonJog {
            width: Math.min(parent.width * 0.85, parent.height)
            height: width
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
