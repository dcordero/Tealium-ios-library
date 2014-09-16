Tealium iOS Library - 3.3.1 & 3.3.1c
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

- [XCode (5.1.1+ recommended)](https://developer.apple.com/xcode/downloads/)
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
2014-08-22 11:12:29.109 UICatalog[1519:60b] TEALIUM 3.3: Init settings: {
    AccountInfo =     {
        Account = tealiummobile;
        Profile = demo;
        Target = dev;
    };
    Settings =     {
        AdditionalCustomData =         {
            testK = testV;
        };
        ExcludeClasses =         (
            UIButton
        );
        LogVerbosity = 1;
        UseExceptionTracking = 1;
        UseHTTPS = 1;
    };
}
2014-08-22 11:12:29.109 UICatalog[1519:60b] TEALIUM 3.3: Initializing...
2014-08-22 11:12:29.133 UICatalog[1519:3e13] TEALIUM 3.3: Network is available.
2014-08-22 11:12:29.133 UICatalog[1519:60b] TEALIUM 3.3: Mobile Companion Enabled and listening.
2014-08-22 11:12:29.253 UICatalog[1519:60b] TEALIUM 3.3: Connection established with https://tags.tiqcdn.com/utag/tealiummobile/demo/dev/mobile.html?platform=iOS&os_version=7.1&library_version=3.3&ts=61.
2014-08-22 11:12:29.332 UICatalog[1519:60b] TEALIUM 3.3: Reading remote config...
2014-08-22 11:12:29.357 UICatalog[1519:60b] TEALIUM 3.3: Tags found - UTAG ready.
2014-08-22 11:12:29.357 UICatalog[1519:60b] TEALIUM 3.3: Initialized.
2014-08-22 11:12:29.357 UICatalog[1519:60b] TEALIUM 3.3: App Launch detected.
2014-08-22 11:12:29.362 UICatalog[1519:60b] TEALIUM 3.3: Successfully packaged link dispatch for TealiumLifecycle : launch : 2014-08-22T11:12:29
2014-08-22 11:12:29.642 UICatalog[1519:60b] TEALIUM 3.3: Successfully packaged view dispatch for MainViewController : appeared : 2014-08-22T11:12:29
```

Congratulations! You have successfully implemented the Tealium Compact library into your project.  

If you have disabled internet connectivity to test offline caching, you will see a variation of:
```objective-c
2014-08-22 14:12:40.774 UICatalog[1589:60b] TEALIUM 3.3c: Init settings: {
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
2014-08-22 14:12:40.776 UICatalog[1589:60b] TEALIUM 3.3c: Initializing...
2014-08-22 14:12:40.807 UICatalog[1589:60b] TEALIUM 3.3c: No saved remote library manager configuration found.
2014-08-22 14:12:40.807 UICatalog[1589:3e13] TEALIUM 3.3c: Network is not available.
2014-08-22 14:12:40.827 UICatalog[1589:60b] TEALIUM 3.3c: NO INTERNET connection detected.
2014-08-22 14:12:40.828 UICatalog[1589:60b] TEALIUM 3.3c: Library will continue running with last recorded settings & will queue calls until connection is re-established.
2014-08-22 14:12:40.828 UICatalog[1589:60b] TEALIUM 3.3c: Initialized.
2014-08-22 14:12:40.828 UICatalog[1589:60b] TEALIUM 3.3c: Firing pre-init queue.
2014-08-22 14:12:40.828 UICatalog[1589:60b] TEALIUM 3.3c: App Launch detected.
2014-08-22 14:12:40.833 UICatalog[1589:3d07] TEALIUM 3.3c: Queued view dispatch for MainViewController : appeared : 2014-08-22T14:12:40. 1 dispatch queued.
2014-08-22 14:12:40.834 UICatalog[1589:60b] TEALIUM 3.3c: Queued link dispatch for TealiumLifecycle : launch : 2014-08-22T14:12:40. 2 dispatches queued.
```

####6. Dispatch Verification Options
There are two recommended options to verify dispatches are being sent:

- [AudienceStream Trace](#2-audiencestream-trace)
- Safari Web Inspector
- HTTP Proxy

*Safari Web Inspector
A device with the Settings:Safari:Web Inspector option, connected to an OS X machine with Safari can directly interact with the webkit object within the library. Additional info on how to enable this can be found at [this site](http://webdesign.tutsplus.com/articles/quick-tip-using-web-inspector-to-debug-mobile-safari--webdesign-8787).  A special extension can also be added in your TIQ publish to enable debug output into this web inspection. Consult your account manager for details.

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
[UI Autotracking](../../wiki/advanced-guide#ui-autotracking-full-only)          |No  |  Yes
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
### UPGRADE NOTICE ###

####1. iOS 8 Support
3.3.1 Has been tested to work with iOS 8 as the deployment target. Sample apps updated.

####2. Exclusion Feature
Starting 3.3, Object classes can be excluded from the library's tracking system by specifying classes in an app's [info.plist](../../wiki/advanced-guide#exclude-classes-from-tracking) dictionary.

####3. Recent Bug Fixes
- Disable & Enable calls working properly
- Manual track calls firing as expected with event call type overrides

####4. Self Thread Managing
Starting 3.2, the Tealium iOS Library is self thread managing, meaning you can safely make calls to the library from any thread and it will correctly process calls on it's own background thread or on the main thread as needed.

####5. AudienceStream Trace
Starting 3.2, this feature is available in the Full Library version and is accessible through the Mobile Companion feature in the new tools tab. See the [Advanced Guide](../../wiki/advanced-guide#audiencestream-trace) for instructions to enable. Please contact your Tealium account manager to enable AudienceStream for your account.

####6. New Class Level Methods
Starting 3.1, [Tealium sharedInstance] is no longer needed but will continue to work through version 3.3:

```objective-c
- (void) myCode{

    // The legacy shared instance call:
    [[Tealium sharedInstance] track:self customData:nil as:TealiumEventCall];
    
    // is equal to the new recommended class method:
    [Tealium trackCallType:TealiumEventCall customData:nil object:self];
    
    // Also notice the universal track call has been updated for readability
}
```

####7. Update Import Statement
If upgrading from a version earlier than 3.1, you will need to update your import statement:

```objective-c
// #import <TealiumiOSLibrary/TealiumiOSTagger.h>   // Legacy import statement
#import <TealiumLibrary/Tealium.h>                  // New import statement
```
**********************
