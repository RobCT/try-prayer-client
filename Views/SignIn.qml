import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "../controllers" as Cont
import "../scripts/globals.js" as G
Rectangle {
    id: rectangle1
    width: parent.width
    height: parent.height
    color: "beige"
    property var passwordstr
    Component.onCompleted: {
        var randomstr = Math.random().toString(36).slice(-8);
        passwordstr = randomstr
    }

    Grid {
        id: g1
        y: parent.height/6
        width: parent.width/3
        x: parent.width/6

        columns: 2
        rows: 6
        columnSpacing: parent.width/10
        rowSpacing: parent.height/20
        Text {text: "Your user name"}
        TextField {
            id: username
            width: parent.width/2
            placeholderText: qsTr("your username")

        }
        Text {text: "Your email"}
        TextField {
            id: email
            validator: RegExpValidator { regExp:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
            width: parent.width/2
            placeholderText: qsTr("your email")

        }


        Text {text: "First Name"}
        TextField {
            id: password

            width: parent.width/2
            placeholderText: qsTr("your first name")

        }
        Text {
            id: txtCp
            visible: true
            text: "Last Name"
        }
        TextField {
            id: passwordConfirm
            visible: true

            width: parent.width/2
            placeholderText: qsTr("yout last name")

        }

        Button {
            id: signin
            text: "Create account"
            onClicked: {
                    signin.text = "Sign In"
                    entry.signin.currentPassword = rectangle1.passwordstr
                    entry.signin.userName = username.text
                    entry.signin.currentEmail = email.text
                    users.newUser(JSON.stringify({"user":{"username": username.text,   "email": email.text, "password": rectangle1.passwordstr, "password_confirmation": rectangle1.passwordstr, "firstname": password.text, "lastname": passwordConfirm.text}}))





        }
        }





        TextArea {
            id:fetchStatus
            width: parent.width
            //height:parent.height

        }

        Component.onCompleted:  {

            username.text = entry.signin.userName
            email.text = entry.signin.currentEmail
            password.text = entry.signin.currentPassword
        }
    }
    Cont.UserController {
        id: users
        onReadyChanged: {
            //console.log("return",jsn, status)
            if (status != 201) {
                fetchStatus.append(jsn)
            }
            if (status == 201) {
                if (username.text.length)
                    session.newSession(JSON.stringify({"username": username.text, "password": entry.signin.currentPassword}))
                else
                   session.newSession(JSON.stringify({"email": email.text, "password": entry.signin.currentPassword}))
            }

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
                    console.log("id", tok.id)
                    G.token = tok.auth_token
                    entry.pushOther(1)
                    console.log(entry.signin.auth_token,entry.signin.currentEmail, entry.signin.userName)
                }
                if (session.status == 201) {

                    entry.signin.auth_token = tok.auth_token
                    entry.signin.currentEmail = tok.email
                    entry.signin.userName = tok.username
                    entry.signin.signedin = true
                    entry.signin.id = tok.id
                    console.log("createdid", tok.id)
                    G.token = tok.auth_token
                    entry.pushOther(1)
                    console.log(entry.signin.auth_token,entry.signin.currentEmail, entry.signin.userName)
                }

                if (status == 204) {
                    entry.pushOther(1)

                }
                if (status == 422) {
                    fetchStatus.text = "Sorry that email or username is not accepted"
                    console.log("Sorry that email or password is not accepted")
                }





        }



    }
}

