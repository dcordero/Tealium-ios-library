Tealium iOS Library - Version 2.2
==================================

This library framework provides Tealium customers the means to tag their native iOS applications for the purpose of leveraging the vendor-neutral tag management platform offered by Tealium.  

This framework provides for:
- Analytics integration via the Tealium platform
- automatic view controller tracking
- automatic object and event tracking (see list of autotrackable objects below)
- automatic video player tracking
- automatic lifecycle tracking
- video milestone tracking
- custom action tracking
- intelligent network-sensitive & power-save caching
- simple to use messages, including singleton or dependency-injection-friendly instances.
- simple setup and remote configuration
- implemented with the user in mind. All tracking calls are asynchronous as to not interfere or degrade the user experience. 

Known limitations of current build:
- Limited autotracking support for storyboards
- Tealium Reference Ids are not guaranteed for objects created in storyboards
- Buttons within UIToolBars not guaranteed to be auto tracked


These instructions presume you have valid accounts with both Tealium and the analytic services you will be mapping data to.

Implementation is a three part process:
1. Download and implement the library into your project
2. Configure your Tealium IQ
3. Optionally enable the iOS Library Manager Extension in IQ


Table of Repo Contents
----------------------
- **TealiumiOSLibrary** folder contains all files necessary to run the Tealium iOS Library in your app and consists of the following:
  - Resources folder: contains graphic and interface builder files that should not be edited
  - TealiumiOSLibrary.framework: contains the actual library and header file (which can be edited)
- **TealiumiOSSampleApps** folder contains ARC and nonARC sample apps for reference or to start a project from.  Note: The TealiumiOSLibrary folder may need to be reimported to those projects to test/use
- **.gitignore** file is an optional git file that can ignored
- **README.md** file is this document file


Requirements
--------------------
You will need the following items:

- An active Tealium IQ Account
- Your Tealium Account Id (it will likely be your company name)
- The Tealium Profile name to be associated with the app (your account may have several profiles, ideally one of them is dedicated to your iOS app)
- The Tealium environment to use:
  - prod
  - qa
  - dev
- XCode (4.5+ recommended)
- Apple Developer license (for testing on a device and for release)
- Minimum iOS version deployment of 5.0 or higher


New Installation
----------------
Installing the TealiumiOSLibrary into your app requires the following steps:

  1. Add the following frameworks to your project:
      - AVFoundation.framework          (for tracking AVPlayer video objects)
      - CoreMotion.framework            (used by Mobile Companion)
      - CoreMedia.framework             (for tracking MPMoviePlayer video objects)
      - CoreTelephony.framework         (for tracking carrier data)
      - MediaPlayer.framework           (for tracking video)
      - SystemConfiguration.framework   (for connectivity checks)
      <p></p>
  2. Copy the **TealiumiOSLibrary** folder into your project's source tree. The folder contains the following subfolders:
      - Resources                       (contains graphic files for Mobile Companion)
      - TealiumiOSLibrary.framework     (contains the TealiumiOSTagger.h header file and the actual library)
      <p></p>
  3. Add the TealiumiOSTagger.h to your app's prefix.pch file - in the following block:

  ```objective-c
  #ifdef __OBJC__
      ...
      #import <TealiumiOSLibrary/TealiumiOSTagger.h>
  #endif
  ```
  4. Initialize the library singleton with the initSharedInstance:profile:target:rootController: method.


Updating from a legacy library
------------------------------
If you're updating from a prior copy of the ios-tagger library (version 1), do the following:

  1. Add additional frameworks:
      - AVFoundation.framework          (for tracking AVPlayer video objects)
      - CoreMotion.framework            (used by Mobile Companion)
      - CoreMedia.framework             (for tracking MPMoviePlayer video objects)
      - MediaPlayer.framework           (for tracking video)
      <p></p>
  2. Replace the original TealiumiOSLibrary folder with the new TealiumiOSLibrary folder that has the following contents:
      - Resources folder
      - TealiumiOSLibrary.framework
      <p></p>
  3. Replace the original import statement:
  4. 
  ```objective-c
  #ifdef __OBJC__
      ...
      #import #TealiumiOSTagger.h#
  #endif
  ```

  with the new statement:
  
  ```objective-c
  #ifdef __OBJC__
      ...
      #import <TealiumiOSLibrary/TealiumiOSTagger.h>
  #endif
  ```


