import QtQuick 2.0
import QtQuick.Controls 1.1

Menu {
    id: testMenu
    title: qsTr("Menu")

    MenuItem {
        text: qsTr("&Disconnect")
        onTriggered: {
            window.disconnect()
        }
    }

    MenuItem {
        text: qsTr("&About Machineface")
        onTriggered: {
           aboutDialog.open()
        }
    }

    MenuItem {
        text: qsTr("E&xit")
        shortcut: "Ctrl+Q"
        onTriggered: {
            Qt.quit()
        }
    }
}

