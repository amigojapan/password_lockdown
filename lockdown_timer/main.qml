import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import "JSCode.js" as JSCode
//https://github.com/t0rbn/QtQuick-FileRW
ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Lockdown Timer")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            //MenuItem {
            //    text: qsTr("&Open")
            //    onTriggered: console.log("Open action triggered");
            //}
            MenuItem {
                text: qsTr("&Quit")
                onTriggered: Qt.quit();
            }
        }
    }

    function setText(lblCountdownTimer) {
        //lblCountdownTimer.text= JSCode.dbTest()
    }

    MainForm {
        textMonth.text: JSCode.Month()
        textDay.text: JSCode.DayOfMonth()
        textYear.text: JSCode.Year()
        textHour.text: JSCode.Hour()
        textMinute.text: JSCode.Minute()
        textSecond.text: JSCode.Second()
        anchors.fill: parent
        btnSetTime.onClicked: setText(lblCountdownTimer)
        //button1.onClicked: messageDialog.show(qsTr("Button 1 pressed"))
        //button2.onClicked: messageDialog.show(qsTr("Button 2 pressed"))
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }
}
