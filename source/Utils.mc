using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Lang;
using Toybox.System;

(:background)
module Utils {

    function getDateFromEpoch(epoch) {
        var today = Gregorian.info(new Time.Moment(epoch), Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$1$:$2$:$3$  $4$/$5$/$6$", 
            [today.hour.format("%02d"), today.min.format("%02d"),today.sec.format("%02d"), 
            today.day, today.month,today.year]);
        return dateString;
    }

    function getDate(epoch) {
        var today = Gregorian.info(new Time.Moment(epoch), Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$1$/$2$/$3$", 
            [today.day, today.month,today.year]);
        return dateString;
    }   

    function getTime() {
        var clockTime = System.getClockTime();
        var hours = clockTime.hour.format("%02d");
        var mins = clockTime.min.format("%02d");
        return hours+""+mins;
    }  

    function getTodayDate() {
        return getDateFromEpoch(Time.now().value()).substring(0, 8); 
    }  

    function log(msg){
        System.println(getTodayDate()+" - "+msg);
    }

    function getEpochFitDate(Fitepoch){
        return getDateFromEpoch(Fitepoch+631065600); ////FIT Epoch time is 20y behind unix 
    }

    function getLastSundayEpoch(){
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        return Time.today().value()-((today.day_of_week-1)*24*3600);
        
    }

    function round(float){
        if(float-float.toNumber()>0.5){
            return float.toNumber()+1;
        }
        else{
            return float.toNumber();
        }
    }
}