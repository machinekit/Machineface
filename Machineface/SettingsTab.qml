import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Application.Controls 1.0

Tab {
    title: qsTr("Settings")

    Item {
    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        contentItem:

        ColumnLayout {
            id: column1
            width: scrollView.width
            spacing: Screen.pixelDensity

            VelocityExtrusionControl {
                Layout.fillWidth: false
                id: velocityExtrusionControl
            }

            GantryConfigControl {
                Layout.fillWidth: false
                id: gantryConfigControl
            }

            Label {
                text: qsTr("Digital Read Out")
                font.bold: true
            }

            ToggleSettingCheck {
                groupName: "dro"
                valueName: "showOffsets"
                text: qsTr("Show offsets")
            }

            ToggleSettingCheck {
                id: showVelocityAction
                groupName: "dro"
                valueName: "showVelocity"
                text: qsTr("Show velocity")
            }

            ToggleSettingCheck {
                id: showDistanceToGoAction
                groupName: "dro"
                valueName: "showDistanceToGo"
                text: qsTr("Show distance to go")
            }

            Label {
                text: qsTr("Other")
                font.bold: true
            }

            // temporarily disable preview until it is working in a better way
            ToggleSettingCheck {
                id: enablePreviewAction
                groupName: "preview"
                valueName: "enable"
                text: qsTr("Enable preview")
                visible: checked  // in case preview was accidentally enabled show this check box
            }

            CheckBox {
                id: teleopCheck
                checked: teleopAction.checked
                text: teleopAction.text
                onClicked: teleopAction.trigger()

                TeleopAction {
                    id: teleopAction
                }
            }

           /* ToggleSettingCheck {
                id: showMachineLimitsAction
                groupName: "preview"
                valueName: "showMachineLimits"
                text: qsTr("Show machine limits")
            }

            ToggleSettingCheck {
                id: showProgramAction
                groupName: "preview"
                valueName: "showProgram"
                text: qsTr("Show program")
            }

            ToggleSettingCheck {
                id: showProgramExtentsAction
                groupName: "preview"
                valueName: "showProgramExtents"
                text: qsTr("Show program extents")
            }

            ToggleSettingCheck {
                id: showProgramRapidsAction
                groupName: "preview"
                valueName: "showProgramRapids"
                text: qsTr("Show program rapids")
            }

            ToggleSettingCheck {
                id: alphaBlendProgramAction
                groupName: "preview"
                valueName: "alphaBlendProgram"
                text: qsTr("Alpha-blend program")
            }

            ToggleSettingCheck {
                id: showLivePlotAction
                groupName: "preview"
                valueName: "showLivePlot"
                text: qsTr("Show live plot")
            }

            ToggleSettingCheck {
                id: showToolAction
                groupName: "preview"
                valueName: "showTool"
                text: qsTr("Show tool")
            }

            ToggleSettingCheck {
                id: showCoordinateAction
                groupName: "preview"
                valueName: "showCoordinate"
                text: qsTr("Show coordinate")
            }*/
        }
        }
    }
}
