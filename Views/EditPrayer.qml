import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.2
import "." as Local
import "../controllers" as Cont
import "../scripts/moment.js" as D
import "../components" as Comp
Rectangle {
    id: editev

    property var index
    property var setDate
    property bool my_calendar: false
    width: parent.width
    height: parent.height



    Component.onCompleted:  {
        if (visible) {

        //console.log("Booooo",Screen.width,Screen.height)
        if (editev.index > 0 ) {
            cont1.getEvent(editev.index)
        }
        else {
            df1.date = editev.setDate
        }
        }
    }
    //x: (Screen.desktopAvailableWidth - width)/2
    //y: (Screen.desktopAvailableHeight - height)/2
    signal returning(string whereFrom)





Rectangle {
    id: top
    width: parent.width
    height: parent.height
    color: "linen"
    property int actionheight

    onVisibleChanged: {
        if (visible) {

       // console.log("Booooo",Screen.width,Screen.height)
        if (editev.index > 0 ) {
            console.log(entry.editProperties.editDone,entry.editProperties.editTime,entry.editProperties.editType)
            if (entry.editProperties.editDone && entry.editProperties.editType == "Date") {
                entry.editProperties.editObject.date = entry.editProperties.editDate
            }
            else if (entry.editProperties.editDone && entry.editProperties.editType == "Time") {
                entry.editProperties.editObject.time = entry.editProperties.editTime
                console.log("here")
            }
            else if (entry.editProperties.editDone && entry.editProperties.editType == "Text") {
                entry.editProperties.editObject.text = entry.editProperties.editText
            }
            else  cont1.getEvent(editev.index)

        }
        else {
            df1.date = editev.setDate
        }
        }
    }

   function initModel() {
        //console.log("init")
        if (cont1.model2.count > 0) {
        // console.log("doinit")
        textField1.text = cont1.model2.get(0).title
        df1.date = cont1.model2.get(0).eventdate
        te1.time = cont1.model2.get(0).eventstart
        te2.time = cont1.model2.get(0).eventend
         if (cont1.model2.get(0).volunteersheets.count) {

             actionheight = 4
             clone.visible = false
             sheets.visible = true
         }
         else {
             sheets.visible = false
             actionheight = 4
             clone.visible = true
         }

        }

    }
   function stringUp() {
       var jsn
        if (editev.my_calendar)
            jsn = {"event":{"title": textField1.text, "eventdate": df1.date, "eventstart": te1.returnTime, "eventend": te2.returnTime , "is_private": true, "user_id": entry.signin.id}}
        else
            jsn = {"event":{"title": textField1.text, "eventdate": df1.date, "eventstart": te1.returnTime, "eventend": te2.returnTime , "is_private": false, "user_id": entry.signin.id}}

       return JSON.stringify((jsn))

   }


        Row {
            height: parent.height
            width: parent.width

        Column {
            id: column2
            //anchors.left: parent.left
            height:parent.height
            //anchors.top: eventSelect.bottom
            //anchors.bottom: parent.bottom
            width: parent.width*7/16

            Rectangle {

                width: parent.width
                y: parent.height/5
                color: "beige"
                radius: 4
                height: parent.height/5



            Text {
                id: text1
                height: parent.height
                text: qsTr("Title")
                font.pixelSize: height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: Text.AlignVCenter


            }
            }
            Rectangle {
                width: parent.width
                color: "beige"
                radius: 4
                height: parent.height/5

            Text {
                id: text2

                text: qsTr("Date")
                font.pixelSize: height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: Text.AlignVCenter
                height: parent.height

            }
            }
            Rectangle {
                width: parent.width
                color: "beige"
                radius: 4
                height: parent.height/5

            Text {
                id: text3

                text: qsTr("Start time")
                font.pixelSize: height * 0.3

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: Text.AlignVCenter
                height: parent.height

            }
            }
            Rectangle {
                width: parent.width
                color: "beige"
                radius: 4
                height: parent.height/5

            Text {
                id: text4

                text: qsTr("End")
                font.pixelSize: height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: Text.AlignVCenter
                height: parent.height
            }


            }
            Rectangle {
                width: parent.width
                color: "beige"
                radius: 4
                height: parent.height/5

            Text {
                id: text5

                text: qsTr("Type")
                font.pixelSize: height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: Text.AlignVCenter
                height: parent.height


            }
            }
        }

        Rectangle {
            id: rectangle1
            //anchors.left: column2.right
            //anchors.top: eventSelect.bottom
            //anchors.bottom: parent.bottom
            height:parent.height
            width: parent.width/8


            color: "#ffffff"

            MouseArea {
                anchors.fill: parent
                onClicked: {

 //                   entry.lists.loaded = top.record
   //                 console.log("mmm", entry.lists.loaded.date)
     //               entry.pop()
                }
            }
            Column {
                width: parent.width
                height: parent.height

            Rectangle {
                id: upcreate
                radius: 6
                width: parent.width
                height: parent.height/top.actionheight
                color: "lightyellow"
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: editev.index === 0 ? "Create" : "Update"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {
                        if (editev.index > 0) {
                            //tim2.dt = D.moment(entry.lists.loaded.date)
                            cont1.updateEvent(top.stringUp(), editev.index)
                            console.log(top.stringUp())

                            //tim2.start()
                        }
                        else {
                            //top.newp = false
                            //entry.lists.update = true
                            //entry.lists.create = false
                            //tim2.dt = D.moment(entry.lists.loaded.date)
                            cont1.newEvent(top.stringUp())
                            console.log(top.stringUp())

                            //tim2.start()


                        }


                    }
                }

            }
            Rectangle {
                id: save
                radius: 6
                width: parent.width
                height: parent.height/top.actionheight
                color: "skyblue"
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "New"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {
                        console.log(editev.index)
                        if (editev.index > 0 ) {
                            cont1.getEvent(index)
                        }

 //                       top.record.id_type_ae = cont1.model3.get(0).id_amc_event_type




                    }
                }

            }
            Rectangle {
                id: del
                radius: 6
                width: parent.width
                height: parent.height/top.actionheight
                color: "red"
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Delete"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {

                       cont1.deleteEvent(editev.index)


                    }
                }
            }
            Rectangle {
                id: sheets
                radius: 6
                width: parent.width
                height: parent.height/top.actionheight
                color: "steelblue"
                visible: false
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Volunteer\n Sheet"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {

                       entry.push({item: sheet, properties: {index: editev.index}})


                    }
                }
            }
            Rectangle {
                id: clone
                radius: 6
                width: parent.width
                height: parent.height/top.actionheight
                color: "aqua"
                visible: false
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Clone \nVolunteer\n Sheets"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {

                        entry.push({item: cloneSheet, properties: {index: editev.index}})


                    }
                }
            }
            }
        }
        Column {
            id: column1
            //anchors.left: rectangle1.right
            //anchors.top: eventSelect.bottom
            //anchors.bottom: parent.bottom
            height:parent.height
            width: parent.width*7/16

            Flickable {
                 id: flick

                 width: parent.width; height: parent.height/5;
                 contentWidth: textField1.paintedWidth
                 contentHeight: textField1.paintedHeight
                 clip: true

                 function ensureVisible(r)
                 {
                     if (contentX >= r.x)
                         contentX = r.x;
                     else if (contentX+width <= r.x+r.width)
                         contentX = r.x+r.width-width;
                     if (contentY >= r.y)
                         contentY = r.y;
                     else if (contentY+height <= r.y+r.height)
                         contentY = r.y+r.height-height;
                 }

                 TextEdit {
                     id: textField1
                     width: flick.width
                     height: flick.height
                     font.pixelSize:  height * 0.3

                     focus: true
                     wrapMode: TextEdit.Wrap
                     onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                 }
             }

/*            TextField {
                id: textField1

                width: parent.width
                placeholderText: qsTr("Text Field")

                height: parent.height/5
                onEditingFinished: {


                }
            }*/

            Comp.DateEdit {
                id: df1

                width: parent.width
                height: parent.height/5
                ratio: 0.8
                bcolor: "white"
                //date:
                onGoodDateChanged: {
                    //if (!top.newp) entry.lists.update = true
                   // else entry.lists.create = true
                    //console.log(date,top.record.date)
                    //top.record.events.date = D.moment(date).format("YYYY-MM-DD")
                    //console.log(date,top.record.events.date)
                }

            }

            Comp.TimeTumblerInput {
                id:te1
                width:parent.width
                height: parent.height/5
            }


  /*          Comp.TimeEdit {
                id: te1
                width: parent.width
                //time:
                height: parent.height/5
                ratio: 0.8
                bcolor: "white"
                onTimeChanged: {

                }
                onTimeActiveFocusChanged:  {

                        if (editev.visible) {
                        entry.editProperties = {toEdit: time, editDone: false, recordId: editev.index, editObject: te1, editType: "Time"}
                        entry.push({item: timeInput, properties: {toEdit: time, recordId: editev.index}})
                        }

                }

                onFocusChanged: {
                    if (!focus) {
                        Qt.inputMethod.hide()
                    }
                    else {
                        entry.editProperties = {toEdit: time, editDone: false, recordId: editev.index, editObject: df1}
                        entry.push({item: editText, properties: {toEdit: time, recordId: editev.index}})
                    }
                }

            } */

            Comp.TimeTumblerInput {
                id:te2
                width:parent.width
                height: parent.height/5
            }
 /*           Comp.TimeEdit {
                id:te2
                width: parent.width
                //time:
                height: parent.height/5
                ratio: 0.8
                bcolor: "white"

                onTimeChanged: {

                }
                onFocusChanged: {
                    if (!focus) {
                        Qt.inputMethod.hide()
                    }
                }

            }*/

        }
        }


    Cont.PrayerController {
        id:cont1
        onM2readyChanged: {
            if (m2status == 200) {
                 top.initModel()
            }
        }

        onReadyChanged: {
            console.log("readyChangedevcomp")

                if (status == 200) {
                    //GET
                    top.initModel()

                }
                if (status == 201) {
                    //POST
                    //cont1.getAll()
                    console.log("popop")
                    editev.returning("Post")
                    //editev.parent.repop()
                    if (ready) entry.pop()



                }
                if (status == 202) {
                    //PUT
                    editev.returning("Put")
                    console.log("popop")
                    //editev.parent.repop()
                     if (ready) entry.pop()

                }
                if (status == 203) {
                    //PUT
                    //cont1.getAll()

                }
                if (status == 204) {
                    //DELETE
                   // cont1.getAll()
                    editev.returning("Delete")
                    console.log("popop")
                    //editev.parent.repop()
                     if (ready) entry.pop()

                }
                if (status == 422) {

                    //error
                    console.log(JSON.stringify(JSON.parse(jsn).errors))
                    entry.status = JSON.stringify(JSON.parse(jsn).errors)


                }
        }

    }

    Component {
        id: dateInput
        Comp.DateInput {

        }
    }
    Component {
        id: timeInput
        Comp.TimeInput {

        }
    }
}
}





