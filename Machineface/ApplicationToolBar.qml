import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import Machinekit.Controls 1.0
import Machinekit.Application.Controls 1.0

Rectangle {
    color: systemPalette.dark

    SystemPalette { id: systemPalette }

    ColumnLayout {
        id: toolBar
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity / 2

        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : EstopAction { id: estopAction }
            iconSource: ""
            FontIcon { // report
                text: "\ue160"; color: systemPalette.light
            }
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : PowerAction { }
            iconSource: ""
            FontIcon { // settings-power
                text: "\ue8c6"; color: systemPalette.light
            }
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : OpenAction { fileDialog: applicationFileDialog }
            iconSource: ""
            FontIcon { // folder-open
                text: "\ue2c8"; color: systemPalette.light
            }
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : ReopenAction { }
            iconSource: ""
            FontIcon { // refresh
                text: "\ue5d5"; color: systemPalette.light
            }
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : RunProgramAction { }
            iconSource: ""
            FontIcon { // play_arrow
                text: "\ue037"; color: systemPalette.light
            }
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : PauseResumeProgramAction { }
            iconSource: ""
            FontIcon { // pause
                text: "\ue034"; color: systemPalette.light
            }
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : StopProgramAction { }
            iconSource: ""
            FontIcon { // stop
                text: "\ue047"; color: systemPalette.light
            }
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : StepProgramAction { }
            iconSource: ""
            FontIcon { // skip_next
                text: "\ue044"; color: systemPalette.light
            }
        }

        Item {
            Layout.fillHeight: true
        }

        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            onClicked: applicationMenu.popup()
            iconSource: ""
            FontIcon { // more_horiz
                text: "\ue5d3"; color: systemPalette.light
            }
        }

        ApplicationMenu {
            id: applicationMenu
        }

        AboutDialog {
            id: aboutDialog
        }
    }
}
