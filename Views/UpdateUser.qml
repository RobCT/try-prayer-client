import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "../controllers" as Cont

Rectangle {

    id: top

    anchors.fill: parent
    color: "khaki"
    function initForm() {

        te1.text = entry.signin.userName
        te2.text = entry.signin.currentEmail

    }

    Component.onCompleted: {
        //cont1.getUsers(index)
        initForm()
    }
    Row {
        id: wrapper
        width: 17*parent.width/24
        height: parent.height/2
        x: (top.width - width)/2
        y: (top.height - height)/4

        Column {
            id: labels
            height: parent.height
            width: top.width/3
            Rectangle {
                width: parent.width
                height: parent.height/4
                border.width: 1
                color: "lightgrey"
                Text {

                    text: "User Name"
                    width: parent.width
                    height: parent.height
                    font.pixelSize: height * 0.3
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            Rectangle {
                height: parent.height/4
                width: parent.width
                border.width: 1
                color: "lightgrey"
                Text {
                    text: "Email"
                    width: parent.width
                    height: parent.height
                    font.pixelSize: height * 0.3
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            Rectangle {
                height: parent.height/4
                width: parent.width
                border.width: 1
                color: "lightgrey"
                Text {
                    text: "password"
                    width: parent.width
                    height: parent.height
                    font.pixelSize: height * 0.3
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            Rectangle {
                height: parent.height/4
                width: parent.width
                border.width: 1
                color: "lightgrey"
                Text {
                    text: "password confirmation"
                    width: parent.width
                    height: parent.height
                    font.pixelSize: height * 0.3
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        Rectangle {
            id: controls
            width: top.width/8
            height: parent.height
            border.width: 1
            color: "lightgrey"
            x: labels.x + labels.width
            Text {
                text: "Update"
                height: parent.height/4
                width: parent.width
                font.pixelSize: height * 0.3
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            MouseArea {
                width: parent.width
                height: parent.height
                onClicked: {
                    cont1.updateUser(JSON.stringify({username: te1.text, email: te2.text}))
                }
            }

        }
        Column {
            id: inputs
            height: parent.height
            width: top.width/3
            x: controls.x + controls.width
            Rectangle {
                height: parent.height/4
                width: parent.width
                border.width: 1
                color: "lightseagreen"
                TextEdit {
                    id: te1
                    height: parent.height
                    width: parent.width
                    font.pixelSize: height * 0.3
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                height: parent.height/4
                width: parent.width
                border.width: 1
                color: "lightseagreen"
                TextEdit {
                    id: te2
                    inputMethodHints: Qt.ImhEmailCharactersOnly
                    height: parent.height
                    width: parent.width
                    font.pixelSize: height * 0.3
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                height: parent.height/4
                width: parent.width
                border.width: 1
                color: "lightseagreen"
                TextEdit {
                    id: te3
                    inputMethodHints: Qt.ImhHiddenText
                    height: parent.height
                    width: parent.width
                    font.pixelSize: height * 0.3
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                height: parent.height/4
                width: parent.width
                border.width: 1
                color: "lightseagreen"
                TextEdit {
                    id: te4
                    inputMethodHints: Qt.ImhHiddenText
                    height: parent.height
                    width: parent.width
                    font.pixelSize: height * 0.3
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    Timer {
        id: tim1
          interval: 750; running: false; repeat: false
            onTriggered: {

                controls.color = "lightgrey"

            }
    }







  Cont.UserController {
      id: cont1
      onM2readyChanged: {
          top.initForm()

      }

      onReadyChanged: {

              if (status == 200) {
                  //GET

              }
              if (status == 201) {
                  //POST
                  cont1.getAll()


              }
              if (status == 202) {
                  //PUT
                  controls.color = "red"
                  tim1.start()
                  entry.signin.userName = te1.text
                  entry.signin.currentEmail = te2.text
                  //console.log("PUTpf")

              }
              if (status == 203) {
                  //PUT
                  controls.color = "red"
                  tim1.start()
                  entry.signin.userName = te1.text
                  entry.signin.currentEmail = te2.text

              }
              if (status == 204) {
                  //DELETE
                  cont1.getAll()

              }
              if (status == 422) {

                  //error
                  console.log(JSON.stringify(JSON.parse(jsn).errors))
                  entry.status = JSON.stringify(JSON.parse(jsn).errors)


              }
      }
  }
}

