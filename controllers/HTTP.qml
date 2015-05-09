import QtQuick 2.0
import "../scripts/globals.js" as G


Item {
    id: http
    width: 100
    height: 62
    property var jsn
    property var status
    property bool ready
    onReadyChanged: {
        //console.log("readyChangeinsidehttp", ready)
    }

    function servReq(method, params, url, callid) {
        var internalQmlObject = Qt.createQmlObject('import QtQuick 2.0; QtObject { signal servDone(int value) }', Qt.application, 'InternalQmlObject');
        var xhr = new XMLHttpRequest();
        //console.log(url)
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
              jsn = xhr.responseText
              ready = false
              //console.log("one", ready)
              if (ready) ready = false
              else ready = true

              //console.log("two",xhr.status, ready, url)
              //json = jsonString




          }
        }
        var async = true;
        xhr.open(method, url, async);
        //console.log(method,url)
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

