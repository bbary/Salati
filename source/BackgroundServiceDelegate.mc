using Toybox.Background;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
import Toybox.Application.Storage;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.
//
(:background)
class BackgroundServiceDelegate extends Sys.ServiceDelegate 
{
	function initialize() 
	{
		Sys.ServiceDelegate.initialize();
	}
	
    function onTemporalEvent() 
    {
    	try
    	{
			Utils.log("onTemporalEvent called -> awake salat widget");
			//Utils.log("getTemporalEventRegisteredTime = "+Background.getTemporalEventRegisteredTime());
			Background.requestApplicationWake("إن الصلاة كانت على المؤمنين كتابا موقوتا");
			//Background.requestApplicationWake("salat "+Storage.getValue("nextPrayerTime"));
			//Background.requestApplicationWake("salat ");
			//Background.exit("salat "+Storage.getValue("nextPrayerTime"));
			Background.exit(true);  // return true so the onBackgroundData could be called to updateview
		}
		catch(ex)
		{
			Utils.log("[onTemporalEvent][TRY_CATCH] error: " + ex.getErrorMessage());
			Background.exit(null);
		}		 
    }

}