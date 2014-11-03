import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Controls 1.0
import Machinekit.PathView 1.0

Tab {
    title: qsTr("Preview")

    Rectangle {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity
        color: "transparent"
        border.width: 1
        border.color: systemPalette.shadow

        SystemPalette { id: systemPalette }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            PathView3D {
                id: pathView
                Layout.fillHeight: true
                Layout.fillWidth: true
                onViewModeChanged: {
                    cameraZoom = 0.95
                    cameraOffset = Qt.vector3d(0,0,0)
                    cameraPitch = 60
                    cameraHeading = -135
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.preferredWidth: height * 0.1
                visible: pathView.visible

                ColumnLayout {
                    id: viewModeLayout
                    anchors.fill: parent
                    anchors.leftMargin: Screen.pixelDensity / 2
                    anchors.margins: Screen.pixelDensity
                    spacing: Screen.pixelDensity

                    TouchButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ZoomOutAction { view: pathView }
                    }
                    TouchButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ZoomInAction { view: pathView }
                    }
                    TouchButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ZoomOriginalAction { view: pathView }
                    }
                    TouchButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ViewModeAction { view: pathView; viewMode: "Top"}
                    }
                    TouchButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ViewModeAction { view: pathView; viewMode: "RotatedTop"}
                    }
                    TouchButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ViewModeAction { view: pathView; viewMode: "Front"}
                    }
                    TouchButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ViewModeAction { view: pathView; viewMode: "Side"}
                    }
                    TouchButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ViewModeAction { view: pathView; viewMode: "Perspective"}
                    }
                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
