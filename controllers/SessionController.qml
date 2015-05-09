import QtQuick 2.4


import "../scripts/globals.js" as G
import "." as L
Item {




    property int readyId
    property var tok: {"id": 0, "email":"", "username": "", "password": "", "auth_token": ""}
    property alias jsn: http.jsn
    property alias status: http.status
    property alias ready: http.ready

    ready: false

    id: sessionController
    Component.onCompleted: {
//        F.internalQmlObject.servDone.connect(internalRefresh);
        //G.apiRoot=Qt.platform.os == "android" ? "192.168.0.103:8080" : "127.0.0.1:8080"
    }

    function internalRefresh(callid) {
        sessionController.readyId = callid

    }


    function newSession(user){
        sessionController.ready = false
        var method = 'POST';
        var params =  user;
        //console.log(user)
        var url = G.apiRoot + "/sessions";
        http.servReq(method, params, url, 2)
    }

    function destroySession(tok) {
        sessionController.ready = false
        var method = "DELETE"
        var params = ""
        var url = G.apiRoot + "/sessions/" + tok
        //console.log(url)
        http.servReq(method, params, url, 2)
    }
    L.HTTP {
        id: http

        onJsnChanged:  {
            try {
            var objectArray = JSON.parse(jsn).user;
                //console.log(jsn)
            } catch(e) {
                return
            }
            try {
                sessionController.tok.auth_token = objectArray.auth_token
                sessionController.tok.email = objectArray.email
                sessionController.tok.username = objectArray.username
                sessionController.tok.password = objectArray.password
                sessionController.tok.id = objectArray.id


            } catch(e) {
                return
            }

                    //console.log("TOK",tok)
          }

    }
}

