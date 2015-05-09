import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2
import "../scripts/moment.js" as D
Item {


    id: te



    property alias font: tet1.font
    property alias ratio: tet1.ratio
    property alias color: tet1.textColor
    property alias bcolor: tet1.col
    property alias date: tet1.indate
    property alias goodDate: tet1.validDate
    property alias dateActiveFocus: tet1.activeFocus




    Row {
        anchors.fill: parent
        Component.onCompleted:  {
        }

        TextField {
            id: tet1
            height: parent.height
            width: parent.width*ratio
            style: textStyle
            readOnly: true
            //inputMask: "99:99"

            property var col: "lightgreen"
            property real ratio: 1
            property var time
            property bool dialogModal: true
            property bool customizeTitle: false
            property var indate
            property bool validDate: false
            onTextChanged:  {
                tet1.focus = true



            }


            onIndateChanged:  {
                tet1.text = D.moment(indate).format("ddd, MMM Do YYYY")
                console.log("ohho",tet1.text)
                calendar.selectedDate = D.moment(indate).toDate()
            }

        }
        Rectangle {
            id: r1
            height: parent.height
            width: (parent.width - parent.width*tet1.ratio)
            //anchors.left: tet1.right
            color: "lightgrey"
            border.color: "gray"
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/calendar_icon.png"
                width: parent.width
                height: parent.height
            }
            MouseArea {
                height:parent.height
                width: parent.width
                anchors.top: parent.top
                onClicked: dateDialog.open()

            }




        }

    }

    Component {
        id: textStyle
        TextFieldStyle {
            id: ts
            textColor: "darkblue"
            font.pixelSize: parent.height * 0.3

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
    Dialog {
        id: dateDialog
        modality: tet1.dialogModal ? Qt.WindowModal : Qt.NonModal
        title: tet1.customizeTitle ? windowTitleField.text : "Choose a date"
        onButtonClicked: console.log("clicked button " + clickedButton)
        onAccepted: {
            if (clickedButton == StandardButton.Ok) {
                tet1.indate = D.moment(calendar.selectedDate)
                tet1.indate.hours(12)
                tet1.validDate = true
            }
            else
                tet1.validDate = false
        }
        onRejected: tet1.validDate = false

        Calendar {
            id: calendar
            width: parent ? parent.width : implicitWidth
            onDoubleClicked: dateDialog.click(StandardButton.Ok)
        }
    }


}
