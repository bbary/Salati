# Salati
Prayer times

Garmin watch app Prayer times with  hijri date in arabic.

I used Aladhan.com API to get prayers time each day, you need to have internet (bleutooth connexion to your phone, or wifi) to work. 

https://aladhan.com/prayer-times-api

I made it for Fenix 6X pro (280px), if your watch is smaller, the display may be different or may go outside the screen. 

The code source is on github, feel free to download it and change it to adapt it to your watch.

At first use, the watch app will display a message 'calling API'. You need to quit and restart the app, it will work inshallah.

Notifications are not working all time, it depends on your watch.

Read this explanation from Travis.ConnectIQ to understand why it may not work well on garmin
watches.

The background process will not run for several reasons.
- There is currently another running background process
- There is currently a pending app launch
- There is not sufficient memory available to load the background process
On all current devices, a watch-app is given all of the memory available, so if a watch-app is currently running, the background process cannot be started. For other app types, you have to do some arithmetic to find out what the total memory in use actually is. The compiler.json files in %APPDATA%\Garmin\ConnectIQ\Devices list the memory limits for the various app types. You can use this to tell if the system is too low on memory to run.

If your background process cannot run for some reason, it *should* run as soon as conditions permit. At least that is how it is intended to work.

The easiest way to test whether it is an issue with available memory is to uninstall all ConnectIQ apps except the one you want to test. If the background process doesn't run in a reasonable amount of time, then it is not likely to be any of the reasons mentioned above.
