import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Application.Storage;
using Toybox.System;
using Toybox.Time;
import Toybox.Application.Properties;


class SalatView extends WatchUi.View {

    var screenSize;
    var pas;
    var timings;

    //! Constructor
    public function initialize() {
        View.initialize();
        screenSize = System.getDeviceSettings().screenWidth;
        pas = screenSize/9;
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        // call API one time a day
        if(Storage.getValue("today") == null or Storage.getValue("today") != Time.today().value()){
            System.println("calling adhan API . Storage.getValue(today) = "+Storage.getValue("today"));
            var r = new Req();
            r.getPrayerTimes();
            WatchUi.requestUpdate();
        }
    }
        
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {  
    }

    // Update the view
    function onUpdate(dc) {
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        timings = Storage.getValue("timings"); 

        if(timings != null){
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);    

            // calculate hijri date with adjustment from properties
            var adjutHijri = Properties.getValue("adjust_hijri");
            if( adjutHijri.equals("")){
               adjutHijri = 0;     
            }
            
            var hijriDay = Storage.getValue("hijri_day").toNumber() + adjutHijri.toNumber();
            var hijriMonth = Storage.getValue("hijri_month");
            //var hijriDay = 25;
            //var hijriMonth = "rabi1 alawal";
            
            dc.drawText(175, 1*pas-2, Graphics.FONT_MEDIUM, hijriMonth, Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(180, 1*pas-1, Graphics.FONT_MEDIUM, hijriDay, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

            // get fixed prayer times from properties
            var ichaTime = Properties.getValue("icha_time");
            if(!ichaTime.equals("")){
			    //System.println(" ichaTime propertie is null");
			    timings["Isha"] = ichaTime;
		    }

            var duhrTime = Properties.getValue("duhr_time");
            if(!duhrTime.equals("")){
			    //System.println(" duhrTime propertie is null");
			    timings["Dhuhr"] = duhrTime;
		    }

            var asrTime = Properties.getValue("asr_time");
            if(!asrTime.equals("")){
			    //System.println(" asrTime propertie is null");
			     timings["Asr"] = asrTime;
		    }

            var timeNow = Lang.format("$1$:$2$", [System.getClockTime().hour.format("%02d"), System.getClockTime().min.format("%02d")]);
            //timeNow = "01:59";

            
            var nextPrayer = calculateNextPrayer(timeNow, timings);
            //System.println(" called calculateNextPrayer nextPrayer = "+nextPrayer);

            // persist next prayer time so it could be used by background service to start alert
            Storage.setValue("nextPrayerTime", timings[nextPrayer]);
            Storage.setValue("nextPrayer", nextPrayer);

            // display all prayers    
            
            if(nextPrayer.equals("Fajr")){
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
            }else{
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);     
            }
            dc.drawText(70, 2*pas+2, Graphics.FONT_TINY, "الفجر      "+timings["Fajr"],Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
            if(nextPrayer.equals("Sunrise")){
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
            }else{
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);     
            }
            dc.drawText(70, 3*pas+2, Graphics.FONT_TINY, "الشروق   "+timings["Sunrise"],Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
             if(nextPrayer.equals("Dhuhr")){
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
            }else{
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);     
            }
            dc.drawText(70, 4*pas+2, Graphics.FONT_TINY, "الظهر      "+timings["Dhuhr"],Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
            if(nextPrayer.equals("Asr")){
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
            }else{
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);     
            }
            dc.drawText(70, 5*pas+2, Graphics.FONT_TINY, "العصر     "+timings["Asr"],Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
            if(nextPrayer.equals("Maghrib")){
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
            }else{
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);     
            }
            dc.drawText(70, 6*pas+2, Graphics.FONT_TINY, "المغرب   "+timings["Maghrib"],Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
            if(nextPrayer.equals("Isha")){
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
            }else{
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);     
            }
            dc.drawText(70, 7*pas+2, Graphics.FONT_TINY, "العشاء    "+timings["Isha"],Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
            if(nextPrayer.equals("Lastthird")){
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
            }else{
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);     
            }
            dc.drawText(70, 8*pas+2, Graphics.FONT_TINY, "النزول    "+timings["Lastthird"],Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);

            var remainingTime;
            if(nextPrayer.equals("Fajr") and timeNow.substring(0, 2).toNumber()>15){
                remainingTime = timeDiff(timeNow,add24(timings[nextPrayer]));
            }else{
                remainingTime = timeDiff(timeNow,timings[nextPrayer]);
            }
            var remaining_hours = remainingTime.abs()/60;
            var remaining_mins = remainingTime.abs()%60;
            // draw time remaining
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(screenSize/8, screenSize/2-22, Graphics.FONT_NUMBER_MEDIUM, remaining_hours.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(screenSize/8, screenSize/2+22, Graphics.FONT_NUMBER_MEDIUM, remaining_mins.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

            // draw time now
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(screenSize*7/8-5, screenSize/2-22, Graphics.FONT_NUMBER_MEDIUM, System.getClockTime().hour.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(screenSize*7/8-5, screenSize/2+22, Graphics.FONT_NUMBER_MEDIUM, System.getClockTime().min.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
        else{
            dc.drawText(140, 140, Graphics.FONT_LARGE, "Calling API",Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
        WatchUi.requestUpdate();
    }

    function calculateNextPrayer(timeNow, timings){
        if(timeDiff(timeNow, timings["Fajr"])<0){
            return "Fajr";
        } else if(timeDiff(timeNow, timings["Sunrise"])<0){
            return "Sunrise";
        } else if(timeDiff(timeNow, timings["Dhuhr"])<0){
            return "Dhuhr";
        } else if(timeDiff(timeNow, timings["Asr"])<0){
            return "Asr";
        } else if(timeDiff(timeNow, timings["Maghrib"])<0){
            return "Maghrib";
        } else if(timeDiff(timeNow, timings["Isha"])<0){
            return "Isha";
        } else{
            return "Fajr";
        }
    }
    function timeDiff(time1, time2){

        var time1_hours=time1.substring(0, 2).toNumber();
        var time1_min=time1.substring(3, 5).toNumber();
        var time1_total_min = time1_hours*60 +  time1_min;

        var time2_hours=time2.substring(0, 2).toNumber();
        var time2_min=time2.substring(3, 5).toNumber();
        var time2_total_min = time2_hours*60 +  time2_min;

        return time1_total_min-time2_total_min;

    }

    function add24(FajrTime){
        var time_hours=FajrTime.substring(0, 2).toNumber()+24;
        var time_min=FajrTime.substring(3, 5);
        return time_hours.toString()+":"+time_min;
    }

}
