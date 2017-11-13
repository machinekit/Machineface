import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Service 1.0

Item {
    property alias title: connectionWindow.title
    property alias toolBar: connectionWindow.toolBar
    property alias statusBar: connectionWindow.statusBar
    property alias menuBar: connectionWindow.menuBar

    id: applicationWindow
    width: 1280
    height: 800

    ConnectionWindow {
        id: connectionWindow

        anchors.fill: parent
        color: "white"
        defaultTitle: "Machineface"
        autoSelectInstance: true
        autoSelectApplication: true
        localVisible: true
        remoteVisible: false
        lookupMode: ServiceDiscovery.MulticastDNS
        instanceFilter { name: "" }

        ApplicationDescription {
            sourceDir: "./Machineface/"
        }
    }
}
