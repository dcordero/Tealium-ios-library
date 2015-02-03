Tealium iOS Library - 4.1.1 & 4.1.1c
====================================

**********************
![](../../wiki/images/warning_30.png) Upgrading from an earlier version? See the [Upgrade Notice](#upgrade-notice)
**********************

###Brief###
The frameworks included allow the native tagging of a mobile application once and then configuration of third-party analytic services remotely through [Tealium IQ](http://tealium.com/products/enterprise-tag-management/); all without needing to recode and redeploy an app for every update to these services.

First time implementations should read the [How Tealium Works](../../wiki/how-tealium-works) wiki page for a brief overview of how Tealium's SDK differs from conventional analytic SDKs. For any additional information, consult the [wiki home page](../../wiki/home).

The remainder of this document provides quick install instructions for implementing the less memory intensive Compact library.

###Table of Contents###

- [Requirements](#requirements)
- [Quick Start](#quick-start)
    - [1. Clone/Copy Library](#1-clonecopy-library)
    - [2. Add to Project](#2-add-to-project)
    - [3. Link Frameworks](#3-link-frameworks)
    - [4o. Import and Init - Objective-C](#4o-import-and-init-objective-c)
    - [4s. Import and Init - Swift](#4s-import-and-init-swift)
    - [5. Compile and Run](#5-compile-and-run)
    - [6. Dispatch Verification](#6-dispatch-verification)
- [What Next](#what-next)
- [Contact Us](#contact-us)

###Requirements###

- [XCode (6.0+ recommended)](https://developer.apple.com/xcode/downloads/)
- Minimum target iOS Version 5.1.1+

###Quick Start###
This guide presumes you have already created an [iOS app using XCode](https://developer.apple.com/library/iOS/referencelibrary/GettingStarted/RoadMapiOS/index.html).  Follow the below steps to add [Tealium's Compact library](../../wiki/compact-vs-full#compact) to it. Discussion on which version is ultimately best for you can be found in the [What Next](#what-next) section.

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

####4o. Import and Init Objective-C
4o1. Import the library into your project's .pch file into the following block:

```objective-c
#ifdef __OBJC__
    //...

    #import <TealiumLibrary/Tealium.h>
#endif
```

4o2. Init the library in your appDelegate.m class:
```objective-c
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    //...

    [Tealium initSharedInstance:@"tealiummobile" profile:@"demo" target:@"dev"];
    
    // (!) Don't forget to replace "tealiummobile", "demo" and "dev" with your own account-profile-target settings before creating your production build.

}
```

####4s. Import and Init Swift
4s1. Import Tealium-bridging-header.h

![](../../wiki/images/swift_bridging_header.png)

4s2. Update Project’s Build Settings: Swift Compiler - Code Generation:
- Install objective-C Header: Yes
- Objective-C Bridging Header: (path to the bridging-header)

![](../../wiki/images/swift_compiler_code.png)

4s3. Add Init statement: 

```swift
Tealium.initSharedInstance("tealiummobile", profile: "demo", target: "dev", options:TealiumOptions.TLNone, globalCustomData: nil)
```

![](../../wiki/images/swift_init.png)


####5. Compile and Run
Your app is now ready to compile and run.  In the console output you should see a variation of:

```objective-c
2014-10-07 07:41:45.944 UICatalog_TealiumFullLibrary[27003:861852] TEALIUM 4.0: Init settings: {
    AccountInfo =     {
        Account = tealiummobile;
        Profile = demo;
        Target = dev;
    };
    Settings =     {
        AdditionalCustomData =         {
        };
        ExcludeClasses =         (
        );
        LogVerbosity = 1;
        UseExceptionTracking = 1;
        UseHTTPS = 1;
    };
}
2014-10-07 07:41:45.945 UICatalog_TealiumFullLibrary[27003:861852] TEALIUM 4.0: Initializing...
2014-10-07 07:41:46.101 UICatalog_TealiumFullLibrary[27003:861966] TEALIUM 4.0: Network is available.
2014-10-07 07:41:46.386 UICatalog_TealiumFullLibrary[27003:861852] TEALIUM 4.0: Connection established with mobile.html at https://tags.tiqcdn.com/utag/tealiummobile/demo/dev/mobile.html?platform=iOS&os_version=8.0&library_version=4.0&ts=27.
2014-10-07 07:41:46.722 UICatalog_TealiumFullLibrary[27003:861964] TEALIUM 4.0: Queued view dispatch for MainViewController : appeared : 2014-10-07T07:41:46. 1 dispatch queued.
2014-10-07 07:41:46.727 UICatalog_TealiumFullLibrary[27003:861963] TEALIUM 4.0: Queued view dispatch for UIInputWindowController : appeared : 2014-10-07T07:41:46. 2 dispatches queued.
2014-10-07 07:41:46.885 UICatalog_TealiumFullLibrary[27003:861852] TEALIUM 4.0: UTAG Tags found in mobile.html: true
2014-10-07 07:41:46.885 UICatalog_TealiumFullLibrary[27003:861852] TEALIUM 4.0: Utag found. Reading remote config...
2014-10-07 07:41:46.886 UICatalog_TealiumFullLibrary[27003:861852] TEALIUM 4.0: Initialized.
2014-10-07 07:41:46.887 UICatalog_TealiumFullLibrary[27003:861852] TEALIUM 4.0: App Launch detected.
2014-10-07 07:41:46.891 UICatalog_TealiumFullLibrary[27003:861852] TEALIUM 4.0: Successfully packaged link dispatch for TealiumLifecycle : launch : 2014-10-07T07:41:46
```

Congratulations! You have successfully implemented the Tealium Compact library into your project.  

If you have disabled internet connectivity to test offline caching, you will see a variation of:
```objective-c
2014-10-07 07:43:22.230 UICatalog_TealiumFullLibrary[27046:863369] TEALIUM 4.0: Init settings: {
    AccountInfo =     {
        Account = tealiummobile;
        Profile = demo;
        Target = dev;
    };
    Settings =     {
        AdditionalCustomData =         {
        };
        ExcludeClasses =         (
        );
        LogVerbosity = 1;
        UseExceptionTracking = 1;
        UseHTTPS = 1;
    };
}
2014-10-07 07:43:22.231 UICatalog_TealiumFullLibrary[27046:863369] TEALIUM 4.0: Initializing...
2014-10-07 07:43:22.337 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: Network is not available.
2014-10-07 07:43:22.355 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: NO INTERNET connection detected.
2014-10-07 07:43:22.355 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: Trying to reconnect (attempt 1 of 3)...
2014-10-07 07:43:22.761 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: 2 saved dispatches loaded.
2014-10-07 07:43:22.761 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: Queued view dispatch for MainViewController : appeared : 2014-10-07T07:43:22. 3 dispatches queued.
2014-10-07 07:43:22.768 UICatalog_TealiumFullLibrary[27046:863407] TEALIUM 4.0: Queued view dispatch for UIInputWindowController : appeared : 2014-10-07T07:43:22. 4 dispatches queued.
2014-10-07 07:43:23.362 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: NO INTERNET connection detected.
2014-10-07 07:43:23.363 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: Trying to reconnect (attempt 2 of 3)...
2014-10-07 07:43:24.366 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: NO INTERNET connection detected.
2014-10-07 07:43:24.366 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: Trying to reconnect (attempt 3 of 3)...
2014-10-07 07:43:25.461 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: NO INTERNET connection detected.
2014-10-07 07:43:25.462 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: Saved configuration loaded: false
2014-10-07 07:43:25.462 UICatalog_TealiumFullLibrary[27046:863408] TEALIUM 4.0: Using default tracking configuration.
```

####6. Dispatch Verification
The two recommended methods for dispatch verification are:

- AudienceStream Live Events
- Vendor Dashboard

AudienceStream live events provides real time visualization of dispatched data if the Tealium DataCloud Tag has been added the same TIQ account-profile used to init the library:

![](../../wiki/images/EventStore.png)

An analytic vendor with real time processing, such as [Google Analytics](http://www.google.com/analytics/)), can also be used to verify dispatches if the data sources have been properly mapped to the target vendors' variables. 

Note: vendors without real-time processing may take up to several hours to update their reporting.


### What Next###
Now that you've successfully integrated the library, you should now determine if the [Compact or Full Library versions](../../wiki/compact-vs-full) best fit your needs. Below are the key differences:


|                                                                       | Compact | Full |
|-----------------------------------------------------------------------|:-------:|:-------:|
| Library Compile Size                                                  | ~600 KB | ~900 KB |
| Initialization Time                                                    | +<1 ms | +<1 ms |
| Runtime Memory Usage                                                  | +3.3 MB |+5.0 MB |
| [Custom Data Tracking](../../wiki/features#custom-data-tracking)          | Yes | Yes |
| [Device Data Tracking](../../wiki/features#device-data-tracking)          | Yes | Yes |
| [Lifecycle Tracking](../../wiki/features#lifecycle-tracking)              | Yes | Yes |
| [Offline Tracking](../../wiki/features#offline-tracking)                  | Yes | Yes |
| [Tag Bridge](../../wiki/advanced-guide#tag-bridge)                        | Yes | Yes |
| [Timestamp Tracking](../../wiki/features#timestamp-tracking)              | Yes | Yes |
| [AudienceStream Trace](../../wiki/advanced-guide#audiencestream-trace)    | No  | Yes |
| [Mobile Companion](../../wiki/advanced-guide#mobile-companion-full-only)  | No  | Yes |
| [UI Autotracking](../../wiki/features#optional-ui-tracking)               | No  | Yes |
| [Video Tracking](../../wiki/features#video-event-tracking)                | No  | Yes |
 

(A) Continue with the Compact version, add any needed [additional tracking calls](../../wiki/API-4.x#trackcalltypecustomdataobject) for events or view appearances.

(B) Switch to the Full version, see our [Basic Implementation Guide](../../wiki/basic-guide), paying attention to the additional setup requirements.

Still can't decide? Browse through our [wiki pages](../../wiki/home) for more info, or read a few mobile related posts in the [TealiumIQ Community](https://community.tealiumiq.com/series/3333) (consult your Tealium Account Manager for access).

###Contact Us###

Questions or comments?

- Post code questions in the [issues page.](../../issues)
- Email us at [mobile_support@tealium.com](mailto:mobile_support@tealium.com)
- Contact your Tealium account manager

**********************
### UPGRADE NOTICE ###

####New Features
- 4.1.1 Remove custom data APIs added
- 4.1   [Tag Bridge API](../../wiki/features#tag-bridge-api) added
- 4.1   Swift Bridging Header provided
- 4.0   Remote configuration options found in TIQ's new mobile publish settings now supported
- 3.3.1 iOS 8.0+ support added
- 3.3   Autotracking [Class Exclusion](../../wiki/advanced-guide#exclude-classes-from-tracking) support added
- 3.2   Self thread managing added - library calls can safely be made from any thread.
- 3.2   [Audience Stream Trace]{../../wiki/advanced-guide#audiencestream-trace) support added
- 3.1   [Class Level Methods](../../wiki/api-4.x#class-methods) replaced older shared instance calls
- 3.1   Import header renamed to ``<TealiumLibrary/Tealium.h>``

####Recent Code Updates
- 4.1.1 Strict data source lowercasing removed
- 4.1.1 Queuing & dispatch system updates
- 4.1.1 Swift Bridging Header cleaned
- 4.1.1 Wifi only toggle now being properly respected
- 4.1.1 Lifecycle data reporting fixes
- 4.1.1 Minor TagBridge compatibility fixes
- 4.1   Direct custom data accesses replaced with thread-safe [read and write methods](../../wiki/API-4.x#addcustomdatatoobject)
- 4.1   Dispatch data key lowercasing now strictly enforced
- 4.0.6 Armv7s slice reintroduced, improved Mobile Companion unlock, log outputs, thread handling and low-memory handling 
- 4.0.5 Improved configuration via TIQ & header documentation
- 4.0.4 Stability enchancements
- 4.0.2 & 4.0.3 iOS 8.1 Support and additional performance optimizations
- 4.0.1 Fixed bug in autotracking performance optimizations, disable & enable call fixes, manual track calls firing as expected with event call type overrides

**********************
