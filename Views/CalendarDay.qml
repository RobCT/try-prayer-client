import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import org.qtproject.tryprayer 1.0
import "../controllers" as Cont
import "../scripts/moment.js" as D
import "../components" as Comp
import "." as L

Rectangle {
    id:top
    width: Screen.width
    height: Screen.height
    color: "lightsteelblue"
    property var  selectedDate
    property var prayertext
    property int wayup: Screen.orientation
    onWayupChanged: {
        console.log("change way up",width, height)
    }

    function stringUp() {
        var jsn

             jsn = {"prayer":{"title": "", "prayerdate": calendar.selectedDate, "prayer": textArea.text,  "user_id": entry.signin.id}}

        return JSON.stringify((jsn))

    }
    onVisibleChanged: {
        if (visible) tim2.start()

    }

    Timer {
        id: tim2
          interval: 1; running: false; repeat: false
            onTriggered: {
                if (!entry.busy)
                calPrayers.getCalendar(calendar.selectedDate.year(),calendar.selectedDate.month()+1,calendar.selectedDate.date(),"day")
                else restart()

            }
    }
    Timer {
        id: tim3
          interval: 600000; running: true; repeat: true
            onTriggered: {

                calPrayers.getCalendar(calendar.selectedDate.year(),calendar.selectedDate.month()+1,calendar.selectedDate.date(),"day")


            }
    }

    Rectangle {
        id: topRect
        width: parent.width
        height: parent.height/8
        color: "linen"
        property int iseeyou
        Rectangle {
            id: hidden
            width: parent.width/12
            height: parent.height
            color: "transparent"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    topRect.iseeyou += 1
                    if (topRect.iseeyou == 1) hid.start()
                    if (topRect.iseeyou == 5  ) {
                        md1.open()

                    }

                }
            }
        }
        MessageDialog {
            id: md1
            text: "Your password is: " + entry.signin.currentPassword
        }
        Timer {
            id: hid
                interval: 10000; running: false; repeat: false
            onTriggered: {
                topRect.iseeyou = 0
            }
        }

        Comp.DateTumblerInput {
            id: banner
            anchors.left: parent.left

            anchors.verticalCenter: parent.verticalCenter

            width: parent.width/3
            height: parent.height
            anchors.leftMargin: width/4
            showType: "days"
            //date: D.moment(new Date)
            onReturnDateChanged: {
                //console.log("isitme",returnDate)
                calendar.selectedDate = returnDate
            }
            Component.onCompleted: {
                banner.date = D.moment(calendar.selectedDate)
                //console.log("seldate",calendar.selectedDate)
            }
        }
        Rectangle {
            color: "orange"
            radius: 15
            anchors.right: parent.right
            anchors.rightMargin: width/4
            width: parent.width/3
            height: parent.height
            Rectangle {
                color: "linen"
                radius: 10
                anchors.fill: parent
                anchors.margins: parent.height/10
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: parent.width/10
                    textFormat: Text.AlignHCenter
                    text: "Add a prayer"
                    color: "royalblue"


                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        entry.push({item: prayerEdit, properties: {selectedDate: calendar.selectedDate, text: "", create: true}})
             /*           if (Qt.platform.os != "android") {
                        prayerEditor.create = true
                        prayerEditor.visible = true
                        }*/
                    }
                }
            }

        }



    }

    GridView {
        id:calendar
        anchors.top: topRect.bottom
        anchors.topMargin: parent.height/40
        model: calPrayers.model3
        property bool busy: entry.busy
        delegate: calDelegate
        width: parent.width
        height: parent.height*7/8
        cellWidth: width
        cellHeight: height
        property var selectedDate
        property var currentDate
        property var currentPrayers
        property var currentSheets
        onSelectedDateChanged:  {

            calPrayers.getCalendar(selectedDate.year(),selectedDate.month()+1,selectedDate.date(),"day")
            banner.date = selectedDate//.format("MMM YYYY")
        }



        Timer {
            id: tim1
              interval: 1; running: false; repeat: false
                onTriggered: {
                    if (!entry.busy) {
                        calendar.selectedDate = top.selectedDate
                        calendar.currentDate = selectedDate
                        calPrayers.getCalendar(selectedDate.year(),selectedDate.month()+1,selectedDate.date(),"day")
                    }
                    else restart()
            }
        }

        Component.onCompleted: {

            tim1.start()

        }

    }

    Component {
            id: calDelegate
            Rectangle {
                id: wrapper
                width: calendar.cellWidth
                height: calendar.cellHeight
                border.width: 1
                border.color: "grey"
                color:  "cyan"
                property var ev: prayers
                MouseArea {
                    id:clicker
                    width: parent.width
                    height: parent.height
                    onClicked: {


                        calendar.currentIndex = index
                        calendar.currentDate = date
                        calendar.currentPrayers = prayers
                        entry.push({item: prayerEdit, properties: {selectedDate: calendar.selectedDate, text: "", create: true}})

 /*                       if (Qt.platform.os != "android") {
                        prayerEditor.text = "some text"
                        prayerEditor.create = true
                        prayerEditor.visible = true
                        }*/
                    }

                }
                onEvChanged: {
                }



                Text {
                    id: calInfo
                    font.pixelSize: parent.height/10

                    text: D.moment(date).format("ddd Do")
                    color: wrapper.GridView.isCurrentItem ? "red" : "black"
                    MouseArea {
                        width: parent.width
                        height: parent.height
                        onClicked:  {

                            //prayerEdit.text = "SOME TEXT"
                           // var component = Qt.createComponent("PrayerEditor.qml");
                          //          var win = component.createObject(top);
                           //         win.show();
                            entry.push({item: prayerEdit, properties: {selectedDate: calendar.selectedDate, text: "", create: true}})

/*                            if (Qt.platform.os != "android") {
                            prayerEditor.text = "some text"
                            prayerEditor.create = true
                            prayerEditor.visible = true
                            }*/

//

                        }
                    }
                }
                PinchArea {
                    width: parent.width
                    height: parent.height

                    property real initialWidth
                    property real initialHeight
                    property real initialScale
                    //![0]
                    onPinchStarted: {

                        initialScale = pinch.scale
                        prayerList.zoom = initialScale

                    }

                    onPinchUpdated: {
                        // adjust content pos due to drag
                        //flick.contentX += pinch.previousCenter.x - pinch.center.x
                       // flick.contentY += pinch.previousCenter.y - pinch.center.y

                        // resize content
                        //flick.resizeContent(initialWidth * pinch.scale, initialHeight * pinch.scale, pinch.center)
                        prayerList.zoom = pinch.scale > 5 ? 5 : pinch.scale
                    }

                    onPinchFinished: {
                        // Move its content within bounds.
                        //flick.returnToBounds()
                    }
                ListView {
                     id: prayerList
                     y: parent.y + calInfo.height
                     width: parent.width
                     height: parent.height
                     model: prayers
                     property real zoom: 1.5
                     spacing: zoom*height/15
                     //highlight: highlight
                     highlightRangeMode: ListView.StrictlyEnforceRange
                     preferredHighlightBegin: y //+(height - inRect.height/3) /2
                     preferredHighlightEnd: y + height// -(height - inRect.height/3) /2
                     property color highlighted: wrapper.color
                     property var rowheight: prayers.count ? height/(prayers.count) : 30
                     //anchors.top: calInfo.bottom
                     //anchors.bottom: parent.bottom
                     delegate: prayerDelegate
                 }
            }
                Component {
                    id: prayerDelegate

                    Item {
                        id: del1
                        width: prayerList.width
                        height: prCol.implicitHeight
                        transform: Scale { origin.x: width/2; origin.y: 0; xScale: prayerList.zoom; yScale: prayerList.zoom}
                        Column {
                            id: prCol
                            anchors.horizontalCenter: parent.horizontalCenter
                            //width:parent.width
                            //height: prect1.height + prect2.height
                        Rectangle {
                            id: prect1
                            width: prect2.width
                            height: parent.height/15
                            color: prayerList.highlighted
                            border.width: 1
                            border.color: "grey"
                        }
                        Rectangle {
                            id: prect2
                            width: prayerText.implicitWidth
                            height: prayerText.implicitHeight
                            color: "lightyellow"
                            border.color: "blue"
                            border.width: 0.5

                            Text {
                                id: prayerText
                            width: parent.width ;//height: parent.height;
                            wrapMode: Text.WordWrap
                            textFormat: Text.RichText
                            text: prayer + "\n\n by " + user.username
                        }


                        MouseArea {
                            width:parent.width
                            height: parent.height
                            onClicked: {
                                entry.push({item: prayerEdit, properties: {selectedDate: calendar.selectedDate, text: prayer, create: false, pid: id}})

/*                                if (Qt.platform.os != "android") {

                                prayerEditor.pid = id
                                prayerEditor.text = prayer
                                prayerEditor.create = false
                                prayerEditor.visible = true
                                }*/


                            }
                            onPressAndHold: {
                                //entry.push({item: sheet, properties: {index: id}})
                            }

                        }

                        }
                        Rectangle {
                            width:parent.width
                            height: parent.height/8
                            color: prayerList.highlighted
                            border.width: 1
                            border.color: "grey"
                        }
                        }

                        }
                    }





        }

    }
    ListModel {
        id: caldata

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
    Component {
        id: editev
        L.EditPrayer {


    }
    }
    Component {
        id: prayerEdit
        L.PrayerEditor {


    }
    }

    Component {
        id: prayerRect
        Rectangle {
            property alias text: evTitle.text

            Text {
                id: evTitle
            }
        }
    }



    property var prayerEditor: ApplicationWindow {
        id: petop
        visible: false
        modality: Qt.WindowModal
        width: parent.width
        height:parent.height
        property var text
        property int pid
        property bool create: false
        minimumWidth: 400
        minimumHeight: 300
        onVisibleChanged: {
            if (visible) {
                if (create) document.text = ""
                else document.text = text

            }

        }



        MessageDialog {
            title: "About Text"
            text: "This is a basic text editor \nwritten with Qt Quick Controls"
            icon: StandardIcon.Information
        }

        Action {
            id: cutAction
            text: "Cut"
            shortcut: "ctrl+x"
            iconSource: "images/editcut.png"
            iconName: "edit-cut"
            onTriggered: textArea.cut()
        }

        Action {
            id: copyAction
            text: "Copy"
            shortcut: "Ctrl+C"
            iconSource: "images/editcopy.png"
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
            iconSource: "images/textleft.png"
            iconName: "format-justify-left"
            shortcut: "ctrl+l"
            onTriggered: document.alignment = Qt.AlignLeft
            checkable: true
            checked: document.alignment == Qt.AlignLeft
        }
        Action {
            id: alignCenterAction
            text: "C&enter"
            iconSource: "images/textcenter.png"
            iconName: "format-justify-center"
            onTriggered: document.alignment = Qt.AlignHCenter
            checkable: true
            checked: document.alignment == Qt.AlignHCenter
        }
        Action {
            id: alignRightAction
            text: "&Right"
            iconSource: "images/textright.png"
            iconName: "format-justify-right"
            onTriggered: document.alignment = Qt.AlignRight
            checkable: true
            checked: document.alignment == Qt.AlignRight
        }
        Action {
            id: alignJustifyAction
            text: "&Justify"
            iconSource: "images/textjustify.png"
            iconName: "format-justify-fill"
            onTriggered: document.alignment = Qt.AlignJustify
            checkable: true
            checked: document.alignment == Qt.AlignJustify
        }

        Action {
            id: boldAction
            text: "&Bold"
            iconSource: "images/textbold.png"
            iconName: "format-text-bold"
            onTriggered: document.bold = !document.bold
            checkable: true
            checked: document.bold
        }

        Action {
            id: italicAction
            text: "&Italic"
            iconSource: "images/textitalic.png"
            iconName: "format-text-italic"
            onTriggered: document.italic = !document.italic
            checkable: true
            checked: document.italic
        }
        Action {
            id: underlineAction
            text: "&Underline"
            iconSource: "images/textunder.png"
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
            iconName: "prayer-save"
            text: "Save"
            onTriggered: {
               if (petop.create) calPrayers.newPrayer(stringUp())
               else calPrayers.updatePrayer(stringUp(), petop.pid)
               petop.visible = false

            }
        }

        menuBar: MenuBar {
            Menu {
                title: "&File"
                MenuItem { action: savePrayer }
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

        toolBar: ToolBar {
            id: mainToolBar
            width: parent.width
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

            RowLayout {
                anchors.fill: parent
                ComboBox {
                    id: fontFamilyComboBox
                    implicitWidth: 150
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
                    activeFocusOnPress: false
                    implicitWidth: 50
                    value: 0
                    property bool valueGuard: true
                    onValueChanged: if (valueGuard) document.fontSize = value
                }
                Item { Layout.fillWidth: true }
            }
        }

        TextArea {
            Accessible.name: "document"
            id: textArea
            frameVisible: false
            width: parent.width
            anchors.top: secondaryToolBar.bottom
            anchors.bottom: parent.bottom
            baseUrl: "qrc:/"
            text: document.text
            textFormat: Qt.RichText
            Component.onCompleted: forceActiveFocus()
        }

        DocumentHandler {
            id: document
            target: textArea
            cursorPosition: textArea.cursorPosition
            selectionStart: textArea.selectionStart
            selectionEnd: textArea.selectionEnd
            //Component.onCompleted: document.text = petop.text
            onFontSizeChanged: {
                fontSizeSpinBox.valueGuard = false
                fontSizeSpinBox.value = document.fontSize
                fontSizeSpinBox.valueGuard = true
            }
            onFontFamilyChanged: {
                var index = Qt.fontFamilies().indexOf(document.fontFamily)
                if (index == -1) {
                    fontFamilyComboBox.currentIndex = 0
                    fontFamilyComboBox.special = true
                } else {
                    fontFamilyComboBox.currentIndex = index
                    fontFamilyComboBox.special = false
                }
            }
        }
    }
}

