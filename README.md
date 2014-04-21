Tealium iOS Library - 3.1 & 3.1c
==================================

**********************
![](../../wiki/images/warning_30.png) Upgrading from an earlier version? See the [Upgrade Notice](#upgrade-notice)
**********************

###Brief###
These frameworks provide the means to tag native iOS applications for the purposes of leveraging [Tealium's tag management platform (Tealium IQ)](http://tealium.com/products/enterprise-tag-management/). 

Tealium's [mobile solution](http://tealium.com/products/enterprise-tag-management/mobile/) permits an app to add, remove or edit analytic services remotely, in real-time, without requiring a code rebuild or new release to take effect.

###Table of Contents###

- [Requirements](#requirements)
- [Quick Start](#quick-start)
    - [1. Clone/Copy Library](#1-clonecopy-library)
    - [2. Add to Project](#2-add-to-project)
    - [3. Link Frameworks](#3-link-frameworks)
    - [4. Import and Init](#4-import-and-init)
    - [5. Compile and Run](#5-compile-and-run)
    - [6. Use Proxy to Verify (optional)](#6-use-proxy-to-verify-optional)
- [What Next](#what-next)
- [Contact Us](#contact-us)

###Requirements###

- [XCode (5.0+ recommended)](https://developer.apple.com/xcode/downloads/)
- Minimum target iOS Version 5.0+

###Quick Start###
This guide presumes you have already created an [iOS app using XCode](https://developer.apple.com/library/iOS/referencelibrary/GettingStarted/RoadMapiOS/index.html).  Follow the below steps to add Tealium's Compact library (3.1c) to it. Discussion on which version is ultimately best for you can be found in the [What Next](#what-next) section.

####1. Clone/Copy Library####
onto your dev machine by clicking on the *Clone to Desktop* or *Download ZIP* buttons on the main repo page.

![](../../wiki/images/iOS_GithubClone.png)

####2. Add To Project 

2a. From the *ios-library/TealiumCompact* folder, drag & drop the *TealiumLibrary.framework*(/tealiumcompact/tealiumlibrary.framework) into your XCode project's Navigation window.

![](../../wiki/images/iOS_DragDrop.png)

2b. Click "Finish" in the resulting dialog box.

![](../../wiki/images/iOS_XCodeCopyLinkBox.png)

####3. Link Frameworks
[Link the following Apple frameworks](https://developer.apple.com/library/ios/recipes/xcode_help-project_editor/Articles/AddingaLibrarytoaTarget.html) to your project:

- CoreTelephony
- SystemConfiguration

Your project-target-General tab should now look similar to:

![](../../wiki/images/iOSc_XCodeProjectGeneral.png)

####4. Import and Init
4a. Import the library into your project's .pch file into the following block:

```objective-c
#ifdef __OBJC__
    //...

    #import <TealiumLibrary/Tealium.h>
#endif
```

4b. Init the library in your appDelegate.m class:
```objective-c
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    //...

    [Tealium initSharedInstance:@"tealiummobile" profile:@"demo" target:@"dev" options:0];
    
    // (!) Don't forget to replace "tealiummobile", "demo" and "dev" with your own account-profile-target settings before creating your production build.

}
```

####5. Compile and Run
Your app is now ready to compile and run.  In the console output you should see a variation of:

```objective-c
2014-04-07 17:07:15.470 UICatalog[1561:60b] TEALIUM 3.1c: Loading...
2014-04-07 17:07:15.471 UICatalog[1561:60b] TEALIUM 3.1c: Loading saved remote Library Manager settings
2014-04-07 17:07:15.472 UICatalog[1561:60b] TEALIUM 3.1c: Waking up
2014-04-07 17:07:15.483 UICatalog[1561:60b] TEALIUM 3.1c: Priority call saved to event queue 1 total
2014-04-07 17:07:15.960 UICatalog[1561:60b] TEALIUM 3.1c: Webview LOADED https://tags.tiqcdn.com/utag/tealiummobile/demo/dev/mobile.html?ts=65
2014-04-07 17:07:15.974 UICatalog[1561:60b] TEALIUM 3.1c: Library manager settings updated
2014-04-07 17:07:16.482 UICatalog[1561:60b] TEALIUM 3.1c: Dispatch successfully PACKAGED with 34 Data Sources: (
    "app_id = UICatalog 2.10",
    "app_name = UICatalog",
    "app_version = 2.10",
    "autotracked = true",
    "call_eventtype = lifecycle",
    "call_type = link",
    "carrier = unknown",
    "connection_type = unknown",
    "device = iPhone Simulator",
    "device_resolution = 320x568",
    "library_version = 3.1c",
    "lifecycle_dayofweek_local = 2",
    "lifecycle_dayssincelastwake = 0",
    "lifecycle_dayssincelaunch = 5",
    "lifecycle_firstlaunchdate = 2014-04-02T17:55:09Z",
    "lifecycle_firstlaunchdate_MMDDYYYY = 04/02/2014",
    "lifecycle_hourofday_local = 17",
    "lifecycle_lastsimilarcalldate = 2014-04-08 00:06:24 +0000",
    "lifecycle_launchcount = 5",
    "lifecycle_totallaunchcount = 5",
    "lifecycle_totalwakecount = 5",
    "lifecycle_type = launch",
    "lifecycle_wakecount = 5",
    "link_id = launch",
    "orientation = Portrait",
    "platform = iOS",
    "platform.version = iOS 7.1",
    "status = launch",
    "tealium_id = LIFE",
    "timestamp = 2014-04-08T00:07:15Z",
    "timestamp_local = 2014-04-07T17:07:15",
    "timestamp_offset = -7",
    "timestamp_unix = 1396915635",
    "uuid = 0076B066-4DDA-4ED4-A2C8-32D1C47842BD"
)
2014-04-07 17:07:16.984 UICatalog[1561:60b] TEALIUM 3.1c: Dispatch queue empty
```

Congratulations! You have successfully implemented the Tealium Compact library into your project.  

This line: 
```objective-c
TEALIUM 3.1c: Dispatch successfully PACKAGED with 34 Data Sources:
```
shows how many data sources were detected and available for mapping in Tealium's IQ Dashboard.  The Library only actually sends those data sources and values that are mapped.

If you have disabled internet connectivity to test offline caching, you will see a variation of:
```objective-c
2014-04-07 17:09:13.873 UICatalog[1568:60b] TEALIUM 3.1c: Loading...
2014-04-07 17:09:13.875 UICatalog[1568:60b] TEALIUM 3.1c: Loading saved remote Library Manager settings
2014-04-07 17:09:13.876 UICatalog[1568:60b] TEALIUM 3.1c: Waking up
2014-04-07 17:09:13.882 UICatalog[1568:60b] TEALIUM 3.1c: Priority call saved to event queue 1 total
```
The last line indicates that an event was saved to the event queue. In this case, the initial launch event.


####6. Use Proxy to Verify (optional)
You can use an HTTP proxy to confirm successful retrieval of configuration data from our multi-CDN and to confirm successful delivery of a tracking call. Several popular third-party options are:

- [Charles Proxy](http://www.charlesproxy.com)
- [Wireshark](http://www.wireshark.org)
- [HTTP Scoop](http://www.tuffcode.com)

Tealium's multi-CDN configuration address is *http://tags.tiqcdn.com*.  You may have to use the [*TLDisableHTTPS*](../../wiki/API-3.x#tealium-options) option when you init the library to permit proxying.

If you have access to the Tealium Community site, detailed instructions on how to setup Charles Proxy on an iDevice can be found at: https://community.tealiumiq.com/posts/624994

Alternatively, you can use an analytic service with real-time reporting to confirm delivery of dispatches.  This verification method requires both an active analytics account (i.e. [Google Analytics](http://www.google.com/analytics/)) and an active [Tealium IQ](http://tealium.com) account to enable mapping.  If you have both of these, consult the Tealium community post at: https://community.tealiumiq.com/posts/568700


### What Next###
Now that you've successfully integrated the library, you should now determine if the [Compact or Full Library versions](../../wiki/compact-vs-full) best fit your needs. Below are the key differences:


|     |Compact  |  Full
-------------------------------------|:-------------------------------:|:----:
Library Compile Size                                |200 KB | 400 KB
Initialization Time                                 |+0.1 sec | +0.1 sec
Memory Usage                                        |+12 MB |+13 MB
[Non-UI AutoTracking](../../wiki/advanced-guide#non-ui-autotracking)  |Yes |  Yes
[UI Autotracking](../../wiki/advanced-guide#ui-autotracking)          |No  |  Yes
[Mobile Companion](../../wiki/advanced-guide#mobile-companion) |No  |  Yes

(A) Continue with the Compact version, add any needed [additional tracking calls](../../wiki/API-3.x#trackcustomdataas) for events or view appearances.

(B) Switch to the Full version, see our [Basic Implementation Guide](../../wiki/basic-guide), paying attention to the additional setup requirements.

Still can't decide? Browse through our [wiki pages](../../wiki/home) for more info, or read a few mobile related posts in the [TealiumIQ Community](https://community.tealiumiq.com/series/3333) (consult your Tealium Account Manager for access).

###Contact Us###

Questions or comments?

- Post code questions in the [issues page.](../../issues)
- Email us at [mobile_support@tealium.com](mailto:mobile_support@tealium.com)
- Contact your Tealium account manager

**********************
### UPGRADE NOTICE ###

If upgrading from a Library version earlier than 3.1, you will need to update your import statement.

```objective-c
#import <TealiumLibrary/Tealium.h>                  // New import statement
// #import <TealiumiOSLibrary/TealiumiOSTagger.h>   // Legacy import statement
```

NOTE: "TealiumiOSTagger" can still be used as the singleton class type when making shared instance calls:

```objective-c
- (void) myCode{

    // The legacy class works with the updated header, so:
    [[TealiumiOSTagger sharedInstance] trackObject:self title:@"myViewController" customData:nil];
    
    // is the same as using the new class:
    [[Tealium sharedInstance] trackObject:self title:@"myViewController" customData:nil];
}
```
**********************