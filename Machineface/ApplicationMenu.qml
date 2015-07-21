import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.Application.Controls 1.0

Menu {
    id: testMenu
    title: qsTr("Menu")

    MenuItem {
        text: qsTr("&Disconnect")
        iconName: "network-disconnect"
        onTriggered: {
            window.disconnect()
        }
    }

    MenuItem {
        text: qsTr("&About Machineface")
        iconName: "help-about"
        onTriggered: {
           aboutDialog.open()
        }
    }

    MenuItem {
        text: qsTr("Sh&utdown")
        action: ShutdownAction {}
        onTriggered: {
            window.disconnect()
        }
    }

    MenuItem {
        text: qsTr("E&xit")
        iconName: "application-exit"
        shortcut: "Ctrl+Q"
        onTriggered: {
            Qt.quit()
        }
    }
}

