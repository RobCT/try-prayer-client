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
    property var date
    property var returnDate
    property string showType: "months"
    //width: parent.width
    //height: parent.height - Qt.inputMethod.keyboardRectangle.height
    property string toEdit
    property int recordId
    color: "linen"
    onDateChanged: {
        inRect.update = false
        lvmonth.currentIndex = (D.moment(eventRect.date).months() | 0)
        lvyears.currentIndex = (D.moment(eventRect.date).years() - 2000 | 0)
        lvdays.currentIndex = (D.moment(eventRect.date).date() - 1 )
        lvweeks.currentIndex = (D.moment(eventRect.date).week() - 1)
        //console.log("datechnged",date, width, height, showType)
        inRect.update = true

    }


    onVisibleChanged: {
        if (visible) {
            //edit.time = toEdit
        }
    }
    Component.onCompleted: {
        returnDate = date
        if (visible) {
            if (showType == "weeks") {
                lvweeks.visible = true
                lvdays.visible = false
                //lvweeks.x = 0
                //lvmonth.x = lvweeks.x + inRect.cellwidth
                //lvyears.x = lvmonth.x + inRect.cellwidth

            }
            else if (showType == "days") {
                lvweeks.visible = false
                lvdays.visible = true
                //lvdays.x = 0
               //lvmonth lvmonth.x = lvdays.x + inRect.cellwidth
                //lvyears.x = lvmonth.x + inRect.cellwidth
            }
            else if (showType == "months") {
                lvweeks.visible = false
                lvdays.visible = false
                //lvmonth.x = 0
                //lvyears.x = lvmonth.x + inRect.cellwidth
               //console.log("xs",lvmonth.x,lvyears.x,inRect.cellwidth, inRect.x)

            }

            tim1.start()
            //console.log(width, height)
            //edit.time = toEdit
        }
    }

   Timer {
       id: tim1
       interval: 500; running: false; repeat: false
       onTriggered: {
           inRect.update = false
           //date = D.moment(new Date)
           lvmonth.currentIndex = (D.moment(eventRect.date).month() | 0)
           lvyears.currentIndex = (D.moment(eventRect.date).year() - 2000 | 0)
           lvdays.currentIndex = (D.moment(eventRect.date).date() -1 )
           lvweeks.currentIndex = (D.moment(eventRect.date).week() - 1)
           inRect.update = true
            //console.log("tim1",(D.moment(eventRect.date).months() | 0),(D.moment(eventRect.date).years() - 2000 | 0))

       }

   }
    Rectangle{
        anchors.fill: parent
        anchors.margins: parent.height/20


        color: "coral"
        radius: 10

        Rectangle {
            id: inRect
            anchors.fill: parent
            anchors.margins: parent.height/7
            color: "linen"
            radius: 9
            property bool update: true
            property real cellwidth: eventRect.showType == "weeks" || eventRect.showType == "days" ? inRect.width/3 : inRect.width/2

            Row {
                id: lvRect
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height - parent.height * 0.1
                property bool bumpday: false


                function setDate() {
                    if (inRect.update) {
                    var dt = D.moment()
                    if (eventRect.showType == "months") {
                    dt = D.moment(new Date(lvyears.model.get(lvyears.currentIndex).disp,lvmonth.model.get(lvmonth.currentIndex).dispNo - 1,01))
                     dt.hours(12)
                     eventRect.returnDate = dt
                    }
                    else if (eventRect.showType == "weeks") {
                        dt = D.moment(new Date(lvyears.model.get(lvyears.currentIndex).disp,lvmonth.model.get(lvmonth.currentIndex).dispNo - 1,01))
                        dt.week(lvweeks.model.get(lvweeks.currentIndex).dispNo)
                        dt.hour(12)
                         eventRect.returnDate = dt
                        //console.log("wkret", dt, lvweeks.model.get(lvweeks.currentIndex).dispNo, lvweeks.currentIndex )
                        }
                    else if (eventRect.showType == "days") {
                        var fd = D.moment(new Date(lvyears.model.get(lvyears.currentIndex).disp,lvmonth.model.get(lvmonth.currentIndex).dispNo - 1, 01))
                        var ld = D.moment(fd.add("months",1).date(0))

                        //console.log("datetest",ld.date(),lvdays.currentIndex,ld )
                        if (lvdays.currentIndex + 1 > ld.date()  && !lvRect.bumpday) {

                            lvRect.bumpday = true
                            dt = D.moment(new Date(lvyears.model.get(lvyears.currentIndex).disp,lvmonth.model.get(lvmonth.currentIndex).dispNo - 1, 01))
                            //
                            dt.hours(12)

                            lvyears.currentIndex = (dt.years() - 2000 | 0)

                            lvdays.currentIndex = (0 )
                            lvmonth.currentIndex = (dt.months() | 0)
                            eventRect.returnDate = dt

                        }
                        else {
                            if (lvdays.currentIndex + 1 <= ld.date()) {
                        lvRect.bumpday = false
                        dt = D.moment(new Date(lvyears.model.get(lvyears.currentIndex).disp,lvmonth.model.get(lvmonth.currentIndex).dispNo - 1, lvdays.model.get(lvdays.currentIndex).disp ))
                         dt.hours(12)
                         eventRect.returnDate = dt
                            }
                        }
                        }
                   // console.log("dtdt", dt, inRect.cellwidth)
                    }
                }

                ListView {
                    id: lvdays
                    width: inRect.cellwidth
                    height:parent.height
                    property int ci: currentIndex
                    //y:inRect.y
                    model: days
                    visible: false
                    delegate: lvdelegate
                    anchors.left: parent.left
                    snapMode: currentIndex>28 ? ListView.SnapOneItem : ListView.NoSnap
                    highlight: highlight
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: y //+(height - inRect.height/3) /2
                    preferredHighlightEnd: y + height// -(height - inRect.height/3) /2
                    Component.onCompleted: {
                        //currentIndex = 10
                    }
                    onCurrentIndexChanged: {
                       lvRect.setDate()
                    }


                }
                ListView {
                    id: lvweeks
                    width: inRect.cellwidth
                    height:parent.height
                    anchors.left: parent.left
                    property int ci: currentIndex
                    //y:inRect.y
                    model: weeks
                    delegate: lvdelegate
                    visible: false
                    highlight: highlight
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: y //+(height - inRect.height/3) /2
                    preferredHighlightEnd: y + height// -(height - inRect.height/3) /2
                    Component.onCompleted: {
                        //currentIndex = 10
                    }
                    onCurrentIndexChanged: {
                       lvRect.setDate()
                    }


                }

                ListView {
                    id: lvmonth
                    width: inRect.cellwidth
                    height:parent.height
                    //y:inRect.y
                    anchors.left: eventRect.showType == "months" ? parent.left : eventRect.showType == "weeks" ? lvweeks.right: lvdays.right
                    //x: eventRect.showType == "months" ? 0 : eventRect.showType == "weeks" ? lvweeks.x + inRect.cellwidth : lvdays.x + inRect.cellwidth
                    property int ci: currentIndex
                    model: months
                    delegate: lvdelegate

                    highlight: highlight
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: y //+(height - inRect.height/3) /2
                    preferredHighlightEnd: y + height// -(height - inRect.height/3) /2
                    Component.onCompleted: {
                       // currentIndex = 10
                    }
                    onCurrentIndexChanged: {
                       lvRect.setDate()
                    }


                }
                ListView {
                    id: lvyears
                    width: inRect.cellwidth
                    //y:inRect.y
                    anchors.left: lvmonth.right
                    //x: lvmonth.x + inRect.cellwidth
                    property int ci: currentIndex
                    height:parent.height
                    model: years
                    delegate: lvdelegate
                    highlight: highlight

                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: y //+(height - inRect.height/3) /2
                    preferredHighlightEnd: y + height// -(height - inRect.height/3) /2
                    onCurrentIndexChanged: {
                        lvRect.setDate()
                    }
                    Component.onCompleted: {
                        //currentIndex = 2
                    }
                }

            }

        }

    }
    Component {
        id: highlight
        Rectangle {
            color: "lightsteelblue"
            width: inRect.cellwidth
            height: inRect.height

        }
    }

    Component {
        id: lvdelegate
        Item {
            id: deltop
            width: inRect.cellwidth
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
                    font.pixelSize: parent.height*0.4
                    text: disp
                }

        }
        }
    }


    ListModel {
        id: months


        ListElement {
            disp: "Jan"
            dispNo: 1
        }
        ListElement {
            disp: "Feb"
            dispNo: 2
        }
        ListElement {
            disp: "Mar"
            dispNo: 3
        }
        ListElement {
            disp: "Apr"
            dispNo: 4
        }
        ListElement {
            disp: "May"
            dispNo: 5
        }
        ListElement {
            disp: "Jun"
            dispNo: 6
        }
        ListElement {
            disp: "Jul"
            dispNo: 7
        }
        ListElement {
            disp: "Aug"
            dispNo: 8
        }
        ListElement {
            disp: "Sep"
            dispNo: 9
        }
        ListElement {
            disp: "Oct"
            dispNo: 10
        }
        ListElement {
            disp: "Nov"
            dispNo: 11
        }
        ListElement {
            disp: "Dec"
            dispNo: 12
        }

    }
    ListModel {
        id: years


        ListElement {
            disp: 2000
        }
        ListElement {
            disp: 2001
        }
        ListElement {
            disp: 2002
        }
        ListElement {
            disp: 2003
        }
        ListElement {
            disp: 2004
        }
        ListElement {
            disp: 2005
        }
        ListElement {
            disp: 2006
        }
        ListElement {
            disp: 2007
        }
        ListElement {
            disp: 2008
        }
        ListElement {
            disp: 2009
        }
        ListElement {
            disp: 2010
        }
        ListElement {
            disp: 2011
        }
        ListElement {
            disp: 2012
        }
        ListElement {
            disp: 2013
        }
        ListElement {
            disp: 2014
        }
        ListElement {
            disp: 2015
        }
        ListElement {
            disp: 2016
        }
        ListElement {
            disp: 2017
        }
        ListElement {
            disp: 2018
        }
        ListElement {
            disp: 2019
        }
        ListElement {
            disp: 2020
        }
        ListElement {
            disp: 2021
        }
        ListElement {
            disp: 2022
        }
        ListElement {
            disp: 2023
        }
        ListElement {
            disp: 2024
        }
        ListElement {
            disp: 2025
        }
        ListElement {
            disp: 2026
        }
        ListElement {
            disp: 2027
        }
        ListElement {
            disp: 2028
        }
        ListElement {
            disp: 2029
        }

    }
    ListModel {
        id: days


        ListElement {
            disp: 1
        }
        ListElement {
            disp: 2
        }
        ListElement {
            disp: 3
        }
        ListElement {
            disp: 4
        }
        ListElement {
            disp: 5
        }
        ListElement {
            disp: 6
        }
        ListElement {
            disp: 7
        }
        ListElement {
            disp: 8
        }
        ListElement {
            disp: 9
        }
        ListElement {
            disp: 10
        }
        ListElement {
            disp: 11
        }
        ListElement {
            disp: 12
        }
        ListElement {
            disp: 13
        }
        ListElement {
            disp: 14
        }
        ListElement {
            disp: 15
        }
        ListElement {
            disp: 16
        }
        ListElement {
            disp: 17
        }
        ListElement {
            disp: 18
        }
        ListElement {
            disp: 19
        }
        ListElement {
            disp: 20
        }
        ListElement {
            disp: 21
        }
        ListElement {
            disp: 22
        }
        ListElement {
            disp: 23
        }
        ListElement {
            disp: 24
        }
        ListElement {
            disp: 25
        }
        ListElement {
            disp: 26
        }
        ListElement {
            disp: 27
        }
        ListElement {
            disp: 28
        }
        ListElement {
            disp: 29
        }
        ListElement {
            disp: 30
        }
        ListElement {
            disp: 31
        }
        ListElement {
            disp: 1
        }
    }
    ListModel {
        id: weeks


        ListElement {
            disp: "Wk1"
            dispNo: 1
        }
        ListElement {
            disp: "Wk2"
            dispNo: 2
        }
        ListElement {
            disp: "Wk3"
            dispNo: 3
        }
        ListElement {
            disp: "Wk4"
            dispNo: 4
        }
        ListElement {
            disp: "Wk5"
            dispNo: 5
        }
        ListElement {
            disp: "Wk6"
            dispNo: 6
        }
        ListElement {
            disp: "Wk7"
            dispNo: 7
        }
        ListElement {
            disp: "Wk8"
            dispNo: 8
        }
        ListElement {
            disp: "Wk9"
            dispNo: 9
        }
        ListElement {
            disp: "Wk10"
            dispNo: 10
        }
        ListElement {
            disp: "Wk11"
            dispNo: 11
        }
        ListElement {
            disp: "Wk12"
            dispNo: 12
        }
        ListElement {
            disp: "Wk13"
            dispNo: 13
        }
        ListElement {
            disp: "Wk14"
            dispNo: 14
        }
        ListElement {
            disp: "Wk15"
            dispNo: 15
        }
        ListElement {
            disp: "Wk16"
            dispNo: 16
        }
        ListElement {
            disp: "Wk17"
            dispNo: 17
        }
        ListElement {
            disp: "Wk18"
            dispNo: 18
        }
        ListElement {
            disp: "Wk19"
            dispNo: 19
        }
        ListElement {
            disp: "Wk20"
            dispNo: 20
        }
        ListElement {
            disp: "Wk21"
            dispNo: 21
        }
        ListElement {
            disp: "Wk22"
            dispNo: 22
        }
        ListElement {
            disp: "Wk23"
            dispNo: 23
        }
        ListElement {
            disp: "Wk24"
            dispNo: 24
        }
        ListElement {
            disp: "Wk25"
            dispNo: 25
        }
        ListElement {
            disp: "Wk26"
            dispNo: 26
        }
        ListElement {
            disp: "Wk27"
            dispNo: 27
        }
        ListElement {
            disp: "Wk28"
            dispNo: 28
        }
        ListElement {
            disp: "Wk29"
            dispNo: 29
        }
        ListElement {
            disp: "Wk30"
            dispNo: 30
        }
        ListElement {
            disp: "Wk31"
            dispNo: 31
        }
        ListElement {
            disp: "Wk32"
            dispNo: 32
        }
        ListElement {
            disp: "Wk33"
            dispNo: 33
        }
        ListElement {
            disp: "Wk34"
            dispNo: 34
        }
        ListElement {
            disp: "Wk35"
            dispNo: 35
        }
        ListElement {
            disp: "Wk36"
            dispNo: 36
        }
        ListElement {
            disp: "Wk37"
            dispNo: 37
        }
        ListElement {
            disp: "Wk38"
            dispNo: 38
        }
        ListElement {
            disp: "Wk39"
            dispNo: 39
        }
        ListElement {
            disp: "Wk40"
            dispNo: 40
        }
        ListElement {
            disp: "Wk41"
            dispNo: 41
        }
        ListElement {
            disp: "Wk42"
            dispNo: 42
        }
        ListElement {
            disp: "Wk43"
            dispNo: 43
        }
        ListElement {
            disp: "Wk44"
            dispNo: 44
        }
        ListElement {
            disp: "Wk45"
            dispNo: 45
        }
        ListElement {
            disp: "Wk46"
            dispNo: 46
        }
        ListElement {
            disp: "Wk47"
            dispNo: 47
        }
        ListElement {
            disp: "Wk48"
            dispNo: 48
        }
        ListElement {
            disp: "Wk49"
            dispNo: 49
        }
        ListElement {
            disp: "Wk50"
            dispNo: 50
        }
        ListElement {
            disp: "Wk51"
            dispNo: 51
        }
        ListElement {
            disp: "Wk52"
            dispNo: 52
        }


    }
}

