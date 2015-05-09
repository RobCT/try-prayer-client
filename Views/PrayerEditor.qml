import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1
import org.qtproject.tryprayer 1.0
import "../controllers" as Cont

Rectangle {
    id: top
    visible: true

    width: parent.width
    height:parent.height
    property var text
    property int pid
    property bool create: false
    property var selectedDate
    property string username
    function stringUp() {
        var jsn

             jsn = {"prayer":{"title": "", "prayerdate": top.selectedDate, "prayer": textArea.text,  "user_id": entry.signin.id}}

        return JSON.stringify((jsn))

    }
    function stringUp2() {
        var jsn

             jsn = {"prayer":{"title": "", "prayer": textArea.text}}

        return JSON.stringify((jsn))

    }


    MessageDialog {
        id: aboutBox
        title: "About Text"
        text: "This is a basic text editor \nwritten with Qt Quick Controls"
        icon: StandardIcon.Information
    }

    Action {
        id: cutAction
        text: "Cut"
        shortcut: "ctrl+x"
        iconSource: "../images/editcut.png"
        iconName: "edit-cut"
        onTriggered: textArea.cut()
    }

    Action {
        id: copyAction
        text: "Copy"
        shortcut: "Ctrl+C"
        iconSource: "../images/editcopy.png"
        iconName: "edit-copy"
        onTriggered: textArea.copy()
    }

    Action {
        id: pasteAction
        text: "Paste"
        shortcut: "ctrl+v"
        iconSource: "qrc:images/editpaste.png"
        iconName: "edit-paste"
        onTriggered: textArea.paste()
    }

    Action {
        id: alignLeftAction
        text: "&Left"
        iconSource: "../images/textleft.png"
        iconName: "format-justify-left"
        shortcut: "ctrl+l"
        onTriggered: document.alignment = Qt.AlignLeft
        checkable: true
        checked: document.alignment == Qt.AlignLeft
    }
    Action {
        id: alignCenterAction
        text: "C&enter"
        iconSource: "../images/textcenter.png"
        iconName: "format-justify-center"
        onTriggered: document.alignment = Qt.AlignHCenter
        checkable: true
        checked: document.alignment == Qt.AlignHCenter
    }
    Action {
        id: alignRightAction
        text: "&Right"
        iconSource: "../images/textright.png"
        iconName: "format-justify-right"
        onTriggered: document.alignment = Qt.AlignRight
        checkable: true
        checked: document.alignment == Qt.AlignRight
    }
    Action {
        id: alignJustifyAction
        text: "&Justify"
        iconSource: "../images/textjustify.png"
        iconName: "format-justify-fill"
        onTriggered: document.alignment = Qt.AlignJustify
        checkable: true
        checked: document.alignment == Qt.AlignJustify
    }

    Action {
        id: boldAction
        text: "&Bold"
        iconSource: "../images/textbold.png"
        iconName: "format-text-bold"
        onTriggered: document.bold = !document.bold
        checkable: true
        checked: document.bold
    }

    Action {
        id: italicAction
        text: "&Italic"
        iconSource: "../images/textitalic.png"
        iconName: "format-text-italic"
        onTriggered: document.italic = !document.italic
        checkable: true
        checked: document.italic
    }
    Action {
        id: underlineAction
        text: "&Underline"
        iconSource: "../images/textunder.png"
        iconName: "format-text-underline"
        onTriggered: document.underline = !document.underline
        checkable: true
        checked: document.underline
    }

    FileDialog {
        id: fileDialog
        nameFilters: ["Text files (*.txt)", "HTML files (*.html)"]
        onAccepted: document.fileUrl = fileUrl
    }

    ColorDialog {
        id: colorDialog
        color: "black"
        onAccepted: document.textColor = color
    }

    Action {
        id: fileOpenAction
        iconSource: "../images/fileopen.png"
        iconName: "document-open"
        text: "Open"
        onTriggered: fileDialog.open()
    }
    Action {
        id: savePrayer
        iconSource: "../images/filesave.png"
        iconName: "document-save"
        text: "Save"
        onTriggered: {
           if (top.create) {
               calPrayers.newPrayer(top.stringUp())
               entry.pop()
           }
           else {
               calPrayers.updatePrayer(top.stringUp2(), top.pid)
               entry.pop()
           }


        }
    }

    MenuBar {
        id: mb

        Menu {
            title: "&File"
            MenuItem { action: fileOpenAction }
            MenuItem { text: "Quit"; onTriggered: Qt.quit() }
        }
        Menu {
            title: "&Edit"
            MenuItem { action: copyAction }
            MenuItem { action: cutAction }
            MenuItem { action: pasteAction }
        }
        Menu {
            title: "F&ormat"
            MenuItem { action: boldAction }
            MenuItem { action: italicAction }
            MenuItem { action: underlineAction }
            MenuSeparator {}
            MenuItem { action: alignLeftAction }
            MenuItem { action: alignCenterAction }
            MenuItem { action: alignRightAction }
            MenuItem { action: alignJustifyAction }
            MenuSeparator {}
            MenuItem {
                text: "&Color ..."
                onTriggered: {
                    colorDialog.color = document.textColor
                    colorDialog.open()
                }
            }
        }
        Menu {
            title: "&Help"
            MenuItem { text: "About..." ; onTriggered: aboutBox.open() }
        }
    }

     ToolBar {
        id: mainToolBar
        //width: parent.width
        anchors.left: parent.left
        anchors.leftMargin: parent.width/8
        anchors.top: parent.top
        RowLayout {
            anchors.fill: parent
            spacing: 0
            ToolButton { action: savePrayer }

            ToolBarSeparator {}

            ToolButton { action: copyAction }
            ToolButton { action: cutAction }
            ToolButton { action: pasteAction }

            ToolBarSeparator {}

            ToolButton { action: boldAction }
            ToolButton { action: italicAction }
            ToolButton { action: underlineAction }

            ToolBarSeparator {}

            ToolButton { action: alignLeftAction }
            ToolButton { action: alignCenterAction }
            ToolButton { action: alignRightAction }
            ToolButton { action: alignJustifyAction }

            ToolBarSeparator {}

            ToolButton {
                id: colorButton
                property var color : document.textColor
                Rectangle {
                    id: colorRect
                    anchors.fill: parent
                    anchors.margins: 8
                    color: Qt.darker(document.textColor, colorButton.pressed ? 1.4 : 1)
                    border.width: 1
                    border.color: Qt.darker(colorRect.color, 2)
                }
                onClicked: {
                    colorDialog.color = document.textColor
                    colorDialog.open()
                }
            }
            Item { Layout.fillWidth: true }
        }
    }

    ToolBar {
        id: secondaryToolBar
        width: parent.width
        anchors.top: mainToolBar.bottom

        RowLayout {
            anchors.fill: parent
            ComboBox {
                id: fontFamilyComboBox
                implicitWidth: top.width/8
                model: Qt.fontFamilies()
                property bool special : false
                onActivated: {
                    if (special == false || index != 0) {
                        document.fontFamily = textAt(index)
                    }
                }
            }
            SpinBox {
                id: fontSizeSpinBox
                activeFocusOnPress: true
                implicitWidth: top.width/20
                value: 0
                property bool valueGuard: true
                onValueChanged: if (valueGuard) document.fontSize = value
            }
            Item { Layout.fillWidth: true }
        }
    }

    Rectangle {
        id: textRect
        anchors.top: secondaryToolBar.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        color: "white"
 /*       PinchArea {
            width: parent.width
            height: parent.height
            //pinch.target: textArea

            property real initialWidth
            property real initialHeight
            property real initialScale
            //![0]
            onPinchStarted: {

                initialScale = pinch.scale
                textArea.zoom = initialScale

            }

            onPinchUpdated: {
                //console.log("zoom", textArea.zoom, textArea.scale, pinch.scale)

                textArea.scale = pinch.scale > 5 ? 10 : 2*pinch.scale
            }
        }*/

    TextArea {
        Accessible.name: "document"
        id: textArea
        frameVisible: true
        //x: (parent.width - width)/2
        anchors.fill: parent
        //anchors.verticalCenter: parent.verticalCenter
        wrapMode: TextEdit.NoWrap

        //property real zoom: 1.2
        //height:0
        //property real zoom


        //scale: parent.width/implicitWidth > parent.height/implicitHeight ? parent.height/implicitHeight  :p arent.width/implicitWidth
        //transform: Scale { origin.x: 0; origin.y: y; xScale: 1.5; yScale: 1.5}
        //anchors.top: secondaryToolBar.bottom
        //anchors.bottom: parent.bottom
        baseUrl: "qrc:/"
        text: document.text
        textFormat: Qt.RichText
       // Component.onCompleted: forceActiveFocus()
/*        PinchArea {
            anchors.fill: parent
            pinch.target: textArea
            pinch.minimumRotation: -360
            pinch.maximumRotation: 360
            pinch.minimumScale: 0.1
            pinch.maximumScale: 10
            MouseArea {
                id: dragArea
                hoverEnabled: true
                anchors.fill: parent
                drag.target: textArea
                onPressed: {
                    textArea.z = ++root.highestZ;

                }

                onWheel: {
                    if (wheel.modifiers & Qt.ControlModifier) {
                        textArea.rotation += wheel.angleDelta.y / 120 * 5;
                        if (Math.abs(textArea.rotation) < 4)
                            textArea.rotation = 0;
                    } else {
                        textArea.rotation += wheel.angleDelta.x / 120;
                        if (Math.abs(textArea.rotation) < 0.6)
                            textArea.rotation = 0;


                    }
                }
            }
    } */

    }
    }





    DocumentHandler {
        id: document
        target: textArea
        cursorPosition: textArea.cursorPosition
        selectionStart: textArea.selectionStart
        selectionEnd: textArea.selectionEnd
        Component.onCompleted: document.text = top.text
        onFontSizeChanged: {
            fontSizeSpinBox.valueGuard = false
            fontSizeSpinBox.value = document.fontSize
            fontSizeSpinBox.valueGuard = true
        }
        onFontFamilyChanged: {
            var index = Qt.fontFamilies().indexOf(document.fontFamily)
            if (index == -1) {
                fontFamilyComboBox.currentIndex = 2
                fontFamilyComboBox.special = true
            } else {
                fontFamilyComboBox.currentIndex = index
                fontFamilyComboBox.special = false
            }
        }
    }
    Cont.PrayerController {
        id: calPrayers
        onReadyChanged: {


                if (status == 200) {
                    //GET


                }
                if (status == 201) {
                    //POST
                    //cont1.getAll()
                    tim2.start()



                }
                if (status == 202) {
                    //PUT
                    tim2.start()

                }
                if (status == 203) {
                    //PUT
                    //cont1.getAll()
                     tim2.start()
                }
                if (status == 204) {
                    //DELETE
                   // cont1.getAll()
                     tim2.start()

                }
                if (status == 422) {

                    //error
                    //console.log(JSON.stringify(JSON.parse(jsn).errors))
                    entry.status = JSON.stringify(JSON.parse(jsn).errors)


                }
        }
    }
}

