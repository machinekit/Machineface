import QtQuick 2.0
import QtQuick.Controls 1.2

CheckBox {
    property string groupName: "group"
    property string valueName: "value"
    text: "Group Value"
    checked: applicationCore.settings.initialized && applicationCore.settings.values[groupName][valueName]
    onClicked: {
        applicationCore.settings.setValue(groupName + "." + valueName, !applicationCore.settings.values[groupName][valueName])
    }
}
