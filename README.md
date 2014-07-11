Tealium iOS Library - 3.2 & 3.2c
==================================

**********************
![](../../wiki/images/warning_30.png) Upgrading from an earlier version? See the [Upgrade  & Features Notice](#upgrade-&-features-notice)
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
    - [6. Dispatch Verification Options](#6-dispatch-verification-options)
- [What Next](#what-next)
- [Contact Us](#contact-us)

###Requirements###

- [XCode (5.0+ recommended)](https://developer.apple.com/xcode/downloads/)
- Minimum target iOS Version 5.0+

###Quick Start###
This guide presumes you have already created an [iOS app using XCode](https://developer.apple.com/library/iOS/referencelibrary/GettingStarted/RoadMapiOS/index.html).  Follow the below steps to add Tealium's Compact library (3.2c) to it. Discussion on which version is ultimately best for you can be found in the [What Next](#what-next) section.

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

- SystemConfiguration
- CoreTelephony (optional)

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

    [Tealium initSharedInstance:@"tealiummobile" profile:@"demo" target:@"dev"];
    
    // (!) Don't forget to replace "tealiummobile", "demo" and "dev" with your own account-profile-target settings before creating your production build.

}
```

####5. Compile and Run
Your app is now ready to compile and run.  In the console output you should see a variation of:

```objective-c
2014-07-10 17:26:34.661 UICatalog[7812:60b] TEALIUM 3.2c: Initializing...
2014-07-10 17:26:34.851 UICatalog[7812:60b] TEALIUM 3.2c: App Launch detected.
2014-07-10 17:26:34.876 UICatalog[7812:60b] TEALIUM 3.2c: Initialization complete for tealiummobile / demo / dev.
2014-07-10 17:26:35.130 UICatalog[7812:60b] TEALIUM 3.2c: Connection established with https://tags.tiqcdn.com/utag/tealiummobile/demo/dev/mobile.html?ts=16.
2014-07-10 17:26:36.075 UICatalog[7812:60b] TEALIUM 3.2c: Reading remote config...
2014-07-10 17:26:36.093 UICatalog[7812:60b] TEALIUM 3.2c: Webkit ready.
2014-07-10 17:26:36.097 UICatalog[7812:60b] TEALIUM 3.2c: Remote library manager Configuration updated.
2014-07-10 17:26:36.102 UICatalog[7812:60b] TEALIUM 3.2c: Successfully packaged dispatch with Data Sources: (
    "app_id = UICatalog 2.10",
    "app_name = UICatalog",
    "app_rnds = com.example.apple-samplecode.UICatalog",
    "app_version = 2.10",
    "call_eventtype = action",
    "call_type = link",
    "carrier = AT&T",
    "carrier_iso = us",
    "carrier_mcc = 310",
    "carrier_mnc = 410",
    "connection_type = wifi",
    "device = iPhone",
    "device_architecture = 32",
    "device_cputype = ARMV7s",
    "device_language = en",
    "device_resolution = 320x568",
    "library_version = 3.2c",
    "lifecycle_dayofweek_local = 5",
    "lifecycle_dayssincelastwake = 0",
    "lifecycle_dayssincelaunch = 0",
    "lifecycle_dayssinceupdate = 0",
    "lifecycle_firstlaunchdate = 2014-07-10 20:14:57 +0000",
    "lifecycle_firstlaunchdate_MMDDYYYY = 07/10/2014",
    "lifecycle_hourofday_local = 17",
    "lifecycle_lastsimilarcalldate = 2014-07-10 20:23:34 +0000",
    "lifecycle_launchcount = 4",
    "lifecycle_priorsecondsawake = 14580.63316595554",
    "lifecycle_secondsawake = 14580",
    "lifecycle_sleepcount = 0",
    "lifecycle_terminatecount = 0",
    "lifecycle_totallaunchcount = 4",
    "lifecycle_totalsecondsawake = 14580",
    "lifecycle_totalwakecount = 3",
    "lifecycle_type = launch",
    "lifecycle_wakecount = 3",
    "link_id = launch",
    "object_class = TealiumLifecycle",
    "origin = mobile",
    "platform = iOS",
    "platform_version = iOS 7.1.1",
    "status = launch",
    "timestamp = 2014-07-11T00:26:34Z",
    "timestamp_local = 2014-07-10T17:26:34",
    "timestamp_offset = -7",
    "timestamp_unix = 1405038394",
    "uuid = 11EE1056-9C36-4C55-92AB-D67F23FED345"
)
2014-07-10 17:26:36.112 UICatalog[7812:60b] TEALIUM 3.2c: All dispatches sent.
```

Congratulations! You have successfully implemented the Tealium Compact library into your project.  

This line: 
```objective-c
TEALIUM 3.2c: Dispatch successfully PACKAGED with 34 Data Sources:
```
shows how many data sources were detected and available for mapping in Tealium's IQ Dashboard.  The Library only actually sends those data sources and values that are mapped.

If you have disabled internet connectivity to test offline caching, you will see a variation of:
```objective-c
2014-07-10 18:25:57.427 UICatalog[13998:60b] TEALIUM 3.2c: Initializing...
2014-07-10 18:25:57.456 UICatalog[13998:60b] TEALIUM 3.2c: App Launch detected.
2014-07-10 18:25:57.461 UICatalog[13998:60b] TEALIUM 3.2c: Initialization complete for tealiummobile / demo / dev.
2014-07-10 18:25:57.480 UICatalog[13998:1303] TEALIUM 3.2c: NO INTERNET connection detected.
```

####6. Dispatch Verification Options
There are two recommended options to verify dispatches are being sent:

- [AudienceStream Trace](#2-audiencestream-trace)
- HTTP Proxy

*HTTP Proxy*
You can use an HTTP proxy to confirm successful retrieval of configuration data from our multi-CDN and to confirm successful delivery of a tracking call. Several popular third-party options are:

- [Charles Proxy](http://www.charlesproxy.com)
- [Wireshark](http://www.wireshark.org)
- [HTTP Scoop](http://www.tuffcode.com)

Tealium's multi-CDN configuration address is *http://tags.tiqcdn.com*.  You may have to use the [*TLDisableHTTPS*](../../wiki/API-3.x#tealium-options) option when you init the library to permit proxying.

If you have access to the Tealium Community site, detailed instructions on how to setup Charles Proxy on an iDevice can be found at: https://community.tealiumiq.com/posts/624994

To verify dispatches are mapped correctly, received and processed by your target analytic vendors, you will need to review dispatches sent through your vendor's provided dashboard.

If you have not yet chosen a vendor to use, we recommend testing with an analytic service with real-time reporting, such as [Google Analytics](http://www.google.com/analytics/)), for detailed instructions, consult the Tealium community post at: https://community.tealiumiq.com/posts/568700


### What Next###
Now that you've successfully integrated the library, you should now determine if the [Compact or Full Library versions](../../wiki/compact-vs-full) best fit your needs. Below are the key differences:


|     |Compact  |  Full
-------------------------------------|:-------------------------------:|:----:
Library Compile Size                                |~250* KB | ~600* KB
Initialization Time                                 |+1 ms | +1 ms
Memory Usage                                        |+7 MB |+20 MB
[Non-UI AutoTracking](../../wiki/advanced-guide#non-ui-autotracking)  |Yes |  Yes
[UI Autotracking](../../wiki/advanced-guide#ui-autotracking)          |No  |  Yes
[Mobile Companion](../../wiki/advanced-guide#mobile-companion-full-only) |No  |  Yes
[AudienceStream Trace](../../wiki/advanced-guide#audiencestream-trace)   | No | Yes |

(*) The library makes use of Link-Time Optimization, so it's end compile size is dependent on the host application. The numbers listed are the averages from test builds.

(A) Continue with the Compact version, add any needed [additional tracking calls](../../wiki/API-3.x#trackcustomdataas) for events or view appearances.

(B) Switch to the Full version, see our [Basic Implementation Guide](../../wiki/basic-guide), paying attention to the additional setup requirements.

Still can't decide? Browse through our [wiki pages](../../wiki/home) for more info, or read a few mobile related posts in the [TealiumIQ Community](https://community.tealiumiq.com/series/3333) (consult your Tealium Account Manager for access).

###Contact Us###

Questions or comments?

- Post code questions in the [issues page.](../../issues)
- Email us at [mobile_support@tealium.com](mailto:mobile_support@tealium.com)
- Contact your Tealium account manager

**********************
### UPGRADE & FEATURES NOTICE ###

####1. Self Thread Managing
Starting 3.2, the Tealium iOS Library is self thread managing, meaning you can safely make calls to the library from any thread and it will correctly process calls on it's own background thread or on the main thread as needed.

####2. AudienceStream Trace
This feature is now available in the Full Library version starting 3.2 and is accessible through the Mobile Companion feature in the new tools tab. See the [Advanced Guide](../../wiki/advanced-guide#audiencestream-trace) for instructions to enable. Please contact your Tealium account manager to enable AudienceStream for your account.

####3. New Class Level Methods
[Tealium sharedInstance] is no longer needed but will continue to work in version 3.2:

```objective-c
- (void) myCode{

    // The legacy shared instance call:
    [[Tealium sharedInstance] track:self customData:nil as:TealiumEventCall];
    
    // is equal to the new recommended class method:
    [Tealium trackCallType:TealiumEventCall customData:nil object:self];
    
    // Also notice the universal track call has been updated for readability
}
```

####4. Update Import Statement
If upgrading from a version earlier than 3.1, you will need to update your import statement:

```objective-c
// #import <TealiumiOSLibrary/TealiumiOSTagger.h>   // Legacy import statement
#import <TealiumLibrary/Tealium.h>                  // New import statement
```
**********************
