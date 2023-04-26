# Event-App
Implementation of events happening on a specific location.

#### Following things are implemented in this flutter test application.

* Dark & Light theme supported
* Used the bloc architecture for state-management.
* Favourite for lsiting & event detail page has been done.
* Did not used any kind of pagination library implement my own strucutre to get new data or show progress or show done view in case no event remain.
* For event detail simply show the image, name, date, & along with the bottom space I have added the webview for the event home page.
* Handled the no-interet connection scenarion as well.
   1. When there is no events on home I showed the no-internet-connection custom widget and with try again functionality.
   2. Second when the pagination request is on-going and an execption occurs or maybe user device is not connected to internet.In that case we 
      check if the user device has the internet then try again automatically if not I register the listener and for network connecttivity. When 
      the device has network again we hide the bottom network error text and again call the paginated event items.


#### Flutter Environment
Version: 3.7.10
Dart: 2.19.6

#### Steps To Run This Project

* Clone the project and navigate to directory
* Then run the `flutter pub get` first to get all the dependencies
* Now to run the application connect a device and then `flutter run` command to run the application. 
      
