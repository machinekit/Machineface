import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

ScrollView {
    default property alias data: container.data
    id: root
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    ColumnLayout {
        id: container
        width: root.width - Screen.pixelDensity * 4
        spacing: Screen.pixelDensity
    }
}
