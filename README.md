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



Table of Repo Contents
-------------
- **TealiumiOSLibrary** folder contains all files necessary to run Tealium iOS Tagger in your app
- **TealiumiOSSampleApps** folder contains ARC and nonARC sample apps for reference or to start a project from.  Note: TealiumiOSLibrary files may need to be reimported to test/use
- **TealiumiOSTagger** folder is used by Tealium to test the library and to generate docsets. Can ignore
- **.gitignore** file is a required git file. Can Ignore
- **README.md** file is this document file


Tealium Requirements
--------------------
First, ensure an active Tealium account exists. You will need the following items:
- Your Tealium Account Id (it will likely be your company name)
- The Tealium Profile name to be associated with the app (your account may have several profiles, ideally one of them is dedicated to your iOS app)
- The Tealium environment to use:
  - TealiumTargetProd
  - TealiumTargetQA
  - TealiumTargetDev


Installation
------------
Installation of the TealiumiOSLibrary requires three simple steps:

  1. Add the following frameworks to your project:
      - SystemConfiguration.framework
      - CoreTelephony.framework
      <p></p>
  2. Copy the **TealiumiOSLibrary** folder into your project's source tree. The folder contains the following files:
      - TealiumiOSTagger.h
      - TealiumiOSTagger.m
      - TealiumReachability.h
      - TealiumReachability.m
      <p></p>
  3. Add the TealiumiOSTagger.h to your app's prefix.pch file - in the following block:

  ```objective-c
  #ifdef __OBJC__
      ...
      #import "TealiumiOSTagger.h"
  #endif
  ```

  Note the minimum app deployment target must be iOS 5.0 or higher.


Automatic Reference Counting (ARC)
----------------------------------

The library will work with both ARC based projects and non-ARC based projects.

Dependencies
------------
Tealium utilizes the defacto network-detection library, [Reachability](https://github.com/tonymillion/Reachability). The Tealium iOS Tagger utilizes an ARC-compliant version
of this library. It is based on the original (non-ARC compliant) [library provided by Apple](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html).

The library is already included with the Tealium tagger, so there is no need to download the externally referenced version. 


How To Use
----------------------------------

### Simple Auto-Tracking Setup

The Tagger needs to be setup from within your AppDelegate, ensuring the following message is called:

- initSharedInstance needs to be called from didFinishLaunchingWithOptions


  ```objective-c

  - (BOOL)application:(UIApplication*) application didFinishLaunchingWithOptions:(NSDictionary*) launchOptions
  {
      //depending on how you setup your application, provide a reference to your navigation controller
      UINavigationController *navigationController = ...;
      [TealiumiOSTagger initSharedInstance: @"your_account"
                                   profile:@"your_profile" 
                                   target:@"TealiumTargetEnvironment" 
                     navigationController:navigationController];
     return YES;
  }

  @end

  ```

  The fact that the navigationController is passed into the init method enables the automatic tracking of view displays.
  Therefore if you do nothing else, the Tealium Tagger will track the views each time a view controller is displayed.  

  Note: You may pass **nil** into the navigationController argument which will disable the auto-tracking feature.


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


### UUIDs
Tealium's tagger includes methods to create, retrieve and set a Universally Unique Identifier.  The following method will retrieve the auto-created UUID:

```objective-c
...
    NSString *uuid = [[TealiumiOSTagger sharedInstance] retrieveUUID];
...
```

If you are already implementing your own UUID system, you can set the Tagger's UUID to match:

```objective-c
...
    NSString *yourUUID;
    [[TealiumiOSTagger sharedInstance] setUUID:yourUUID];
...
```


Documentation
-------
To access the tagger class documentation from XCode's Organizer & quick help, copy the **TealiumiOSLibrary** file:
  - com.tealium.TealiumiOSTagger.docset

  into XCode's default docset location:
  - /Users/(user)/Library/Developer/Shared/Documentation/DocSets/

  then restart XCode.


Tealium IQ Hook up Example
--------
This example is for mapping a Google Analytics account to your app through the Tealium Management Console.  This sample presumes you have already done the following:
- Setup a Google analytics account from www.google.com/analytics/
- Have added Tealium tracking code to your project
- Have a Tealium account at www.tealium.com

The steps to properly map data from your app are:

1. Load the Account:Profile:Version that matches the Account and Profile in your *initWithSharedInstance:profile:target:navigationController:* method. Any TealiumIQ version is acceptable.

2. Goto the **Tags** tab and create a new tag - Select Google Analytics

3. Enter your Google Analytics product id into the account id field (usually starts with the letters *UA*-)

4. Goto the **Variables** tab and add 2 variables:  
      - screen_title
      - link_id

  Note: leave them as the default type: Universal Data Object.  *screen_title* are your views' titles.  *link_id* are the custom titles from the *trackItemClicked:withEventData:* methods in your app.
    
5. Goto the **Extensions** tab:
      - add an extension, 
      - goto the *Events* tab
      - click on the *Link Tracking* option
      - close dialog box

  Note: This allows your event data from the *trackItemClicked:withEventData:* methods to be properly read by Google Analytics
    
6. Go back to the **Tags** tab:
      - open the *Google Analytics* option
      - click on the *Edit Variable Mappings* button in the lower-right
      - in the *Add a mapping for:* dropdown - select *screen_title(js)* - click on *Add Mapping* button
      - in the *Add a mapping for:* dropdown - select *link_id(js)* - click on *Add Mapping* button
      - on the *screen_title* row - click on the *Open Tag Mapping Toolbox* button on right - select *Page Name (Override Default)* - Save
      - on the *link_id* row - click on the *Open Tag Mapping Toolbox* button - select *Event Cat* - Save
      - same as above but select *Event Action* - Save
      - same as above but select *Event Label* - Save
      - click on the *Apply* button

  Note: The *link_id* variable needs to be mapped to the Event Category, Action and Labels because Google Analytics requires three levels of categorization.  Alternativelly you can auto set all but one of these fields from the Extensions tab.
    
7. Click on the *Save/Publish* button in the upper-right
      - Enter any *Version Notes* regarding this deployment
      - Select the *Publish Location* that matches the *environmentName* in your *initSharedInstance:profile:target:navigationController:* method

  Note: it may take up to several minutes for your newly published settings to take effect.


Support
-------

For additional help and support, please send all inquires to mobile_support@tealium.com

