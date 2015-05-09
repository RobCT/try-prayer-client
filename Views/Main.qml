import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0
import "." as L
import "../components" as Comp
import "../scripts/moment.js" as D
import "../scripts/globals.js" as G
import "../controllers" as Cont





ApplicationWindow {
    id: mainWindow
    title: qsTr("")
    width: 640
    height: 480
    property int navheight
    navheight: height/8
    visible: true
    property string topwidg: "Top"
    statusBar: StatusBar {
        RowLayout {

            Label { id:status; text: entry.status }
        }
    }



    Settings {
        id: settings
        property string email
        property string password
        property string username


    }

    Rectangle {
        color: "black"/*"#212126"*/
        anchors.fill: parent
    }
    toolBar: BorderImage {
        border.bottom: 8
        source: "../images/toolbar.png"
        width: parent.width
        height: mainWindow.height/11

        Rectangle {
            id: backButton
            width: opacity ? mainWindow.navheight : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: mainWindow.navheight
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_previous_item.png"
                width: mainWindow.navheight
                height: mainWindow.navheight
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: entry.pop()
            }
        }




        Text {
            id: banner
            font.pixelSize: mainWindow.height/20
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "Acomb Try Praying"
        }
    }
    StackView {
        id: entry
        anchors.fill: parent
        property var editProperties: {"toEdit": ""  , "editText": "", editTime: "null", editDate: "", editDone: false, recordId: "", editType: "" }
        property string status
        property var lists
        property var pid
        property var signin: {"id": 0,"signedin": false, "auth_token": "", "userName": "", "currentEmail": "", "currentPassword": ""}


       Component.onCompleted: {
           signin.userName = settings.username
           signin.currentEmail = settings.email
           signin.currentPassword = settings.password

           //console.log(signin.currentPassword,signin.auth_token)
           lists = {"blank": {}, "loaded": {}, "update": false, "create": false}
           if (signin.signedin) pushOther(11)
           else {

               if (signin.currentEmail == "" || signin.currentPassword == "" ) {

               push(signinComp)
               }
               else {
                  // push(signinComp)
                session.newSession(JSON.stringify({"email": signin.currentEmail, "password": signin.currentPassword}))
               }
           }
        }
       Component.onDestruction: {
           settings.username = signin.userName
           settings.email = signin.currentEmail
           settings.password = signin.currentPassword

           //console.log(signin.currentPassword,signin.auth_token)
       }
        function pushOther(val) {
            //console.log("signal", val )
            if (val === 1) replace({item: calendar, properties: {selectedDate: D.moment(new Date)}})
            else if (val === 99) push(signinComp)

            else if (val === 7) push(ev2Comp)

            else if (val === 11) push({item: calendar, properties: {selectedDate: D.moment(new Date)}})
            }




    }


    Component {
        id: signinComp
    L.SignIn {
        id: si

    }
    }

    Cont.SessionController {
        id: session
        onReadyChanged: {


                if (session.status == 200) {
                    entry.signin.auth_token = tok.auth_token
                    entry.signin.currentEmail = tok.email
                    entry.signin.userName = tok.username
                    entry.signin.signedin = true
                    entry.signin.id = tok.id
                    //console.log("id", tok.id)
                    G.token = tok.auth_token
                    entry.push({item: calendar, properties: {selectedDate: D.moment(new Date)}})
                    //entry.pushOther(1)
                    //console.log(entry.signin.auth_token,entry.signin.currentEmail, entry.signin.userName)
                }
                else if (session.status == 204) {
                    entry.push({item: calendar, properties: {selectedDate: D.moment(new Date)}})

                }
                else if (session.status == 422) {

                    //fetchStatus.text = "Sorry that email or password is not accepted"
                    //console.log("Sorry that email or password is not accepted")
                    entry.push(signinComp)
                }
                else if (session.status == 500) {

                    fetchStatus.text = "Sorry that email or password is not accepted"
                    //console.log("Sorry that email or password is not accepted")
                    entry.push(signinComp)
                }
                else entry.push(signinComp)
        }

    }
    Component {
        id: calendar
        L.CalendarDay2 {

        }
    }


    Component {
        id: ev2Comp
        Comp.EditEvent {

        }
    }

}

