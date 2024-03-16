using Toybox.System;
using Toybox.Communications as Comm;
using Toybox.Application.Storage;
using Toybox.Time;
import Toybox.Application.Properties;

class Req { 
	
    public function getPrayerTimes(){

		var url = Properties.getValue("api_url");
        if(url.equals("")){
			System.println("api url is null");
			url = "https://api.aladhan.com/timingsByAddress?address=Paris&method=99&methodSettings=12,4min,80min&tune=0,-4,1,6,2,0,1,0,0";
		}

        var options = {
			:method => Comm.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Comm.makeWebRequest(
            url,
            {},
            options,
            method(:onReceive)
        );  
    }

    function onReceive(responseCode, data) {
		try
		{
			if (responseCode == 200)
			{
				System.println("responseCode == 200");
				Storage.setValue("timings", data["data"]["timings"]);
				Storage.setValue("hijri_day", data["data"]["date"]["hijri"]["day"]);
				
				switch(data["data"]["date"]["hijri"]["month"]["number"]){
					case 1: 
						Storage.setValue("hijri_month", "محرم");
						break;
					case 2:
						Storage.setValue("hijri_month", "صفر");
						break;
					case 3:
						Storage.setValue("hijri_month", "ربيع الأول");
						break;
					case 4:
						Storage.setValue("hijri_month", "ربيع الثاني");
						break;		
					case 5:
						Storage.setValue("hijri_month", "جمادى الأولى");
						break;
					case 6:
						Storage.setValue("hijri_month", "جمادى الآخرة");
						break;
					case 7:
						Storage.setValue("hijri_month", "رجب");
						break;
					case 8:
						Storage.setValue("hijri_month", "شعبان");
						break;	
					case 9:
						Storage.setValue("hijri_month", "رمضان");
						break;
					case 10:
						Storage.setValue("hijri_month", "شوال");
						break;
					case 11:
						Storage.setValue("hijri_month", "ذو القعدة");
						break;
					case 12:
						Storage.setValue("hijri_month", "ذو الحجة");
						break;																							
				}
				
				// used to assure that api is called one time a day
				Storage.setValue("today", Time.today().value());

			}
			else
			{
				System.println("[getPrayerTimes][onReceive] "+responseCode);
			}

		}
		catch(ex)
		{
			System.println("[getPrayerTimes][onReceive][TRY CATCH] get data error : " + ex.getErrorMessage());
		}
   	}

}