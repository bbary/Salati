import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.Time;
using Toybox.System;
using Toybox.Time.Gregorian;

(:background)
class Salat extends Application.AppBase {

    function initialize() {
        AppBase.initialize();

    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }


        // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        Utils.log("getInitialView");
        InitBackgroundEvents();
        return [ new SalatView() ] as Array<Views or InputDelegates>;
    }


        // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    
    function onBackgroundData(d) {
        Utils.log("onBackgroundData = "+d);
        WatchUi.requestUpdate();
    }    

    function getServiceDelegate(){

        return [new BackgroundServiceDelegate()];
    }
  /*  
    function InitBackgroundEvents()
    { 	
    	var INTERVAL = new Toybox.Time.Duration(5 * 60);
		var lastTime = Background.getLastTemporalEventTime();
        if (lastTime != null) {
            Utils.log("lastTime "+Utils.getDateFromEpoch(lastTime.value()));
    		var nextTime = lastTime.add(INTERVAL);
            Utils.log("nextTime "+Utils.getDateFromEpoch(nextTime.value()));
            try{
    		    Background.registerForTemporalEvent(INTERVAL);
            }
            catch (e instanceof Background.InvalidBackgroundTimeException) {
                Utils.log("[registerForTemporalEvent] [TRY_CATCH] error: " + e.getErrorMessage());
                Utils.log("error1 "+e.mMessage);
                Utils.log("error2 "+e.mErrorCode);
                Utils.log("error3 "+e.mPcStack);
            }
		} 
		else {
            try{
    		    Background.registerForTemporalEvent(Time.now());
            }
            catch (e instanceof Background.InvalidBackgroundTimeException) {
                Utils.log("[now][registerForTemporalEvent] [TRY_CATCH] error: " + e.getErrorMessage());
                Utils.log("error1 "+e.mMessage);
                Utils.log("error2 "+e.mErrorCode);
                Utils.log("error3 "+e.mPcStack);
            }
    		

		}
    }

    function InitBackgroundEvents()
    {
		var lastTime = Background.getLastTemporalEventTime();
		if (lastTime != null) {
            System.println("lastTime "+Utils.getDateFromEpoch(lastTime.value()));
    		var nextTime = getNextTimePrayer();
            System.println("nextTime "+Utils.getDateFromEpoch(nextTime.value()));
    		Background.registerForTemporalEvent(nextTime);
            //Background.registerForTemporalEvent(Time.now().add(new Duration(60)));
		} 
		else {
    		Background.registerForTemporalEvent(Time.now());
		}
    }
*/
    function InitBackgroundEvents()
    {
        var nextCall;
        var nextPrayerTime = Storage.getValue("nextPrayerTime");
        if(nextPrayerTime == null){
            nextCall = Time.now();
        }   
        else{
            nextCall = stringToMoment(nextPrayerTime) as Time.Moment;
        }
        Utils.log("nextCall = "+nextCall.value());
    	Background.registerForTemporalEvent(nextCall);
        WatchUi.requestUpdate();
    }
}

function getApp() as Salat {
    return Application.getApp() as Salat;
}
/*
function getNextTimePrayer(){
    var nextPrayerTime = Storage.getValue("nextPrayerTime");
    if(nextPrayerTime == null){
        return Time.now();
    }   
    return stringToMoment(nextPrayerTime);
}
*/

// dateStr format HH:mm
// addDay boolean : true to ask to add a day
function stringToMoment(dateStr){
    var clockTime = System.getClockTime();
    //var timeNow = Lang.format("$1$:$2$", [System.getClockTime().hour.format("%02d"), System.getClockTime().min.format("%02d")]);
    var dateStr_hours = dateStr.substring(0, 2).toNumber();
    var dateStr_min = dateStr.substring(3, 5).toNumber();
    var options = {
        :year   => Time.Gregorian.Info.year,
        :month  => Time.Gregorian.Info.month,
        :day    => Time.Gregorian.Info.day,
        :hour   => dateStr_hours,
        :minute => dateStr_min
    };

    // convert UTC time to france time
    var moment = Gregorian.moment(options).subtract(new Time.Duration(Gregorian.SECONDS_PER_HOUR));

    // check if nextPrayer is Fajr, in this case add a day
    //System.println("## next prayer is "+Storage.getValue("nextPrayer")+"###");
    var nextP = Storage.getValue("nextPrayer");
    if(nextP.equals("Fajr") and System.getClockTime().hour>8){
        //System.println("adding 24h");
        moment = moment.add(new Time.Duration(Gregorian.SECONDS_PER_DAY));
    }
    return moment;
}