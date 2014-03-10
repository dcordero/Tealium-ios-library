Tealium iOS Library - Version 3.1 & 3.1c
========================================

********** UPDATE NOTICE **********
***********************************
If updating from a previous version of the
Tealium iOS Library, you will need to update
your import statement:

```objective-c
...

// FROM	
// #import <TealiumiOSLibrary/TealiumiOSTagger.h>
// TO	
#import <TealiumLibrary/Tealium.h>
...
```

“TealiumiOSTagger” can still be used as the library’s 
class name for previous implementations, but using 
“Tealium” is now recommended moving forward.
***********************************


This library framework provides Tealium customers the means to tag their native iOS applications for the purpose of leveraging the vendor-neutral tag management platform offered by Tealium.  

This framework provides for:
- Analytics integration via the Tealium platform
- automatic view controller tracking
- automatic object and event tracking (see list of autotrackable objects below)
- automatic video player tracking
- automatic lifecycle tracking
- optional video milestone tracking
- optional custom action tracking
- intelligent network-sensitive caching
- optional power save batching of calls
- simple to use messages, including singleton or dependency-injection-friendly instances.
- simple setup and remote configuration
- implemented with the user in mind. All tracking calls are asynchronous as to not interfere or degrade the user experience. 

These instructions presume you have valid accounts with both Tealium and the analytic services you want to map data to.

Implementation is a three part process:
1. Download and add the library to your iOS XCode Project
2. Configure your Tealium IQ dashboard with a Tag and the "Enable Mobile App Support" option enabled
3. Optionally enable the iOS Library Manager Extension in the IQ Extensions tab


Table of Repo Contents
----------------------
- TealiumLibrary.framework: contains the actual library and header file (read-only)
- **TealiumCompact** folder contains the compact version of the library (automatic UI event tracking + mobile companion removed)
- **TealiumSampleApps** folder contains a sample app and a blank app from which you can start a project from.  Note: The TealiumLibrary.framework will need to be imported to those projects to test/use (simply click and drag into your Xcode project)
- **.gitignore** file is a git file that can ignored
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


New Installation - FULL VERSION
-------------------------------
Installing the TealiumLibrary into your app requires the following steps:

  0. Copy the **TealiumLibrary.framework** folder into your project's source folder. The library folder contains the Tealium.h header file, which also lists all the public methods available.
  1. Add the following frameworks to your project:
      - AVFoundation.framework          (for tracking AVPlayer video objects)
      - CoreGraphics.framework		(used internally)
      - CoreMedia.framework             (for tracking MPMoviePlayer video objects)
      - CoreTelephony.framework         (for tracking carrier data)
      - MediaPlayer.framework           (for tracking video)
      - SystemConfiguration.framework   (for connectivity data)
      <p></p>

  2. In your project's Build Settings: Linking: Other Linker Flags add "-all_load -ObjC" as a flag option
  3. Initialize the library singleton with the initSharedInstance:profile:target:options: method.
  4. Add the following import statement into every class using the library:
  ```objective-c
  #import <TealiumLibrary/Tealium.h>
  ```

OR add this statement to your app's prefix.pch file - in the following block:

  ```objective-c
  #ifdef __OBJC__
      ...
      // This is a global import option
      #import <TealiumLibrary/Tealium.h>
  #endif
  ```

