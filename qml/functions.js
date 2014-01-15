.pragma library

function isSameDay(time) { // predpokladany @parametr time je timestamp odpovidajici dnu zacatku v 00:00:00
    var t2 = new Date().getTime()/1000;

    return ( (time-t2)  < 0); // je to ten den
}

function formatCountdown(time) {
    var t1 = time
    var t2 = new Date().getTime()/1000;

    var seconds = Math.abs(Math.floor(t1-t2));

    if (isNaN(seconds)) {
        return ""
    }

    var days = Math.floor(seconds / 86400);
    seconds = seconds - (days * 86400)

    var hours = Math.floor(seconds / 3600);
    seconds = seconds - (hours * 3600)

    var minutes = Math.floor(seconds / 60);

    seconds = Math.floor(seconds - (minutes * 60))


    return qsTr("%1 days\n%2:%3:%4").arg(days).arg(pad2(hours)).arg(pad2(minutes)).arg(pad2(seconds))
}

function pad2(i) {
    if (i > 9) {
        return i
    }
    return "0"+i
}

function dayOfWeek(i) {
    var w = ["Sunday", "Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    return w[i];
}

function format_time(unix_timestamp) {
var date = new Date(unix_timestamp*1000);
    var hours = date.getHours();
    var minutes = date.getMinutes();
    return pad2(hours)+":"+pad2(minutes)
}
