import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import "../controllers" as Cont
import "../scripts/moment.js" as D
import "../components" as Comp
import "." as L

Rectangle {
    id:top
    width: Screen.width
    height: Screen.height
    color: "lightsteelblue"
    property var  selectedDate
    property bool my_calendar: false
    onVisibleChanged: {
        if (visible) tim2.start()

    }

    Timer {
        id: tim2
          interval: 1; running: false; repeat: false
            onTriggered: {
                if (!entry.busy)
                calEvents.getCalendar(calendar.selectedDate.year(),calendar.selectedDate.month()+1,calendar.selectedDate.date(),"week")
                else restart()

            }
    }

    Rectangle {
        id: topRect
        width: parent.width
        height: parent.height/8
        color: "linen"
        Comp.DateTumblerInput {
            id: bannerweek
            anchors.left: parent.left
            anchors.leftMargin: height
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width/3
            height: parent.height
            showType: "weeks"
            //date: D.moment(new Date)
            onReturnDateChanged: {
                //console.log("isitme",returnDate)
                calendar.selectedDate = returnDate
            }
            Component.onCompleted: {
                bannerweek.date = D.moment(calendar.selectedDate)
                console.log("seldate",calendar.selectedDate)
            }
        }

/*        Rectangle {
            id: decMonth
            width: parent.height
            anchors.left: parent.left
            anchors.leftMargin: height*2
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: decmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_previous_item.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: decmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.subtract(7,"days")
                    console.log("dateChanged", calendar.selectedDate)
                }

            }
        }
        Rectangle {
            id: ddecMonth
            width: parent.height
            anchors.left: parent.left
            anchors.leftMargin: height
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: ddecmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/double-chevron-left-120.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: ddecmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.subtract(1,"months")
                }

            }
        }
        Rectangle {
            id: incMonth
            width: parent.height
            anchors.right: parent.right
            anchors.rightMargin: height*2
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: incmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_next_item.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: incmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.add(7,"days")
                    console.log("dateChanged", calendar.selectedDate)
                }

            }
        }
        Rectangle {
            id: dincMonth
            width: parent.height
            anchors.right: parent.right
            anchors.rightMargin: height
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: dincmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/arrow__chevron-double-bold-2-01-128.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: dincmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.add(1,"months")
                }

            }
        }        Rectangle {
            id: decMonth
            width: parent.height
            anchors.left: parent.left
            anchors.leftMargin: height*2
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: decmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_previous_item.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: decmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.subtract(7,"days")
                    console.log("dateChanged", calendar.selectedDate)
                }

            }
        }
        Rectangle {
            id: ddecMonth
            width: parent.height
            anchors.left: parent.left
            anchors.leftMargin: height
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: ddecmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/double-chevron-left-120.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: ddecmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.subtract(1,"months")
                }

            }
        }
        Rectangle {
            id: incMonth
            width: parent.height
            anchors.right: parent.right
            anchors.rightMargin: height*2
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: incmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_next_item.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: incmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.add(7,"days")
                    console.log("dateChanged", calendar.selectedDate)
                }

            }
        }
        Rectangle {
            id: dincMonth
            width: parent.height
            anchors.right: parent.right
            anchors.rightMargin: height
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: dincmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/arrow__chevron-double-bold-2-01-128.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: dincmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.add(1,"months")
                }

            }
        }*/
        Rectangle {
            id: week
            width: parent.height
            anchors.right: parent.right
            anchors.rightMargin: height*3
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: weekmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Text {
                text: "D"
                font.pointSize: 30
            }

            MouseArea {
                id: weekmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    entry.push({item: dayComp, properties: {selectedDate: D.moment(calendar.currentDate)}})
                }

            }
        }

    }

    GridView {
        id:calendar
        anchors.top: topRect.bottom
        anchors.topMargin: parent.height/40
        model: calEvents.model3
        property bool busy: entry.busy
        delegate: calDelegate
        width: parent.width
        height: parent.height*7/8
        cellWidth: width/7
        cellHeight: height/(model.count/7) +1
        property var selectedDate
        property var currentDate
        property var currentEvents
        onSelectedDateChanged:  {
            console.log("dateChanged", selectedDate)
            //console.log(selectedDate,selectedDate.year(),selectedDate.month())
            calEvents.getCalendar(selectedDate.year(),selectedDate.month()+1,selectedDate.date(),"week")
            bannerweek.date = selectedDate//.format("MMM YYYY")
        }

        Timer {
            id: tim1
              interval: 1; running: false; repeat: false
                onTriggered: {
                    if (!entry.busy) {
                        calendar.selectedDate = top.selectedDate
                        calendar.currentDate = selectedDate
                        calEvents.getCalendar(selectedDate.year(),selectedDate.month()+1,selectedDate.date(),"week")
                    }
                    else restart()
            }
        }

        Component.onCompleted: {

            tim1.start()

        }

    }

    Component {
            id: calDelegate
            Rectangle {
                id: wrapper
                width: calendar.cellWidth
                height: calendar.cellHeight
                border.width: 1
                border.color: "grey"
                color: GridView.isCurrentItem ? "blue" : "cyan"
                MouseArea {
                    id:clicker
                    width: parent.width
                    height: parent.height
                    onClicked: {
                        //console.log(events.get(0).title)
                        calendar.currentIndex = index
                        calendar.currentDate = date
                        calendar.currentEvents = events
                    }
                    onDoubleClicked: {

                    }
                }


                Text {
                    id: calInfo


                    text: D.moment(date).format("ddd Do")
                    color: wrapper.GridView.isCurrentItem ? "red" : "black"
                    MouseArea {
                        width: parent.width
                        height: parent.height
                        onClicked:  {
                        //    entry.lists.blank = {"date":""}
                        //    entry.lists.blank.date = D.moment(date).format("YYYY-MM-DD")
                        //    entry.pushOther(8)
                            //dialog1.index = 0
                            //dialog1.setDate = date
                            //top.visible = false
                            //dialog1.open()
                            entry.push({item: editev, properties: {setDate: date, index: 0}})



                        }
                    }
                }

               ListView {
                    id: eventList
                    width: calendar.cellWidth
                    height: calendar.cellHeight
                    model: events
                    property color highlighted: wrapper.color
                    property var rowheight: events.count ? height/(events.count) : 30
                    anchors.top: calInfo.bottom
                    anchors.bottom: parent.bottom
                    delegate: eventDelegate
                }
               Component {
                   id: eventDelegate
                   Item {
                       id: del1
                       width: eventList.width
                       height: eventList.rowheight
                       Column {
                           width:parent.width
                           height: eventList.rowheight
                       Rectangle {
                           width:parent.width
                           height: parent.height/8
                           color: eventList.highlighted
                           border.width: 1
                           border.color: "grey"
                       }
                       Rectangle {
                           width:parent.width
                           height: parent.height*3/4
                           color: "lightyellow"
                           border.color: "blue"
                           border.width: 0.5

                           Text {
                           width: parent.width ;height: parent.height; horizontalAlignment: Text.AlignHCenter ;verticalAlignment: Text.AlignVCenter;
                           wrapMode: Text.WordWrap
                           text: title + " \n @ " + D.moment(eventstart).format("HH:mm" )
                       }


                       MouseArea {
                           width:parent.width
                           height: parent.height
                           onClicked: {
                               entry.push({item: editev, properties: {index: id}})

                           }
                           onPressAndHold: {
                               entry.push({item: sheet, properties: {index: id}})
                           }

                       }

                       }
                       Rectangle {
                           width:parent.width
                           height: parent.height/8
                           color: eventList.highlighted
                           border.width: 1
                           border.color: "grey"
                       }
                       }

                       }
                   }


 /*               TableView {
                    id: eventSelect
                    width: calendar.cellWidth

                    anchors.top: calInfo.bottom
                    anchors.bottom: parent.bottom
                    model: events
                    headerVisible: false
                    visible: true
                    TableViewColumn {
                        role: "title"
                        title: "Title"
                        width: calendar.cellWidth/2
                    }
                    TableViewColumn {
                        role: "eventdate"
                        title: "Date"
                        width: calendar.cellWidth/2
                    }
                    onClicked: {
                        //console.log("dcev",eventSelect.currentRow, events.get(eventSelect.currentRow).id )
                        //dialog1.index = events.get(eventSelect.currentRow).id
                        //top.visible = false
                        //dialog1.open()
                        entry.push({item: editev, properties: {index: events.get(eventSelect.currentRow).id}})

                    }

            }*/
        }
    }
    ListModel {
        id: caldata

    }
    Cont.EventController {
        id: calEvents
    }
    Component {
        id: editev
        L.EditEvent {


    }
    }
    Component {
        id: dayComp
        L.CalendarDay {


    }
    }
    Component {
        id:sheet
    L.EditVolunteerSheet {

    }
    }




}

