Tealium iOS Library - 3.2 & 3.2c
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
2014-07-03 11:05:32.183 UICatalog[5794:1803] TEALIUM 3.2c: Initializing...
2014-07-03 11:05:32.411 UICatalog[5794:60b] TEALIUM 3.2c: Waking Up.
2014-07-03 11:05:32.412 UICatalog[5794:60b] TEALIUM 3.2c: Launch detected.
2014-07-03 11:05:32.435 UICatalog[5794:60b] TEALIUM 3.2c: Enabled for tealiummobile / demo / dev.
2014-07-03 11:05:33.065 UICatalog[5794:60b] TEALIUM 3.2c: Connection established with https://tags.tiqcdn.com/utag/tealiummobile/demo/dev/mobile.html?ts=50.
2014-07-03 11:05:33.947 UICatalog[5794:60b] TEALIUM 3.2c: Reading remote config...
2014-07-03 11:05:33.969 UICatalog[5794:60b] TEALIUM 3.2c: Webkit ready.
2014-07-03 11:05:33.980 UICatalog[5794:60b] TEALIUM 3.2c: Remote library manager Configuration updated.
2014-07-03 11:05:33.997 UICatalog[5794:60b] TEALIUM 3.2c: Successfully packaged dispatch with Data Sources: (
    "app_id = UICatalog 2.10",
    "app_name = UICatalog",
    "app_rnds = com.example.apple-samplecode.UICatalog",
    "app_version = 2.10",
    "autotracked = true",
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
    "ivar_accessibilityActivationPoint = NSConcreteValue",
    "ivar_accessibilityElementsHidden = 0",
    "ivar_accessibilityFrame = NSConcreteValue",
    "ivar_accessibilityTraits = 0",
    "ivar_accessibilityViewIsModal = 0",
    "ivar_dispatchBlock = __NSMallocBlock__",
    "ivar_isAccessibilityElement = 0",
    "ivar_shouldGroupAccessibilityChildren = 0",
    "library_version = 3.2c",
    "lifecycle_dayofweek_local = 5",
    "lifecycle_dayssincelastwake = 0",
    "lifecycle_dayssincelaunch = 6",
    "lifecycle_dayssinceupdate = 0",
    "lifecycle_firstlaunchdate = 2014-06-27 05:02:16 +0000",
    "lifecycle_firstlaunchdate_MMDDYYYY = 06/26/2014",
    "lifecycle_hourofday_local = 11",
    "lifecycle_lastsimilarcalldate = 2014-07-02 21:52:51 +0000",
    "lifecycle_launchcount = 51",
    "lifecycle_priorsecondsawake = 72761.02707201242",
    "lifecycle_secondsawake = 0",
    "lifecycle_sleepcount = 12",
    "lifecycle_terminatecount = 0",
    "lifecycle_totallaunchcount = 51",
    "lifecycle_totalsecondsawake = 440",
    "lifecycle_totalsleepcount = 12",
    "lifecycle_totalwakecount = 62",
    "lifecycle_type = launch",
    "lifecycle_wakecount = 62",
    "link_id = TealiumLifecycle: launch",
    "object_class = TealiumLifecycle",
    "origin = mobile",
    "platform = iOS",
    "platform.version = iOS 7.1.1",
    "status = launch",
    "timestamp = 2014-07-03T18:05:32Z",
    "timestamp_local = 2014-07-03T11:05:32",
    "timestamp_offset = -7",
    "timestamp_unix = 1404410732",
    "uuid = 9676C3BA-B618-4833-A206-73EC5D22994Dâ€
)
2014-07-03 11:05:34.007 UICatalog[5794:60b] TEALIUM 3.2c: All dispatches sent.
```

Congratulations! You have successfully implemented the Tealium Compact library into your project.  

This line: 
```objective-c
TEALIUM 3.2c: Dispatch successfully PACKAGED with 34 Data Sources:
```
shows how many data sources were detected and available for mapping in Tealium's IQ Dashboard.  The Library only actually sends those data sources and values that are mapped.

If you have disabled internet connectivity to test offline caching, you will see a variation of:
```objective-c
2014-07-03 11:08:16.007 UICatalog[5803:1803] TEALIUM 3.2c: Initializing...
2014-07-03 11:08:16.212 UICatalog[5803:60b] TEALIUM 3.2c: Waking Up.
2014-07-03 11:08:16.213 UICatalog[5803:60b] TEALIUM 3.2c: Launch detected.
2014-07-03 11:08:16.238 UICatalog[5803:60b] TEALIUM 3.2c: Enabled for tealiummobile / demo / dev.
2014-07-03 11:08:16.364 UICatalog[5803:1803] TEALIUM 3.2c: NO INTERNET connection detected.
```

####6. Dispatch Verification Options
There are two recommended options to verify dispatches are being sent:

- AudienceStream Mobile Trace
- HTTP Proxy

*Mobile Trace* 
This feature has been added to the Full Library version starting 3.2 and is accessible through the Mobile Companion feature.  Please contact your Tealium account manager for detailed instructions.

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
Library Compile Size                                |~350 KB | ~550 KB
Initialization Time                                 |+0.001 sec | +0.001 sec
Memory Usage                                        |+7 MB |+20 MB
[Non-UI AutoTracking](../../wiki/advanced-guide#non-ui-autotracking)  |Yes |  Yes
[UI Autotracking](../../wiki/advanced-guide#ui-autotracking)          |No  |  Yes
[Mobile Companion](../../wiki/advanced-guide#mobile-companion-full-only) |No  |  Yes
Mobile Trace                                        | No | Yes |

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

####1. Upgrading from version earlier than 3.1, you will need to update your import statement.

```objective-c
#import <TealiumLibrary/Tealium.h>                  // New import statement
// #import <TealiumiOSLibrary/TealiumiOSTagger.h>   // Legacy import statement
```

####2. [Tealium sharedInstance] is no longer needed but will continue to work in version 3.2:

```objective-c
- (void) myCode{

    // The legacy shared instance call:
    [[Tealium sharedInstance] track:self customData:nil as:nil];
    
    // is equal to the new recommended class method:
    [Tealium trackCallType:nil customData:nil object:self];
}
```
**********************