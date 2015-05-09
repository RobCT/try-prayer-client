import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.2
import "../scripts/moment.js" as D
Rectangle {
    id: eventRect
    //height: 900
    //width: 1200
    property var time
    property var returnTime
    //width: parent.width
    //height: parent.height - Qt.inputMethod.keyboardRectangle.height
    property string toEdit
    property int recordId
    color: "linen"
    onReturnTimeChanged: {
        console.log(returnTime)
    }

    onVisibleChanged: {
        if (visible) {
            //edit.time = toEdit
        }
    }
    Component.onCompleted: {
        if (visible) {
            lvhu.currentIndex = 2
            lvht.currentIndex = 2
            lvmu.currentIndex = 2
            lvmt.currentIndex = 2
            tim1.start()
            console.log(width, height)
            //edit.time = toEdit
        }
    }

   Timer {
       id: tim1
       interval: 1000; running: false; repeat: false
       onTriggered: {
           lvht.currentIndex = (D.moment(eventRect.time).hours()/10 | 0)
           lvhu.currentIndex = (D.moment(eventRect.time).hours()%10 | 0)
           lvmt.currentIndex = (D.moment(eventRect.time).minutes()/10 | 0)
           lvmu.currentIndex = (D.moment(eventRect.time).minutes()%10 | 0)

       }

   }
    Rectangle{
        anchors.fill: parent
        anchors.margins: parent.height/20

        color: "black"
        radius: 10

        Rectangle {
            id: inRect
            anchors.fill: parent
            anchors.margins: parent.height/7
            color: "linen"
            radius: 9

            RowLayout {
                id: lvRect
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height - parent.height * 0.1
                ListView {
                    id: lvht
                    width: parent.width/5
                    height:parent.height
                    property int ci: currentIndex
                    model: hourTensModel
                    delegate: lvdelegate
                    snapMode: ListView.SnapOneItem
                    highlight: highlight
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: y //+(height - inRect.height/3) /2
                    preferredHighlightEnd: y + height// -(height - inRect.height/3) /2
                    Component.onCompleted: {
                        currentIndex = 2
                    }
                    onCurrentIndexChanged: {
                        if (currentIndex == 2 && lvhu.currentIndex > 3) lvhu.currentIndex = 3
                        var dt = D.moment(new Date(2001,01,01))
                        dt.hours((lvht.currentIndex)*10 + lvhu.currentIndex)
                        dt.minutes((lvmt.currentIndex)*10 + lvmu.currentIndex)
                        eventRect.returnTime = dt.toISOString()
                    }


                }
                ListView {
                    id: lvhu
                    width: parent.width/5
                    x: lvht.x + width
                    property int ci: currentIndex
                    height:parent.height
                    model: unitsModel
                    delegate: lvdelegate
                    highlight: highlight

                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: y //+(height - inRect.height/3) /2
                    preferredHighlightEnd: y + height// -(height - inRect.height/3) /2
                    onCurrentIndexChanged: {
                        if (lvht.currentIndex == 2 && lvhu.currentIndex > 3) lvhu.currentIndex = 3
                        var dt = D.moment(new Date(2001,01,01))
                        dt.hours((lvht.currentIndex)*10 + lvhu.currentIndex )
                        dt.minutes((lvmt.currentIndex)*10 + lvmu.currentIndex)
                        eventRect.returnTime = dt.toISOString()
                    }
                    Component.onCompleted: {
                        currentIndex = 2
                    }
                }
                Rectangle {
                    id: colRect
                    x: lvhu.x + width
                    width: parent.width/5
                    height:parent.height
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: parent.height*0.6
                        text: " : "

                    }
                }
                ListView {
                    id: lvmt
                    width: parent.width/5
                    property int ci: currentIndex
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    x: colRect.x + width
                    height:parent.height
                    highlight: highlight
                    preferredHighlightBegin: y //+(height - inRect.height/3) /2
                    preferredHighlightEnd: y + height // -(height - inRect.height/3) /2

                    model: minsTensModel
                    delegate: lvdelegate
                    onCurrentIndexChanged: {

                        var dt = D.moment(new Date(2001,01,01))
                        dt.hours((lvht.currentIndex)*10 + lvhu.currentIndex )
                        dt.minutes((lvmt.currentIndex)*10 + lvmu.currentIndex)
                        eventRect.returnTime = dt.toISOString()
                    }

                    Component.onCompleted: {
                        currentIndex = 2
                    }
                }

                ListView {
                    id: lvmu
                    width: parent.width/5
                    height:parent.height
                    x: lvmt.x + width
                    model: unitsModel
                    property int ci: currentIndex
                    highlight: highlight
                    delegate: lvdelegate
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: y //+(height - inRect.height/3) /2
                    preferredHighlightEnd: y + height //-(height - inRect.height/3) /2
                    Component.onCompleted: {
                        currentIndex = 2
                    }
                    onCurrentIndexChanged: {

                        var dt = D.moment(new Date(2001,01,01))
                        dt.hours((lvht.currentIndex)*10 + lvhu.currentIndex )
                        dt.minutes((lvmt.currentIndex)*10 + lvmu.currentIndex)
                        eventRect.returnTime = dt.toISOString()
                    }

                }
            }

        }

    }
    Component {
        id: highlight
        Rectangle {
            color: "lightsteelblue"
            width: inRect.width/5
            height: inRect.height/3

        }
    }

    Component {
        id: lvdelegate
        Item {
            id: deltop
            width: inRect.width/5
            height: lvRect.height
            property int currentIndex: ListView.view.ci



            Rectangle {
                radius: 30
                width:parent.width
                height: parent.height
                //color: index == volunteers.currentIndex ? "aquamarine" : "transparent"
                //anchors.margins: 5
                border.width: 4
                border.color: "grey"
                visible: deltop.currentIndex == index ? true : false
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: parent.height*0.6
                    text: digit
                }

        }
        }
    }

    ListModel {
        id: hourTensModel


        ListElement {
            digit: 0
        }
        ListElement {
            digit: 1
        }
        ListElement {
            digit: 2
        }


    }
    ListModel {
        id: minsTensModel


        ListElement {
            digit: 0
        }
        ListElement {
            digit: 1
        }
        ListElement {
            digit: 2
        }
        ListElement {
            digit: 3
        }
        ListElement {
            digit: 4
        }
        ListElement {
            digit: 5
        }


    }
    ListModel {
        id: unitsModel


        ListElement {
            digit: 0
        }
        ListElement {
            digit: 1
        }
        ListElement {
            digit: 2
        }
        ListElement {
            digit: 3
        }
        ListElement {
            digit: 4
        }
        ListElement {
            digit: 5
        }
        ListElement {
            digit: 6
        }
        ListElement {
            digit: 7
        }
        ListElement {
            digit: 8
        }
        ListElement {
            digit: 9
        }


    }

}

