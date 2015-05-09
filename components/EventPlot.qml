import QtQuick 2.3

Rectangle {
    id: eventRect
    property alias text: evTitle.text
    property var eventId
    property var clickAction
    property var pressAction
    color: "yellow"
    MouseArea {
        anchors.fill: parent
        onClicked: {
            clickAction(eventId)

        }
        onPressAndHold: {
            pressAction(eventId)
        }
    }


    Text {
        id: evTitle
    }
}

