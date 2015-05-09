import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import "../scripts/moment.js" as D
Item {


    id: te

    property alias time: tet1.time

    property alias font: tet1.font
    property alias ratio: tet1.ratio
    property alias color: tet1.textColor
    property alias bcolor: tet1.col
    property alias timeActiveFocus: tet1.activeFocus
    property bool accepted


    Row {
        anchors.fill: parent
        Component.onCompleted:  {
        }

        TextField {
            id: tet1
            height: parent.height
            width: parent.width*ratio
            style: textStyle
            inputMask: "99:99"

            property color col: "lightgreen"
            property real ratio: 1
            property var time
            onEditingFinished: {
                var txt = text
                var col = txt.search(":")
                var hr = txt.slice(0,col)
                var mn = txt.slice(col+1,txt.length)

                var dt = D.moment(new Date(2001,01,01))
                dt.hours(Number(hr))
                dt.minutes(Number(mn))
                time = dt.toISOString()


            }

            onTimeChanged:  {
                //console.log("timechange",  D.moment(time).format("HH:mm"))
                tet1.text = D.moment(time).format("HH:mm")
            }
            onAccepted: {
                var txt = text
                var col = txt.search(":")
                var hr = txt.slice(0,col)
                var mn = txt.slice(col+1,txt.length)

                var dt = D.moment(new Date(2001,01,01))
                dt.hours(Number(hr))
                dt.minutes(Number(mn))
                time = dt.toISOString()
                if (te.accepted) te.accepted = false
                else te.accepted = true
            }




        }
        Rectangle {
            id: r1
            height: parent.height
            width: (parent.width - parent.width*tet1.ratio)/2
            //anchors.left: tet1.right
            color: "lightgrey"
            border.color: "gray"
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/up-down.png"
                width: parent.width
                height: parent.height
            }
            MouseArea {
                height:parent.height/2
                width: parent.width
                anchors.top: parent.top
                onClicked: parent.doInc()

            }
            MouseArea {
                height:parent.height/2
                width: parent.width
                anchors.bottom: parent.bottom
                onClicked:  parent.doDec()


            }
            function doInc() {

                //2000-01-01T11:00:00.000Z
                var t = D.moment(tet1.time)

                t.add(1,"hours")

                tet1.time = t.toISOString()



            }
            function doDec() {

                var t = D.moment(tet1.time)
                t.subtract(1,"hours")
                tet1.time = t.toISOString()
            }


        }
        Rectangle {
            height: parent.height
            width: (parent.width - parent.width*tet1.ratio)/2
            //anchors.left: r1.right
            color: "lightgrey"
            border.color: "gray"
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/up-down.png"
                width: parent.width
                height: parent.height
            }

            MouseArea {
                height:parent.height/2
                width: parent.width
                anchors.top: parent.top
                onClicked: parent.doInc()

            }
            MouseArea {
                height:parent.height/2
                width: parent.width
                anchors.bottom: parent.bottom
                onClicked:  parent.doDec()

            }
            function doInc() {

                var t = D.moment(tet1.time)
                t.add(1,"minutes")
                tet1.time = t.toISOString()
            }
            function doDec() {

                var t = D.moment(tet1.time)
                t.subtract(1,"minutes")
                tet1.time = t.toISOString()
            }


        }
    }

    Component {
        id: textStyle
        TextFieldStyle {
            id: ts
            textColor: "darkblue"
            background:  Rectangle {
                    id:brect
                    width: parent.width*tet1.ratio
                    height: parent.height


                    radius: 3
                    color: tet1.col//"transparent"
                    border.color: "lightgray"


                }


        }
    }


}
