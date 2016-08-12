import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.LocalStorage 2.0
import "JSCode.js" as JSCode
import "moment.js" as JSMoment
import QtQuick.Dialogs 1.1

Item {
    width: 400
    height: 300
    property alias textSecond: textSecond
    property alias textMinute: textMinute
    property alias textHour: textHour
    property alias textYear: textYear
    property alias textDay: textDay
    property alias textMonth: textMonth
    property alias btnSetTime: btnSetTime
    property alias lblCountdownTimer: lblCountdownTimer

    MessageDialog {
        id: messageDialog
        title: "Allert"
        text: "You have not provided a password."
        icon: StandardIcon.Warning;
        onAccepted: {
           messageDialog.visible = false
        }
        Component.onCompleted: visible = false
    }

    Label {
        id: lblCountdownTimer
        x: 64
        y: 199
        text: qsTr("00:00:00")
        font.pointSize: 59
    }
    function substr(string,substring){
        return string.indexOf(substring) > -1;
    }

    function timeDifference(){
        // use a constant date (e.g. 2000-01-01) and the desired time to initialize two dates
        var db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
        var Passcode
        var Year
        var Month
        var Day
        var Hour
        var Minute
        var Second
        var Unix
        var TimeStamp
        db.transaction(
            function(tx) {
                var SQL=""
                SQL+= "SELECT "
                SQL+= "passcode, "
                SQL+= "strftime('%s', time_stamp) as unix, "
                SQL+= "strftime('%Y', time_stamp) as year, "
                SQL+= "strftime('%m', time_stamp) as month, "
                SQL+= "strftime('%d', time_stamp) as day, "
                SQL+= "strftime('%H', time_stamp) as hour, "
                SQL+= "strftime('%M', time_stamp) as minute, "
                SQL+= "strftime('%S', time_stamp) as second, "
                SQL+= "time_stamp "
                SQL+= " FROM data_table;";
                var rs = tx.executeSql(SQL);


                for(var i = 0; i < rs.rows.length; i++) {
                    Passcode = rs.rows.item(i).passcode;
                    Year = rs.rows.item(i).year;
                    Month = rs.rows.item(i).month;
                    Day = rs.rows.item(i).day;
                    Hour = rs.rows.item(i).hour;
                    Minute = rs.rows.item(i).minute;
                    Second = rs.rows.item(i).second;
                    Unix = rs.rows.item(i).unix;
                    TimeStamp = rs.rows.item(i).time_stamp;
                }
            }
        )
        //ok, I refactored using moment.js but I am still getting the same problem,output(notice the difference is wrong):
        //qml: now:2016-01-21T21:24:33+09:00
        //qml: then:2016-01-21 21:40:19
        //qml: difference:-1:44:14
        //while with this data it does:
        //qml: now:2016-01-21T21:38:50+09:00
        //qml: then:2016-01-21 21:38:31
        //qml: difference:0:00:19
        var now  = JSMoment.moment().format();//"04/09/2013 15:00:00";
        var then = TimeStamp//"02/09/2013 14:20:30";
        console.log("now:"+now.toString());
        console.log("then:"+then.toString());
        //var ms = JSMoment.moment(now,"DD/MM/YYYY HH:mm:ss").diff(JSMoment.moment(then,"DD/MM/YYYY HH:mm:ss"));
        var ms = JSMoment.moment(then).diff(JSMoment.moment(now,"YYYY-MM-DD HH:mm:ss"));
        var d = JSMoment.moment.duration(ms);
        var s = Math.floor(d.asHours()) + JSMoment.moment.utc(ms).format(":mm:ss");
        console.log("difference:"+s.toString())
        //return s.toString()
        console.log("from:"+JSMoment.moment(then).fromNow())
        console.log("Passcode:"+Passcode)
        if(substr(JSMoment.moment(then).fromNow(),"ago")){
            return Passcode;
        }else{
            //return JSMoment.moment(then).fromNow();
            return s.toString();
        }

        /*
        //when set to Fri Jan 22 17:39:06 2016 GMT+0900 I get a 1 hour difference which is right when set to Fri Jan 22 16:50:05 2016 GMT+0900 when set to this I get a -1:48:00 difference current time is Thu Jan 21 16:40:47 2016 GMT+0900
        console.log(Year+Month-1+(parseInt(Day)+1)+Hour+Minute+Second)
        var date2 = new Date();//now
        //var date2 = new Date(Year,Month);
        var date1 = new Date(Year, Month-1, (parseInt(Day)+1), Hour, parseInt(Minute),Second); // YYYY,M 0 index,day of the month,hour military time, minute
        //var date1 = new Date(Unix*1000);
        console.log(date1.toString())
        //var date2 = new Date("2016-01-21T12:31:22");

        // the following is to handle cases where the times are on the opposite side of
        // midnight e.g. when you want to get the difference between 9:00 PM and 5:00 AM

        if (date2 < date1) {
            date2.setDate(date2.getDate()+1);
        }

        var diff = date2 - date1;

        // 28800000 milliseconds (8 hours)
        //You can then convert milliseconds to hour, minute and seconds like this:

        var msec = diff;
        var hh = Math.floor(msec / 1000 / 60 / 60);
        msec -= hh * 1000 * 60 * 60;
        var mm = Math.floor(msec / 1000 / 60);
        msec -= mm * 1000 * 60;
        var ss = Math.floor(msec / 1000);
        msec -= ss * 1000;
        return hh+":"+mm+":"+ss;
        */
    }

    Timer {
           interval: 1000; running: true; repeat: true
           onTriggered: lblCountdownTimer.text = timeDifference()
       }

    function setLabel(lblLabel,data_text) {
        lblLabel.text=data_text
    }

    Button {
        id: btnSetTime
        x: 127
        y: 19
        text: qsTr("Set Time")

        function findGreetings(textYear,textMonth,textDay,textHour,textMinute,textYear,textSecond) {
            var db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
            var r = "";
            db.transaction(
                function(tx) {
                    if(textPassword.text==""){
                        messageDialog.visible = true
                        return "No password provided";
                    }

                    // Create the database if it doesn't already exist
                    //tx.executeSql('DROP TABLE data_table');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS data_table(passcode TEXT, time_stamp DATETIME DEFAULT NULL)');

                    tx.executeSql("INSERT INTO data_table VALUES(?, ?)",
                                  [ textPassword.text,JSCode.padDateTime(textYear,textMonth,textDay,textHour,textMinute,textSecond)]);//YYYY-MM-DD HH:MM:SS

                    var rs = tx.executeSql("SELECT passcode,time_stamp as d FROM data_table ");

                    for(var i = 0; i < rs.rows.length; i++) {
                        r += rs.rows.item(i).passcode + ", " + rs.rows.item(i).d + "\n"
                        console.log("rs:"+rs.rows.item(i).passcode);
                    }
                    textPassword.text="";

                }
            )
            return r;
        }

        onClicked: setLabel(lblCountdownTimer, findGreetings(
                                textYear.text,textMonth.text,textDay.text,textHour.text,textMinute.text,textYear.text,textSecond.text))

    }

    TextField {
        id: textMonth
        x: 56
        y: 59
        width: 53
        height: 22
        placeholderText: qsTr("Month")
    }

    TextField {
        id: textDay
        x: 115
        y: 59
        width: 53
        height: 22
        placeholderText: qsTr("Day")
    }

    TextField {
        id: textYear
        x: 174
        y: 59
        width: 58
        height: 22
        placeholderText: qsTr("Year")
    }

    TextField {
        id: textHour
        x: 56
        y: 87
        width: 53
        height: 22
        placeholderText: qsTr("Hour")
    }

    TextField {
        id: textMinute
        x: 115
        y: 87
        width: 53
        height: 22
        placeholderText: qsTr("Minute")
    }

    TextField {
        id: textSecond
        x: 174
        y: 87
        width: 58
        height: 22
        placeholderText: qsTr("Second")
    }

    TextField {
        id: textPassword
        x: 56
        y: 133
        placeholderText: qsTr("Password")
    }
    Text {
        text: "?"
        anchors.horizontalCenter: parent.horizontalCenter


    }
}
