import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.Application.Controls 1.0

Menu {
    id: testMenu
    title: qsTr("Menu")

    MenuItem {
        text: qsTr("&Disconnect from Session")
        iconName: "network-disconnect"
        onTriggered: window.disconnect()
    }

    MenuItem {
        text: qsTr("&About Machineface")
        iconName: "help-about"
        onTriggered: aboutDialog.open()
    }

    MenuItem {
        text: qsTr("Sh&utdown Session")
        action: ShutdownAction {}
        onTriggered: window.shutdown()
    }

    MenuItem {
        text: qsTr("E&xit User Interface")
        iconName: "application-exit"
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit()
    }
}

