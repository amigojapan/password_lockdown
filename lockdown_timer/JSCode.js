function Month() {
    var date1 = new Date();
    return date1.getMonth()+1;
}
function DayOfMonth() {
    var date1 = new Date();
    return date1.getDate();
}
function Year() {
    var date1 = new Date();
    return date1.getUTCFullYear();
}
function Hour() {
    var date1 = new Date();
    return date1.getHours();
}
function Minute() {
    var date1 = new Date();
    return date1.getMinutes();
}
function Second() {
    var date1 = new Date();
    return date1.getSeconds();
}
function findGreetings(textYear,textMonth,textDay,textHour,textMinute,textYear,textSecond) {
    var db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
    var r = ""
    db.transaction(
        function(tx) {
            // Create the database if it doesn't already exist
            tx.executeSql('DROP TABLE data_table');
            tx.executeSql('CREATE TABLE IF NOT EXISTS data_table(salutation TEXT, time_stamp DATETIME DEFAULT NULL)');

            tx.executeSql("INSERT INTO data_table VALUES(?, ?)",
                          [ 'hello',textYear+'-'+textMonth+'-'+textDay+' '+textHour+':'+textMinute+':'+textSecond]);//YYYY-MM-DD HH:MM:SS

            var rs = tx.executeSql("SELECT salutation,time_stamp as d FROM data_table ");

            for(var i = 0; i < rs.rows.length; i++) {
                r += rs.rows.item(i).salutation + ", " + rs.rows.item(i).d + "\n"
            }
        }
    )
    return r;
}
function padDateTime(Year,Month,Day,Hour,Minute,Second) {
    return pad(Year,4)+"-"+pad(Month,2)+"-"+pad(Day,2)+" "+pad(Hour,2)+":"+pad(Minute,2)+":"+pad(Second,2)
}

function pad(n, width, z) {
  z = z || '0';
  n = n + '';
  return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
}
//onClicked: setLabel(lblCountdownTimer, findGreetings(
 //                       textYear.text,textMonth.text,textDay.text,textHour.text,textMinute.text,textYear.text,textSecond.text))
