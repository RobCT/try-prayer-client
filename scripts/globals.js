.pragma library
var list = {"blank": {}, "loaded": {}, "update": false, "create": false}
var jsonString
var globQmlObject = Qt.createQmlObject('import QtQuick 2.0; QtObject { signal servDone(int value) }', Qt.application, 'InternalQmlObject');
//var apiRoot = "http://192.168.0.103:8081"
var apiRoot = "https://agile-mesa-2600.herokuapp.com"
var token
