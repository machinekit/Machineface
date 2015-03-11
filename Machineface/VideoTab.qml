import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import Machinekit.Service 1.0
import Machinekit.VideoView 1.0

Tab {
    id: tab
    title: qsTr("Video")
    active: true

    Item {
        Service {
            id: videoService
            type: "video"
        }

        MjpegStreamerClient {
            property bool videoEnabled: false

            id: mjpegStreamerClient

            anchors.fill: parent
            visible: videoService.ready
            videoUri: videoService.uri
            ready: videoService.ready && videoEnabled

            Label {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: Screen.logicalPixelDensity
                text: parent.fps
            }

            Label {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: Screen.logicalPixelDensity
                text: parent.time.toTimeString()
            }

            Image {
                anchors.centerIn: parent
                width: Screen.logicalPixelDensity * 30
                height: width
                visible: !parent.videoEnabled
                source: "icons/ic_play_arrow_white_48dp.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.videoEnabled = !parent.videoEnabled
                }
            }
        }

        Label {
            id: infoLabel

            anchors.fill: parent
            visible: !videoService.ready
            text: qsTr("Webcam not available")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}

