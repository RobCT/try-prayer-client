import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.2
Rectangle {
    id: eventRect
    height: parent.height - Qt.inputMethod.keyboardRectangle.height
    property string toEdit
    property int recordId
    color: "linen"
    onVisibleChanged: {
        if (visible) {
            edit.text = toEdit
        }
    }
    Component.onCompleted: {
        if (visible) {
            edit.text = toEdit
        }
    }
 Row {
     height: parent.height/2
     width: parent.width
     y: parent.height/4
     x: parent.width/18
    Flickable {
         id: flick

         width: parent.width*0.8; height: parent.height;
         contentWidth: edit.paintedWidth
         contentHeight: edit.paintedHeight
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
             id: edit
             width: flick.width
             height: flick.height
             font.pointSize: 28

             focus: true
             wrapMode: TextEdit.Wrap
             onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
         }
     }
    Button {
        text: "OK"

        onClicked: {
            entry.editProperties = {editText: edit.text, editDone: true, recordId: eventRect.recordId}
            entry.pop()
        }
    }
 }
}