Automatic Reference Counting (ARC)
----------------------------------

The framework is ARC compliant and has been compiled with the correct -fobjc-arc flags so that they will also work in non ARC projects.


Dependencies
------------
Tealium utilizes the defacto network-detection library, [Reachability](https://github.com/tonymillion/Reachability). The Tealium iOS Tagger utilizes an ARC-compliant version
of this library. It is based on the original (non-ARC compliant) [library provided by Apple](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html).

The library is already included with the Tealium tagger, so there is no need to download the externally referenced version. 

NOTE: This reachability library has been modified to prevent namespace conflicts with the original Reachability class, should your app be using it.


How To Use
----------

### Simple Setup

The library needs to be setup from within your AppDelegate (or any other object that controls the instantiation of your root view controller), ensure the following message is called:

- initSharedInstance:profile:target:rootController: needs to be called from the application:didFinishLaunchingWithOptions: method


  ```objective-c

  - (BOOL)application:(UIApplication*) application didFinishLaunchingWithOptions:(NSDictionary*) launchOptions
  {
      //depending on how you setup your application, provide a reference to your navigation controller, tab bar controller or splitview controller
      UINavigationController *navigationController = ...;
      [TealiumiOSTagger initSharedInstance: @"(your account name)"
                                   profile: @"(profile name)"
                                    target: @"(dev, qa or prod)"
                            rootController: navigationController];
      return YES;
  }

  @end

  ```

  The fact that a UINavigationController, UITabBarController or a UISplitviewController is passed into the root controller argument enables the automatic tracking of views and objects. Meaning the appearance of all views and trackable objects can be automatically tracked.
  If you want to disable the auto tracking feature, you must call the disableAutotracking method.

  If **nil** is passed in as a root controller argument then the library will attempt to auto locate your app's root view controlling object instead of disabling the autotracking feature as in the legacy ios-tagger.

  Upgrading from ios-tagger: The initSharedInstance:profile:target:navigationController: method has been deprecated but will continue to work for the time being.

  NOTE: When using Storyboard to manage views and viewControllers, the autotracking system can find the root level viewController but will be unable to track any views that are pushed in by segues alone.  The [[TealiumiOSTagger sharedInstance] autoTrackController:self] method will need to be inserted into that view's viewController viewDidLoad: method.  



### Network Sensitive Caching

The library's own reachability class keeps tabs on the connectivity of the host device.  In the event that connectivity is lost, the library will automatically begin queueing (saving) calls for delivery once connectivity has been re-established.

Currently there is no limit to the size of the queue, except for the maximum memory allocation given to your app.

### Power Save Mode

When a user's device is charging or at full power, the library will dispatch tracking data as they are processed.  In the event that a device is running on battery power, the library's power save system will cache call dispatches until one of the following occurs:
- The Power Save Call Limit is reached (default 25 events)
- The app moves to the background
- The app moves to the foreground
- The webview is otherwise reloaded (ie from Mobile Companion, re-launched, etc.)

The following optional methods affect the Power Save system:
- (void) disablePowerSaveMode;
- (void) enablePowerSaveMode;
- (void) setPowerSaveCallLimit:(int)limit;

NOTE: When the power save mode is disabled, dispatches will be sent as they are processed


### AutoTracking Feature

When initialized using the recommended initSharedInstance:profile:target:rootController: method, the library will automatically enable the autotracking system, which allows it to track view appearances and basic ui object interactions without any additional coding.  To disable this feature, use the disableAutotracking method.  Note: if disabled, you will have to manually implement all tracking calls.

The following is the current list of auto trackable objects:

- UINavigationControllers
- UITabBarControllers
- UISplitViewControllers
- UIButtons
- UIImagePickerControllers
- UISwitches
- UISliders
- UISegmentedControls
- MPMoviePlayerViewControllers
- MPMoviePlayerControllers

### AutoTracking Objects

If the autoTracking feature is enabled (default on) yet the library is unable to detect a particular object, you may manually register a normally autotrackable object  (see list above) and optionally assign your own Tealium Reference ID to that object.  The library will attempt to self-assign an id if nil is passed in as an argument.  Library generated Tealium Reference IDs are always 5 characters long, so it is recommended that you use 6 or more characters if you are manually assigning one.

```objective-c
- (void) autotrackObject:(id)object tealiumId:(NSString*)tealiumId;

Example usage:

- (void) buttonCreated:(UIButton*)button
{
    ...
    [[TealiumiOSTagger sharedInstance] autotrackObject:button tealiumId:@”MyButton_1”];
    ...
}
```

NOTE: If the library has already assigned a Tealium Reference ID to an object during it’s initialization scan, then your manually assigned id will be ignored.

### Universal Event Tracking (new)

This is the recommended method for manually tracking custom screen/page appearances, events and tappable actions. This method allows you to take advantage of the setVariable:Value:To: and setGlobalVariable:Value: methods:

```objective-c
- (void) trackObject:(id)object title:(NSString)title eventData:(NSDictionary*)eventData;
```

By passing in the object (ie UIButton, UIViewController, etc.) allows you to take advantage of the automatically detected free data sources (such as app_name, object_class, etc.). 


The title and eventData arguments are optional and "nil" may be assigned.  Passing in a title will override the library's own naming scheme for objects.  For example, most events will automatically be given a title like:  "UIButton: Buy Button: tapped".

Below is an example of how to use it to track a view appearance from a UIViewController:
```objective-c
...

- (void)viewDidAppear
{
    ...
        [[TealiumiOSTagger sharedInstance] trackObject:self title:@"Store Page" eventData:nil];
    ...
}

...
```

And an example of how to use it to track button action:

```objective-c
...

- (IBAction) tap:(id)sender
{
    ...
    NSDictionary *customData = @{@"ProductId":@"31a, @"Price":@"15.00"};
    [[TealiumiOSTagger sharedInstance] trackObject:sender title:nil eventData:customData];
    ...
}

...
```


### Custom Item Click Tracking (Legacy)

This is the legacy method for tracking ANY action or event, including tap events by any object:

```objective-c
- (void) trackItemClicked:(NSString*) clickableItemId;
```


This message can be passed regardless of how the item is engaged, whether it is via a custom click delegate, segue calls, or otherwise. 

Below is an example of how to use it:

```objective-c
...

- (void)viewDidLoad
{
    ...
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    ...
}

...

- (void)insertNewObject:(id)sender {
    ...
    [[TealiumiOSTagger sharedInstance] trackItemClicked:@"new row added"];
}

...
```

Note: The Tealium IQ variable for this call is "link_id" and it's value will be the string value passed into the method (ie "new row added").

Warning: Using this method with an autotracked object may result in duplicate calls.


### Custom Screen View Tracking (Legacy)

These are the legacy methods for tracking view/page appearances:

```objective-c
- (void) trackScreenViewedWithTitle:(NSString*)title eventData:(NSDictionary*)eventData;

- (void) trackScreenViewedWithViewController:(UIViewController*)viewController WithEventData:(NSDictionary*) eventData;
```

To use:
```objective-c
...

- (void)viewDidAppear
{
    ...
        [[TealiumiOSTagger sharedInstance] trackScreenViewedWithTitle:@"Login Page" eventData:nil];
    ...
}

...
```

### Default Data Sources

The following variables are some of the variables sent with all autotracked views and objects:

- app_id                  (composite of app_name + app_version)
- app_name                (applicaton name)
- app_version             (application version)
- autotracked             (call triggered from autotracking system - true / false)
- call_type               (link/view - most analytics will only take 1 of these 2 types)
- carrier                 (device service carrier name - if available)
- carrier_iso             (carrier iso country code - if available)
- carrier_mcc             (carrier mobile country code - if available)
- carrier_mnc             (carrier mobile network code - if available)
- connection_type         (reachability type such as wifi, cellular, etc.)
- device                  (ie iPod, iPhone, iPad, etc.)
- device_resolution       (screen resolution of device - width by height - ie 320x480)
- library_version         (version of the Tealium Library installed)
- object_class            (the OS element type responsible for the call, ie UIButton)
- orientation             (orientation of device at time of call)
- os_version              (version of operating system on device)
- platform                (os type - iOS)
- platform_version        (composite of platform + os_version)
- timestamp               (GMT timestamp of event occurrance)
- timestamp_gmtoffset     (GMT offset of device)
- timestamp_local         (Local timestamp of event occurance)
- timestamp_unix	  (GMT timestamp in unix format)
- uuid                    (universally unique id OR custom assigned id)

- screen_title            (page name - views only)
- link_id                 (event identifier - format: object:title(if any):status(if any))

### Lifecycle Data Sources
App lifecycle events send out the following data in addition to the default data sources when it launches, wakes from the background, goes to the background (sleep) or is closed by the user or OS (terminate):

- lifecycle_type                  (initial, launch, wake, sleep, terminate (app shut down))
- lifecycle_dayofweek_local       (local day of the week as a number 1=Sunday, 7=Saturday)
- lifecycle_dayssincelaunch       
- lifecycle_dayssinceupdate       
- lifecycle_dayssincelastwake  
- lifecycle_hourofday_local       (local hour of day only)   
- lifecycle_isfirstlaunch         (true - otherwise not dispatched)
- lifecycle_isfirstlaunchupdate   (true if this call for first launch after an update)
- lifecycle_isfirstwaketoday      (true if this is the first wake/launch of app today)
- lifecycle_isfirstwakemonth      (true if this is the first wake/launch of app this month)
- lifecycle_firstlaunchdate       (timestamp of very first launch)
- lifecycle_lastsimilarcalldate   (timestamp of last call of similar lifecycle_type)
- lifecycle_wakecount             (number of app launches+wakes from background - this app version)
- lifecycle_launchcount           (number of launches - this app version)
- lifecycle_launchcount_update    (number of launches after update only - not sent if not yet updated)
- lifecycle_sleepcount            (number of times app has gone to the background - this app version)
- lifecycle_terminatecount        (number of times app has been closed - this app version)
- lifecycle_totalwakecount
- lifecycle_totallaunchcount
- lifecycle_totalsleepcount
- lifecycle_totalterminatecount
- lifecycle_totalsecondsawake     (aggregrated total up to time of call - sent upon wake/launch)
- lifecycle_secondsawake          (time app was awake - sent only with sleep/terminate calls)


NOTE: True lifecycle data sources will not be sent if false.  So in IQ you can safely map these data sources without having to fork/filter between true and false responses.

Please visit the Tealium Learning Community site for the complete list of default data sources sent by the library for specific object classes.


### Extending Data Points

The following methods below allow you to extend the default and element specific datapoints:

- (BOOL) addVariable:(NSString*)variable value:(NSObject*)value to:(id)object;
- (BOOL) addEventData:(NSDictionary*)eventData to:(NSObject*)object;
- (BOOL) addGlobalVariable:(NSString*)variable value:(NSObject*)value;
- (BOOL) addGlobalEventData:(NSDictionary*)eventData

The addVariable:value:to method adds one key-value pair of data to an object or a view controller whenever calls related to it are made. For example, an NSString object has been created to record a client id for video files (ie _clientId). If you want that client id added to every auto-tracked play/pause event for that video:

Example usage:

```objective-c
- (void) mpMoviePlayerControllerStateChanged:(NSNotification*) notification{
{
    …
     MPMoviePlayerController *player = (MPMoviePlayerController*)[notification object];
    [[TealiumiOSTagger sharedInstance] addVariable:@”clientId” value:_clientId to:player];
    ...
}
```

Alternatively, if you have several key-value pairs you would like passed, you can use the the addEventData:To: to attach a dictionary of key-value pairs to that object.

Example usage:

```objective-c
- (void) mpMoviePlayerControllerStateChanged:(NSNotification*) notification{
{
    …
     MPMoviePlayerController *player = (MPMoviePlayerController*)[notification object];
    NSDictionary *extraData = [NSDictionary dictionaryWithObjectsAndKeys:@”C_23B”, @”clientId”, @”Kansas”, @”broadcastRegion”, @”KTM1”, @”broadcastStation”];   
    [[TealiumiOSTagger sharedInstance] addEventData:extraData to:player];
    ...
}
```

Lastly you can add a global key-value pair of data with the addGlobalVariable:value: method.  This data will be added to ALL outbound calls.

Example usage:

```objective-c
- (void) viewDidLoad:(id)viewController
{
    …
    // presuming the calling viewController has an NSString property named ‘_state’ that has been populated by another method that has retrieved the user’s current location
    [[TealiumiOSTagger sharedInstance] addGlobalVariable:@”Location_State” value:_state];
    ...
}
```

### Developer Options

Several public override methods exist that will supercede the library's default operations:

- (void) checkForNewPublishedSettings; 
- (void) rescan;          
- (void) disable;
- (void) enable;
- (void) disableAutotracking;
- (void) enableAutotracking;

*checkForNewPublishedSettings* The library normally checks for new published configuration settings when it wakes from the background or at startup.  Use this method within a timer if you want the library to periodically check or add to a IBAction to have it triggered by your own UI object

*rescan* By default the library rescans your app for trackable elements after any view appearance or trackable event occurs. If you have a long running animation that occurs before your view actually updates, add this call to your completion block

*disable* Puts the library to permanent sleep. Use this if you offer your clients the ability to toggle off usage tracking

*enable* Used only to reawake the library from a disable call

*disableAutotracking* If for any reason you do not want the library to autotrack views and events, use this method.  Warning! If enabled in your release version, no published configuration setting can re-enable autotracking.

*enableAutotracking* Activates the autotracking feature if it has been turned off by the disableAutotracking method.


### Debug Options

Two methods and several properties may be toggled within the library to aide in debugging and development:

- (void) unlockMobileCompanion          // see description below
- (void) suppressTealiumLogs            // see description below

@property BOOL displayConciseLogs       // show minimal operations logs - default YES
@property BOOL displayErrorLogs         // logs and errors encountered - default YES
@property BOOL displaySkipLogs          // logs any elements skipped by library - default NO
@property BOOL displayVerboseLogs       // show detailed logs regarding operations - default NO

the methods can be used as follows:

```objective-c
...
    [[TealiumiOSTagger sharedInstance] unlockMobileCompanion];
    [[TealiumiOSTagger sharedInstance] suppressTealiumLogs];
...
```
and for the properties:

```objective-c
...
    [[TealiumiOSTagger sharedInstance].displaySkipLogs = YES;
    [[TealiumiOSTagger sharedInstance].displayErrorLogs = NO;
...
```

When the unlockMobileCompanion method is called, the Mobile Companion feature will unlock itself. This must be enabled if you wish to test Mobile Companion in the simulator.  Call this just after the class level initSharedInstance:profile:target:rootController init method.The library will suppress this setting when your target environment is not set to 'Dev', otherwise, it will override any published extension settings it encounters. 

It is HIGHLY recommended that you comment or remove this method before generating your release version for distribution through the the app store or for enterprise distribution.

When the suppressTealiumLogs method is called, the library will no longer display library related logs to the console.  Tealium logs are enabled by default.


### Mobile Companion Feature

The library comes pre-installed with the new mobile companion system that allows you to:

- Inspect your library account settings
- Review the extensions data being read by the library
- Inspect the datapoints sent out by calls related to the currently visible view
- Inspect the datapoints sent out by calls related to any selected trackable object
- Inspect the queued and sent event dispatch logs
- Check to see if the autoBatchDelivery system is currently on and what the current batch limit is.
- Ability to force reload the webview and clear out the sent queue log.

NOTE: Force refreshing will also start uploading any queued items, so you may have to tap again if you wish to completely flush out the call logs.


Mobile Companion requires a 3 stage unlock sequence to launch:
- Toggle the "Mobile Companion" option to "On" in your iOSLiveAppHandler extension then save & publish
- Shake the device 3 times hard
- Tap anywhere within your app 3 times quickly

NOTE: The last two sequences must be done in rapid succession.


### UUIDs
Tealium's tagger includes methods to create, retrieve and set a Universally Unique Identifier for an app on a device.  The following method will retrieve the auto-created UUID:

```objective-c
...
    NSString *uuid = [[TealiumiOSTagger sharedInstance] retrieveUUID];
...
```

If you are implementing your own UUID system, you can set the Tagger's UUID to match:

```objective-c
...
    NSString *yourUUID = ...;
    [[TealiumiOSTagger sharedInstance] setUUID:yourUUID];
...
```


Tealium IQ Hook up Example
--------------------------
This example is for mapping two variables to a Google Analytics account to your app through the Tealium Management Console.  This sample presumes you have already done the following:
- Setup a Google analytics account from www.google.com/analytics/
- Have added Tealium tracking code to your project
- Have a Tealium account at www.tealium.com

The steps to properly map data from your app are:

1. Load the Account:Profile:Version that matches the Account and Profile in your *initWithSharedInstance:profile:target:navigationController:* method. Any TealiumIQ version is acceptable.


4. Goto the **Data Sources** tab and add the following new data sources:  
      - screen_title
      - link_id

  Note: leave them as the default type: Data Layer.  *screen_title* are your views' viewcontroller title or nibName property.  *link_id* are the custom titles from any trackable objects found in your app.
    
5. Go to the **Tags** tab:
      - click on the *+Add Tag* button
      - select Google Analytics
      - enter any title (ie "GAN") in the title field
      - enter your Google Analytics product id into the account id field (this is the account id assigned by Google and usually starts with the letters *UA*...)
      - click on the *Next* button
      - make sure the *Display All Pages* option is checked on in the Load Rules section
      - click on the *Next* button
      - in the *Source Values* dropdown - select *screen_title(js)* - click on *Select Variable*
      - select *Page Name (Override)* option in the Mapping Toolbox
      - click *save*
      - in the *Source Values* dropdown - select *link_id(js)* - click on *Select Variable*
      - select *Event Action* option in the Mapping Toolbox
      - click *save*
      - click on the *finish*

Note: The *link_id* variable may need to be mapped to the Event Category, Event Action and Event Label variables because Google Analytics requires three levels of categorization.  Alternativelly you can auto set all but one of these fields from the Extensions tab.
  
6. Goto the **Extensions** tab:
      - add an iOS Handler extension
      - (Default will unlock the 1st stage of the Mobile Companion unlock sequence and will track all views) 
         
7. Click on the *Save/Publish* button
      - Click on "Configure Publish Settings..."
      - Make sure the "Enable Mobile App Support" option is checked on.  Click the "Apply" button
      - Enter any *Version Notes* regarding this deployment
      - Select the *Publish Location* that matches the *environmentName* in your *initSharedInstance:profile:target:rootController:* method
      - Click on Configure Publish Options... The Publish Settings dialog box will appear. Make certain the "Enable Mobile App Support" option is checked on and click "Apply". 
      - Click "Save"

  NOTE: It may take up to five minutes for your newly published settings to take effect.


FAQ
---

QUESTION: What does "Successfully packaged Data Sources:" mean?
ANSWER: This means the library has successfully tracked and packaged tracking data into a single call for dispatch. Calls are actually only dispatched if they have been mapped to analytic service in your Tealium IQ console.  The key in the key-value pairs presented become the Data Source objects found in you Tealium IQ's Data Sources tab.  Data Sources NOT mapped in IQ are not actually dispatched. This statement replaces the legacy "Successfully sent call:" message, which was confusing, as the message did not guarantee an outbound call was actually sent.

QUESTION: Can two instances of the library be instantiated to track two different sets of data?
ANSWER:   This should not be done in code. The library should be configured to track everything possible and then use Tealium's IQ Panel to map all data.

QUESTION: Why does one of my views produce a screen_title value like "94X-KC-KQz-view-FQQ-5O-q5P"?
ANSWER: Views created by storyboards are given these types of identifiers. To assign a more meaningful title to your views, simply add in a value to the view's viewController title property in code or in interface builder. 

Troubleshooting
---------------
 
PROBLEM: Crash with following console log: *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[0]'
SOLUTION: Set your target OS to the minimum needed by the Library AND make sure your base SDK is available: go to your project: PROJECT: Build Settings: Architectures: Base SDK.

PROBLEM:  Directory not found for option '-F/Users/user/Tealium/ios-library/TealiumiOSSampleApps/TealiumiOSTestApp/../TealiumiOSLibrary'
SOLUTION:  Goto your Target: Build Settings Tab: Search Paths section: Framework Search Paths: remove any paths to old copies of the Tealium iOS Library.

PROBLEM: "dyld: Symbol not found: _objc_setProperty..." or similar runtime error.
SOLUTION: Set your target OS to the minimum needed by the library. To do this: goto your project: PROJECT: Info tab: Deployment Target: iOS Deployment Target.  Then go to project: TARGETS: Summary: iOS Application Target: Deployment Target. 

PROBLEM:  Library is not detecting the updated app version in dispatches.
SOLUTION: App version numbers must be updated in two locations in XCode. Make sure that the "Bundle version" in your app's - TARGET: (build target): Info tab: Custom iOS Target Properties: Bundle version - matches the bundle version from your app: TARGET:(build target): Summary tab: Version field. 

PROBLEM: Mach-O Linker Warning - "...TealiumiOSLibrary, file was built for archive which is not the architecture being linked (armv7):..." or similar XCode archive compile time error. 
SOLUTION: In your project:Targets:(primary target):Build Settings tab: Architectures: Build Active Architecture Only: set your "Release" architecture to "Yes". This can occur if you are swapping between different library versions.

PROBLEM: Mach-O Linker Warning - "Undefined symbols for architecture armv7:
  "_OBJC_CLASS_$_CMMotionManager", referenced from:
      objc-class-ref in TealiumiOSLibrary(TealiumiOSMobileCompanion.o)
  "_OBJC_CLASS_$_CTTelephonyNetworkInfo", referenced from:..."
SOLUTION: Add the missing frameworks, in this case: the CoreMotion.framework and the CoreTelephony.framework.  Go to your project: Targets: (primary target): Summary tab: Linked Frameworks and Libraries: (use + button to add frameworks)

PROBLEM: Video objects are firing both MPMoviePlayer and AVPlayer notifications
SOLUTION: Certain video objects trigger both types of notifications.  In your Tealium IQ Panel, simply do not map these unwanted calls or add an extension to filter them. 


Versions
--------
*2.2*
-   UITableView cell selections auto tracked
-   UIGestureRecognizers auto tracked
-   Timestamp data source now formatted to ISO8601 standard
-   Timestamp_unix option added to default data sources
-   Code updates to the auto tracking system and mobile companion
-   Mobile Companion unlock bug fix
-   Auto tracking suppression method fix
-   Log reporting updated

*2.1*
-   iOS Library Manager extension requirement removed - will track all views, all events by default
-   Caught and uncaught exception (crash) tracking added
-   Lifecycle tracking added
-   UIWebView tracking added
-   MPMoviePlayer milestone percent tracking added
-   Exclude objects from auto tracking methods added
-   Universal manual tracking method added
-   Backwards compatibility upgraded - works with iOS 5.0+
-   Additional auto tracked default data source added
-   Sent call console log reporting made easier by displaying as alphabetized array
-   ALL data source keys are now lower-case for uniformity (ie. OS_version is now os_version)

*2.0*
-   Mobile Companion introduced
-   Autotrack views upgraded to include UITabBar and UISplitView controllers
-   Autotrack events added for UIButtons, UISliders, UISwitches and UISegmentedControllers
-   Add custom data to autotracked views & events
-   Power save caching added
-   Error log features added
-   Works with iOS 6.0+
-   Required iOS Library Manager extension to be enabled to track

*1.0*
-   Autotrack views from UINavigationControllers
-   Network connectivity caching feature
-   Custom tracking methods
-   Works with reconfigurable tag mapping through Tealium IQ
-   Worked with iOS 5.0+

Support
-------

For additional help and support, please send all inquires to mobile_support@tealium.com