New Installation - COMPACT VERSION (3.1c)
————————————————————
Installation requirements for the compact version are the same as for the full version, with the following exceptions:
  1. The compact library only requires 2 frameworks (but linking full version's required 6 recommended during dev for fast switching):
      - CoreTelephony.framework         (for tracking carrier data)
      - SystemConfiguration.framework   (for connectivity data)
      <p></p>

The Compact version is a lighter weight library with the auto tracking and mobile companion features removed.  Certain data points are still provided (such as app name, carrier data and timestamps), but auto view change and event tracking is completely removed.  Additionally, the Compact Library is compiled ONLY for use with devices, so will not run or compile in the simulator.

To access the Compact library, simply swap the framework for the one found in the TealiumCompact folder.  Both libraries use the same namespace and class names so you will not have to update any code when switching between them.  To verify which version you are using, check the Tealium.h header which will explicitly state which version of the library you are on (3.1 or 3.1c)


Updating from prior versions
----------------------------

If you're updating from version 2.0, do the following:
  1. Add the following frameworks to your project:
      - CoreGraphics.framework		(used internally)
  2. In your project's Build Settings: Linking: Other Linker Flags add "all_load -ObjC" as a flag option


If you're updating from a the ios-tagger (version 1.0), do the following:

  1. Add additional frameworks:
      - AVFoundation.framework          (for tracking AVPlayer video objects)
      - CoreMotion.framework            (used by Mobile Companion)
      - CoreMedia.framework             (for tracking MPMoviePlayer video objects)
      - MediaPlayer.framework           (for tracking video)
      - SystemConfiguration.framework	(for connectivity checks)
      <p></p>
  2. In your project's Build Settings: Linking: Other Linker Flags add "all_load -ObjC" as a flag option
  3. Replace the original TealiumiOSLibrary folder with the new TealiumiOSLibrary folder that has the following contents:
      - Resources folder
      - TealiumiOSLibrary.framework
      <p></p>
  4. Replace the original import statement:
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

The library typically should be setup from within your AppDelegate or wherever your root view controller is created, using the initSharedInstance:profile:target:option: method like so:


  ```objective-c

  - (BOOL)application:(UIApplication*) application didFinishLaunchingWithOptions:(NSDictionary*) launchOptions
  {
      [Tealium initSharedInstance: @"(your account name)"
                          profile: @"(profile name)"
                           target: @"(dev, qa or prod)"
                          options: 0;
      return YES;
  }

  @end

  ```

  Upgrading from ios-tagger and version 2.0: The initSharedInstance:profile:target:navigationController: and the initSharedInstance:profile:target:rootController: methods have been deprecated but will continue to work for the time being.
  

### Options

Most configuration options are now done using the Tealium IQ Library Manager extension, accessible in your Tealium IQ Dashboard. The following are the only dev side, code configuration options:

- TLSuppressLogs
- TLDisplayVerboseLogs
- TLDisableHTTPS
- TLPauseInit

These options are called at init time, multiple options being separated by a "|" (pipe) character and done like:

  ```objective-c

  - (BOOL)application:(UIApplication*) application didFinishLaunchingWithOptions:(NSDictionary*) launchOptions
  {
      [Tealium initSharedInstance: @"(your account name)"
                          profile: @"(profile name)"
                           target: @"(dev, qa or prod)"
                          options: TLDisableHTTPS | TLPauseInit;
      return YES;
  }

  @end

  ```

**TLSuppressLogs** Will suppress all but warning and error logs from the library. This is automatically enabled if you're target environment has been set to 'prod' (production)

**TLDisableExceptionHandling** Disables the library's hook into the OS's app exception (crash) handling. Use this option if you are implementing you're own exception handling.  Note: you will have to add a manual track call to your custom exception handler for the library to make crash data available to your IQ mappings.

**TLDisableHTTPS** Uses HTTP to communicate with your mobile.html configuration page. Recommended only during development, this automatically ignored if your target environment has been set to 'prod' (production).

**TLDisplayVerboseLogs** Displays detailed log output from the library. Recommended only you suspect the library is causing your app to crash.

**TLPauseInit** use this if you will be overriding the default mobile.html url address location or if there is global custom data you wish to add to the library before it's first dispatch (usually a launch lifecycle dispatch).  Remember to use the resumeInit: method afterwards or the library will not finish initializing.


### Network Sensitive Caching

The library's own reachability class keeps tabs on the connectivity of the host device.  In the event that connectivity is lost, the library will automatically begin queueing (saving) calls for delivery once connectivity has been re-established.

Currently there is no limit to the size of the queue, except for the maximum memory allocation given to your app.

### Power Save Call Limit

The Power save feature is now entirely controlled by the Library Manager.  If no manager extension is present during load time, the library will NOT power save and will send calls out as they are processed.  In the library manager extension you can set a Power Save Call Limit. A number greater than zero will force the library to queue calls until the that number of calls have been reached, before attempting to dispatch all. This feature will ignore the battery charge state and will only force deliver if the web view is refreshed, when the app launches or returns from the background.

### AutoTracking Feature

The Tealium auto tracking feature is automatically enabled and is DISABLED under the following conditions
- Your mobile.html can not be reached (no internet connection + no saved configuration)
- Your mobile.html does not have any tags (no target destination for tracking data available)
- Your mobile.html has the Library Manager extension enabled but ALL of the following are DISABLED: Track All Views, Track All Events, Custom Tracking  

Note: if auto tracking is disabled, manual track calls will still dispatch.

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

### Manually tracking objects

The following method is recommended for manual dispatches:

```objective-c
- (void) track:(id)object customData:(NSDictionary*)eventData as:(NSString*)callType;
```

and can be used like:

```objective-c
...

- (void)viewDidAppear
{
    ...
	// This code within a UIViewController class
        [[Tealium sharedInstance] track:self customData:@{@"screen_title:"Store Page"} as:TealiumViewCall];
    ...
}
...
```

and will fire off a tracking call for this UIViewController's view as a view appearance. The same method could be used to track an event from an object like:

```objective-c
...

- (IBAction) tap:(id)sender
{
    ...
    NSDictionary *customData = @{@"ProductId":@"31a, @"Price":@"15.00"};
    [[Tealium sharedInstance] track:sender customData:customData as:TealiumEventCall];
    ...
}
...
```

The 'as:' argument option can take the TealiumViewCall, TealiumEventCall or nil (the library will auto determine the call type). Nil is actually recommended as the library will usually be able to determine whether a view or an event link call is appropriate for the tracked object.  However, if you want to force the manual call to track as either a view or an event, use this option.  For example, if you want to track the above button tap as a view appearance call, you could code the following:

```objective-c
...

- (IBAction) tap:(id)sender
{
    ...
    [[Tealium sharedInstance] track:sender customData:@{@"Price":@"15.00"} as:TealiumViewCall];
    ...
}
...
```

This method replaces the trackObject:title:eventData: universal tracking method, and works with the new addCustomData:to: and addGlobalCustomData: methods.


### Overriding Tealium ID
You can overwrite or assign a Tealium ID to any trackable object by using the setTealiumId:to: method like so:

```objective-c
...
- (void) buttonCreated:(UIButton*)button
{
    ...
    [[Tealium sharedInstance] setTealiumId:@"myIdentificationString" to:button];
    ...
}
...
```

NOTE: This will overwrite any previously assigned Tealium Id to this object.


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
    [[Tealium sharedInstance] trackItemClicked:@"new row added"];
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

- (void)viewDidAppear:(BOOL)animated
{
    ...
        [[Tealium sharedInstance] trackScreenViewedWithTitle:@"Login Page" eventData:nil];
    ...
}

...
```

### Default Data Sources

The following are some of the data source variables sent with all autotracked views and objects:

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
- timestamp               (GMT timestamp of event occurrence)
- timestamp_gmtoffset     (GMT offset of device)
- timestamp_local         (Local timestamp of event occurrence)
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


### Adding Custom Data Sources

The following methods below allow you to extend the default and element specific data points:

- (BOOL) addCustomData:(NSDictionary*)customData to:(NSObject*)object
- (BOOL) addGlobalCustomData:(NSDictionary*)customData;

The addCustomData:to: method adds a dictionary of data to a single NSObject subclass. For example, say your movie handling class has a property named "client_id". If you want that id added to every auto-tracked video event, you could add the following code:

Example usage:

```objective-c
- (void) mpMoviePlayerControllerStateChanged:(NSNotification*) notification{
{
    …
     MPMoviePlayerController *player = (MPMoviePlayerController*)[notification object];
    [[Tealium sharedInstance] addCustomData:@{@”clientId”:_clientId} to:player];
    ...
}
```

Which would add the data source key 'clientId' with a value of the _clientId property to every video this class was handling.

The addGlobalCustomData: method allows you to add a dictionary of additional data to ALL outbound calls:

Example usage:

```objective-c
- (void) viewDidLoad:(id)viewController
{
    …
    // presuming the calling viewController has NSNumber properties named ‘_longitude’ and '_latitude' that have been populated by other methods
    [[Tealium sharedInstance] addGlobalCustomData:@{@”Longitude”:_longitude,@"Latitude":_latitude];
    ...
}
```

NOTE: The library will automatically convert numbers to strings for dispatches, if you require a particular number formatting (i.e. to within a set number of decimal points), we recommend you pre format your data string before passing it to the library, for example:

```objective-c
- (void) viewDidLoad:(id)viewController
{
    …
    // presuming the calling viewController has NSNumber properties named ‘_longitude’ and '_latitude' that have been populated by other methods
    NSString *longFormatted = [NSString stringWithFormat:@"%.4f", _longitude];
    NSString *latFormatted = [NSString stringWithFormat:@"%.4f", _latitude];
    [[Tealium sharedInstance] addGlobalCustomData:@{@”Longitude”:longFormatted,@"Latitude":latitudeFormatted];
    ...
}
```


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
    NSString *uuid = [[Tealium sharedInstance] retrieveUUID];
...
```

If you are implementing your own UUID system, you can set the Tagger's UUID to match:

```objective-c
...
    NSString *yourUUID = ...;
    [[Tealium sharedInstance] setUUID:yourUUID];
...
```


Tealium IQ Basic Set Up + Verification Test
-------------------------------------------
This example is for mapping two variables to a Google Analytics account to your app through the Tealium Management Console.  This example presumes you have already done the following:
- Setup a Google analytics account from www.google.com/analytics/
- Have added Tealium tracking code to your project (see instructions above)
- Have a Tealium account at www.tealium.com

Verification steps are:

1. Log into your Tealium account

2. Load the Account and Profile that matches the Account and Profile used in your *initWithSharedInstance:profile:target:* method.

3. Goto the **Data Sources** tab and add the following new data source:  
      - screen_title

  Note: leave them as the default type: Data Layer.  *screen_title* are your views' viewcontroller title or nibName property.
  Optional: copy and paste the entire set of predefined Data Sources found at: https://community.tealiumiq.com/series/3333/posts/625639
    
4. Go to the **Tags** tab:
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
      - click *save*
      - click on the *finish*
         
5. Click on the *Save/Publish* button
      - Click on Configure Publish Options... The Publish Settings dialog box will appear. Make certain the "Enable Mobile App Support" option is checked on and click "Apply". 
      - Enter any *Version Notes* regarding this deployment
      - Select the *Publish Location* that matches the *environmentName*, or target argument from your *initSharedInstance:profile:target:* method
      - Click "Save"

  NOTE: It may take up to five minutes for your newly published settings to take effect.

6. Log into your Google Analytics dash board - goto your real time tracking section

7. Launch your app and interact with it.  You should see view appearances (page changes) show in your Google Analytics dashboard


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

PROBLEM: Undefined symbols for architecture armv7:
  "_llvm_gcda_emit_function", referenced from:
      ___llvm_gcov_writeout in TealiumLibrary…
SOLUTION: In your build settings, try changing your Apple LLVM compiler - code generation setting “Instrument Program Flow” to YES.


Known Limitations of Current Build
----------------------------------
- Tealium Reference Ids are not guaranteed for dynamically created objects. For example,  where an object (button, image, etc.) is added to it's view controller’s view hierarchy after creation time (i.e. is added by some triggering event)
- Buttons within UIToolBars are not guaranteed to be auto tracked
- All touch events on device are now tracked


Versions
--------

*3.1*
- TealiumiOSTagger.h renamed to Tealium.h
- TealiumiOSTaggerLibrary.framework renamed to TealiumLibrary.framework
- Sample Apps renamed to TealiumBlankApp & TealiumTestApp
- Compact version introduced, use framework found in TealiumCompact folder
- Native 64-bit simulator support added
- Git commit logs cleaned. Using git, you can roll back to any prior stable version of the Tealium iOS library
- All lifecycle calls made priority tracking calls

*3.0.2*
-   TLDisableLifecycleTracking option added to init options
-   Tracking exclusion feature upgraded to stop autotracking of objects dependent on Library Manager conditional settings


*3.0.1*
-   TLDisableExceptionTracking option added to init options
-   Dispatch log order of sequence reporting corrected
-   Bug in remote disabling of Mobile Companion fixed
-   Bug in object_class reporting from certain objects fixed

*3.0*
-   Ivars and Properties now auto trackable (configurable from the new Library Manager)
-   Mobile Companion now resizable
-   Mobile Companion now displays an alert for data points found in it's tableview cells (double tap to activate)
-   Major backend refactoring for more consistent & faster event tracking, smaller library
-   More accurate conditional tracking processing
-   Clearer method names replace older, more ambiguous methods
-   Multiple, similar functioning methods combined into single methods
-   Extraneous optional methods removed
-   More configuration options now remotely accessible and set (library manager)
-   UITableView cell auto tracking removed for increased stability

*2.3*
-   "useInsecure" option added to permit HTTP Proxying of library during dev
-   setMobileHtmlUrlOverride method fixed
-   Autotracking system updated
-   Webview loading refactored
-   Tealium logs refactored

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

For additional help and support, please send all inquires to mobile_support@tealium.com or post questions on our community site at: https://community.tealiumiq.com


About
-----
iOS Library developed by Charles Glommen, Gautam Day and Jason Koo
Copyright © 2014 Tealium, Inc. All rights reserved.

