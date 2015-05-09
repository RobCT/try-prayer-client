import QtQuick 2.4


import "../scripts/globals.js" as G
import "." as L
Item {
    property alias model1: model1.model
    property alias model2: model2.model
    property alias m2ready: model2.ready
    property alias m2status: model2.status
    property alias ready: model4.ready
    property int readyId
    property alias jsn: model4.json
    property alias status: model4.status
    property alias m1ready: model1.ready
    property alias m1status: model1.status



    id: userController
    Component.onCompleted: {
//        F.internalQmlObject.servDone.connect(internalRefresh);
       // G.apiRoot=Qt.platform.os == "android" ? "192.168.0.103:8080" : "127.0.0.1:8080"
    }
    L.JSONListModel {
        id:model1
    }
    L.JSONListModel {
        id:model2
    }
    L.JSONListModel {
        id:model4
    }
    function internalRefresh(callid) {
        userController.readyId = callid
        if (callid == 2) {
            userController.ready = true
            getAll()
        }
    }
    function getAll() {
        model1.method = "GET"
        model1.source = ""
        model1.source = G.apiRoot + "/users"
        model1.commit()
        //console.log("source ", model1.source)
    }
    function getUsers(pid) {
        model2.method = "GET"
        model2.source = ""
        model2.source = G.apiRoot + "/users/" + pid.toString()
        model2.commit()
    }
    function newUser(user){
        userController.ready = false
        var method = 'POST';
        var params =  user;
        var url = G.apiRoot + "/registrations";
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function updateUser(role) {
        userController.ready = false
        var method = "PUT"
        var params = role
        var url = G.apiRoot + "/users/" + "1"
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function deleteUser(pid) {
        userController.ready = false
        var method = "DELETE"
        var params = ""
        if (pid > 0) {
         params = JSON.stringify({"uid": pid})
        }
        var url = G.apiRoot + "/users"
        model4.servReq(method, params, url, 2)
        model4.commit()
    }

}

