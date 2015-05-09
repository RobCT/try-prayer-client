/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 */

import QtQuick 2.4
import "jsonpath.js" as JSONPath

import "../scripts/globals.js" as G


Item {
    id: intmodel

    property string source: ""
    property var json//: http.jsn
    property string query: ""
    property int readyId
    property bool trigger
    property string method
    property string params
    property bool ready//: http.ready
    property int status//: http.status


    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count
    Component.onCompleted: {
//        Func.internalQmlObject.servDone.connect(internalCom);
        method = "GET"

    }
    function internalCom(callid)    {
        if (callid == 99) {
            //ready = true
        }
    }

    onTriggerChanged: {
        somethingChanged()
    }

/*    onSourceChanged: {
        somethingChanged()
    }
    onParamsChanged: {
        somethingChanged()
    }*/

    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function commit() {
        if (trigger) trigger = false
        else trigger = true
    }

    function updateJSONModel() {
        jsonModel.clear();
        //console.log(json)

        if ( json === "" )
            return;
        try{
            var    a=JSON.parse(json);
         }catch(e){
              //error in the above string(in this case,yes)!

            return;
         }


        var objectArray = parseJSONString(json, query);
        //console.log("count", objectArray)
        //jsonModel.append(objectArray)

        for ( var key in objectArray ) {
            var jo = objectArray[key];
            //console.log(jo)
            jsonModel.append( jo );
        }
       // }
    }

    function parseJSONString(jsonString, jsonPathQuery) {
        var objectArray = JSON.parse(jsonString);
        if ( jsonPathQuery !== "" )
            objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);

        return objectArray;
    }
    function somethingChanged() {
        if (method === "GET") {

            try {
                ready = false
                G.jsonString = ""
               servReq("GET", "", source, 99)
                //console.log("source",source, json)

                G.jsonString = json

            } catch(e) {

                return;
            }
        }
        else {
            try {
                ready = false
               servReq(method, params, source, 99)
               // console.log("source",source, json)
                //ready = false
                method = "GET"
            } catch(e) {

                return;
            }

        }
    }

    function servReq(method, params, url, callid) {
        var internalQmlObject = Qt.createQmlObject('import QtQuick 2.0; QtObject { signal servDone(int value) }', Qt.application, 'InternalQmlObject');
        var xhr = new XMLHttpRequest();
        ready = false
        xhr.onreadystatechange=function(){
          if (xhr.readyState==4 && xhr.status==200)
         {
/*              internalQmlObject.servDone(callid);
              jsn = xhr.responseText
              //console.log("one",xhr.responseText, url)
              //return jsn
*/

          }
          if (xhr.readyState==4) {
              internalQmlObject.servDone(callid);
              status = xhr.status
              json = xhr.responseText
              //ready = false
              //console.log("one", ready)
              if (ready) ready = false
              else ready = true

              //console.log("two",xhr.status, ready, url)
              //json = jsonString




          }
        }
        var async = true;
        xhr.open(method, url, async);
       // console.log(method,url)
      //Need to send proper header information with POST request
      xhr.setRequestHeader('Content-type', 'application/json');
      //xhr.setRequestHeader('Content-length', params.length);
      //xhr.setRequestHeader('Host:', 'api.marketplace.dev');
        xhr.setRequestHeader('Accept', 'application/vnd.marketplace.v1');
        xhr.setRequestHeader('Host', 'api.marketplace.dev');
        xhr.setRequestHeader('Connection', 'Keep-Alive');
        xhr.setRequestHeader('Authorization', G.token);
        //console.log("token", G.token)
        if (method === "DELETE") {
            //console.log("delete params", params)
        }

        if (params.length) {
            xhr.send(params);
        }
        else xhr.send();
    }


}
