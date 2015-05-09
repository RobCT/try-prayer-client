import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import org.qtproject.tryprayer 1.0
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
    property var prayertext
    property int wayup: Screen.orientation
    property var pmodel: calPrayers.model3.get(0).prayers
    property var pcount: calPrayers.model3.get(0).prayers.count
    onPcountChanged: {
        console.log("pmod", pcount)
    }

    onWayupChanged: {
        //console.log("change way up",width, height)
    }

    function stringUp() {
        var jsn

             jsn = {"prayer":{"title": "", "prayerdate": calendar.selectedDate, "prayer": textArea.text,  "user_id": entry.signin.id}}

        return JSON.stringify((jsn))

    }
    onVisibleChanged: {
        if (visible) tim2.start()

    }

    Timer {
        id: tim2
          interval: 1; running: false; repeat: false
            onTriggered: {
                if (!entry.busy)
                calPrayers.getCalendar(calendar.selectedDate.year(),calendar.selectedDate.month()+1,calendar.selectedDate.date(),"day")
                else restart()

            }
    }
    Timer {
        id: tim3
          interval: 600000; running: true; repeat: true
            onTriggered: {

                calPrayers.getCalendar(calendar.selectedDate.year(),calendar.selectedDate.month()+1,calendar.selectedDate.date(),"day")


            }
    }

    Rectangle {
        id: topRect
        width: parent.width
        height: parent.height/8
        color: "linen"
        property int iseeyou
        Rectangle {
            id: hidden
            width: parent.width/12
            height: parent.height
            color: "transparent"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    topRect.iseeyou += 1
                    if (topRect.iseeyou == 1) hid.start()
                    if (topRect.iseeyou == 5  ) {
                        md1.open()

                    }

                }
            }
        }
        MessageDialog {
            id: md1
            text: "Your password is: " + entry.signin.currentPassword
        }
        Timer {
            id: hid
                interval: 10000; running: false; repeat: false
            onTriggered: {
                topRect.iseeyou = 0
            }
        }

        Comp.DateTumblerInput {
            id: banner
            anchors.left: parent.left

            anchors.verticalCenter: parent.verticalCenter

            width: parent.width/3
            height: parent.height
            anchors.leftMargin: width/4
            showType: "days"
            //date: D.moment(new Date)
            onReturnDateChanged: {
                //console.log("isitme",returnDate)
                calendar.selectedDate = returnDate
            }
            Component.onCompleted: {
                banner.date = D.moment(calendar.selectedDate)
                //console.log("seldate",calendar.selectedDate)
            }
        }
        Rectangle {
            color: "orange"
            radius: 15
            anchors.right: parent.right
            anchors.rightMargin: width/4
            width: parent.width/3
            height: parent.height
            Rectangle {
                color: "linen"
                radius: 10
                anchors.fill: parent
                anchors.margins: parent.height/10
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: parent.width/10
                    textFormat: Text.AlignHCenter
                    text: "Add a prayer"
                    color: "royalblue"


                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        entry.push({item: prayerEdit, properties: {selectedDate: calendar.selectedDate, text: "", create: true}})
             /*           if (Qt.platform.os != "android") {
                        prayerEditor.create = true
                        prayerEditor.visible = true
                        }*/
                    }
                }
            }

        }



    }

    Rectangle {
        id:calendar
        anchors.top: topRect.bottom
        anchors.topMargin: parent.height/40
       // model: calPrayers.model3
        property bool busy: entry.busy
       // delegate: calDelegate
        width: parent.width
        height: parent.height*7/8
       // cellWidth: width
      //  cellHeight: height
        property var selectedDate
        property var currentDate
        property var currentPrayers
        property var currentSheets
        onSelectedDateChanged:  {

            calPrayers.getCalendar(selectedDate.year(),selectedDate.month()+1,selectedDate.date(),"day")
            banner.date = selectedDate//.format("MMM YYYY")
        }



        Timer {
            id: tim1
              interval: 1; running: false; repeat: false
                onTriggered: {
                    if (!entry.busy) {
                        calendar.selectedDate = top.selectedDate
                        calendar.currentDate = selectedDate
                        calPrayers.getCalendar(selectedDate.year(),selectedDate.month()+1,selectedDate.date(),"day")
                    }
                    else restart()
            }
        }

        Component.onCompleted: {

            tim1.start()

        }
        Rectangle {
            id: topbar
            anchors.top: parent.top
            height: parent.height/15
            width: parent.width
            Text {
                id: calInfo
                font.pixelSize: parent.height/10

                text: D.moment(calendar.selectedDate).format("ddd Do")
            }

        }
        Rectangle {
            id: prayerSpace
            anchors.top: topbar.bottom
            height: parent.height - topbar.height
            width: parent.width
            color: "black"
            property int highestZ: 0
            property real defaultSize: Screen.width/4
            property var currentPrayer: undefined
            Component.onCompleted: {
                //console.log("ptext", calPrayers.model3.get(0).prayers)
            }
            Repeater {
                id: prayerRepeat

                model:  calPrayers.model3.get(0).prayers
                property var count: model.count
                onCountChanged: {

                }

                Rectangle {
                    id: prayerFrame
                    width: prayerText.contentWidth * prayerText.scale + 20
                    height: prayerText.contentHeight * prayerText.scale + 20
                    border.color: "yellow"
                    border.width: 2

                    smooth: true
                    antialiasing: true
                    x: Math.random() * (prayerSpace.width - prayerSpace.defaultSize)
                    y: Math.random() * (prayerSpace.height - prayerSpace.defaultSize)
                    rotation: Math.random() * 13 - 6
                    color: "lightyellow"




                    Text {
                    id: prayerText
                    anchors.centerIn: parent
                    //width: parent.width ;//height: parent.height;
                    wrapMode: Text.WordWrap
                    scale: prayerSpace.defaultSize  / Math.max(contentWidth, contentHeight)
                    textFormat: Text.RichText
                    text: prayer + "\n\n by " + user.username
                    Component.onCompleted: {
                       // console.log(prayer)
                    }

                }
                    PinchArea {
                        anchors.fill: parent
                        pinch.target: prayerFrame
                        pinch.minimumRotation: -360
                        pinch.maximumRotation: 360
                        pinch.minimumScale: 0.5
                        pinch.maximumScale: 10
                        onPinchStarted: setFrameColor();
                        MouseArea {
                            id: dragArea
                            hoverEnabled: true
                            anchors.fill: parent
                            drag.target: prayerFrame
                            onPressed: {
                                prayerFrame.z = ++prayerSpace.highestZ;
                                parent.setFrameColor();
                            }
                            onClicked: {
                                entry.push({item: prayerEdit, properties: {selectedDate: calendar.selectedDate, text: prayer, create: false, pid: id}})
                            }
                            onEntered: parent.setFrameColor();
                            onWheel: {
                                if (wheel.modifiers & Qt.ControlModifier) {
                                    prayerFrame.rotation += wheel.angleDelta.y / 120 * 5;
                                    if (Math.abs(prayerFrame.rotation) < 4)
                                        prayerFrame.rotation = 0;
                                } else {
                                    prayerFrame.rotation += wheel.angleDelta.x / 120;
                                    if (Math.abs(prayerFrame.rotation) < 0.6)
                                        prayerFrame.rotation = 0;
                                    var scaleBefore = prayerText.scale;
                                    prayerText.scale += prayerText.scale * wheel.angleDelta.y / 120 / 10;
                                    prayerFrame.x -= prayerText.width * (prayerText.scale - scaleBefore) / 2.0;
                                    prayerFrame.y -= prayerText.height * (prayerText.scale - scaleBefore) / 2.0;
                                }
                            }
                        }
                        function setFrameColor() {
                            //console.log("setFrame")
                            if (prayerSpace.currentPrayer)
                                prayerSpace.currentPrayer.border.color = "yellow";
                            prayerSpace.currentPrayer = prayerFrame;
                            prayerSpace.currentPrayer.border.color = "red";
                        }
                    }
            }

        }

    }

}
    ListModel {
        id: caldata

    }
    Cont.PrayerController {
        id: calPrayers
        onM3readyChanged: {
            //console.log(model3.count, model3.get(0).prayers.count)
            if (model3.get(0).prayers.count)
            prayerRepeat.model = model3.get(0).prayers
            else
                prayerRepeat.model = noprayer
        }

        onReadyChanged: {


                if (status == 200) {
                    //GET
                    //console.log(model3.count)


                }
                if (status == 201) {
                    //POST
                    //cont1.getAll()
                    tim2.start()



                }
                if (status == 202) {
                    //PUT
                    tim2.start()

                }
                if (status == 203) {
                    //PUT
                    //cont1.getAll()
                     tim2.start()
                }
                if (status == 204) {
                    //DELETE
                   // cont1.getAll()
                     tim2.start()

                }
                if (status == 422) {

                    //error
                    //console.log(JSON.stringify(JSON.parse(jsn).errors))
                    entry.status = JSON.stringify(JSON.parse(jsn).errors)


                }
        }
    }
    Component {
        id: editev
        L.EditPrayer {


    }
    }
    Component {
        id: prayerEdit
        L.PrayerEditor {


    }
    }

    Component {
        id: prayerRect
        Rectangle {
            property alias text: evTitle.text

            Text {
                id: evTitle
            }
        }
    }

    ListModel {
        id: noprayer
                          ListElement {
                              prayer: '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:"Droid Sans [unknown]"; font-size:9pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"><span style=" font-size:23pt;">Who will add the first prayer?</span></p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-size:23pt;"><br /></p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-size:23pt;"><br /></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"><span style=" font-size:23pt;">Just click the </span><span style=" font-size:23pt; color:#ff0000;">add a prayer</span><span style=" font-size:23pt;"> button</span></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"><span style=" font-size:23pt;">and type. Then click the </span><span style=" font-size:23pt; color:#ffff00;">save</span><span style=" font-size:23pt;"> button.</span></p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-size:23pt;"><br /></p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-size:23pt;"><br /></p></body></html>'
                              user:  ListElement {
                              username: "admin" }
                          }

                          }

    }





