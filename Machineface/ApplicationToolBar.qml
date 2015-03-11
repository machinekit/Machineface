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
    FontLoader { id: iconFont; source: "icons/material-icon-font.ttf" }

    ColumnLayout {
        id: toolBar
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity / 2

        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : EstopAction { id: estopAction }
            //iconSource: "icons/ic_report_white_48dp.png"
            iconSource: ""
            Text {  // using icon fonts is an alternative
                text: "\ue134"
                color: "white"
                font.family: iconFont.name
                anchors.fill: parent
                font.pixelSize: parent.width * 0.95
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : PowerAction { }
            iconSource: "icons/ic_settings_power_white_48dp.png"
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : OpenAction { fileDialog: applicationFileDialog}
            iconSource: "icons/ic_folder_open_white_48dp.png"
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : ReopenAction { }
            iconSource: "icons/ic_refresh_white_48dp.png"
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : RunProgramAction { }
            iconSource: "icons/ic_play_arrow_white_48dp.png"
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : PauseResumeProgramAction { }
            iconSource: "icons/ic_pause_white_48dp.png"
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : StopProgramAction { }
            iconSource: "icons/ic_stop_white_48dp.png"
        }
        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            action : StepProgramAction { }
            iconSource: "icons/ic_skip_next_white_48dp.png"
        }

        Item {
            Layout.fillHeight: true
        }

        TouchButton {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            onClicked: applicationMenu.popup()
            iconSource: "icons/ic_more_horiz_white_48dp.png"
        }

        ApplicationMenu {
            id: applicationMenu
        }

        AboutDialog {
            id: aboutDialog
        }
    }
}
