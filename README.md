Tealium iOS Tagger
==================

This library provides Tealium customers the means to tag their native
iOS applications for the purpose of leveraging the vendor-neutral tag management
platform offered by Tealium.  

It provides:

- web-analytics integration via the Tealium platform
- automatic view controller tracking, similar to traditional web page tracking, utilizing your favorite analytics vendor
- intelligent network-sensitive caching
- simple to use messages, including singleton or dependency-injection-friendly instances.
- custom action tracking
- implemented with the user in mind. All tracking calls are asynchronous as to not interfere or degrade the user experience. 


Tealium Requirements
--------------------
First, ensure an active Tealium account exists. You will need the following items:
- Your Tealium Account Id (it will likely be your company name)
- The Tealium Profile name to be associated with the app (your account may have several profiles, ideally one of them is dedicated to your iOS app)
- The Tealium environment to use:
  - TealiumTargetProd
  - TealiumTargetQA
  - TealiumTargetDev

Automatic Reference Counting (ARC)
----------------------------------

The library will work with both ARC based projects and non-ARC based projects.

Dependencies
------------
Tealium utilizes the defacto network-detection library, [Reachability](https://github.com/tonymillion/Reachability). The Tealium iOS Tagger utilizes an ARC-compliant version
of this library. It is based on the original (non-ARC compliant) [library provided by Apple](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html).

The library is already included with the Tealium tagger, so there is no need to download the externally referenced version. 

Installation
------------
At this time, the simplest installation of the tagger is to include the following files in your project's source tree:

- TealiumiOSTagger.h
- TealiumiOSTagger.m
- TealiumReachability.h
- TealiumReachability.m

How To Use
----------------------------------

### Simple Tagger Setup

The Tagger needs to be setup from within your AppDelegate, ensuring the following messages are called from within in the various lifecycle methods:

- initInstance needs to be called from didFinishLaunchingWithOptions
- sleep should be called from applicationWillResignActive *and* applicationWillTerminate
- wakeUp should be called from applicationDidBecomeActive or applicationWillEnterForeground


```objective-c

#import "TealiumiOSTagger.h"

@implementation MyDelegate

- (BOOL)application:(UIApplication*) application didFinishLaunchingWithOptions:(NSDictionary*) launchOptions
{
    //depending on how you setup your application, provide a reference to your navigation controller
    UINavigationController *navigationController = ...;
    TealiumiOSTagger* tagger = [TealiumiOSTagger initSharedInstance: @"your_account"
        profile:@"your_profile" target: TealiumTargetDev navigationController:navigationController];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication*) application {
    [[TealiumiOSTagger sharedInstance] sleep];
}

- (void)applicationDidEnterBackground:(UIApplication*) application {
    [[TealiumiOSTagger sharedInstance] sleep];
}

- (void)applicationDidBecomeActive:(UIApplication*) application {
    [[TealiumiOSTagger sharedInstance] wakeUp];
}

- (void)applicationWillTerminate:(UIApplication*) application {
     [[TealiumiOSTagger sharedInstance] sleep];
}

@end

```

NOTE: don't worry about all the calls to sleep. The tagger library is idempotent,
therefore is smart enough to only perform the sleep code once in the case it is called multiple times.


The fact that the navigationController is passed into the init method enables the automatic tracking of view displays.
Therefore if you do nothing else, the Tealium Tagger will track the views each time a view controller is displayed.  

### Custom Item Click Tracking

The Tealium Tagger is capable of tracking any action occurring within the app utilizing this simple method:

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
Support
-------

For additional help and support, please send all inquires to mobile_support@tealium.com

