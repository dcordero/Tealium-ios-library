//
//  TealiumiOSTagger.h
//
//  Created by Charles Glommen.
//  Extended by Gautam Day & Jason Koo
//  Copyright (c) 2013 Tealium, Inc. All rights reserved.

#import <CoreFoundation/CoreFoundation.h>
#import <objc/runtime.h>
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>

/**
 Version: 2.2
 Minimum iOS Version: 5.0+
 Brief: The is the primary TealiumiOS library class object for tracking analytics data on iOS devices.  The included methods are the only public methods needed to initialize, configure and run the library.
 
 Quick install Instructions
 
 1. Link the following frameworks to your project:
 
    * AVFoundation.framework          (for tracking AVPlayer video objects)
    * CoreMotion.framework            (for mobile companion unlock detection)
    * CoreMedia.framework             (for tracking play times of video objects)
    * CoreTelephony.framework         (for device carrier detection)
    * MediaPlayer.framework           (for tracking MPMoviePlayer video objects)
    * SystemConfiguration.framework   (for connectivity verification)
 
 2. Add the class level init method (initSharedInstance:profile:target:rootController:) to your app delegate or wherever your primary root controller is initialized
 
 3. Add "#import <TealiumTealiumiOSLibrary/TealiumiOSTagger.h>" to your -Prefix.pch file, within the #ifdef __OBJC__ statement for app wide access
 
 Additional Information
 
 See the github Readme.md file at: https://github.com/Tealium/ios-library (requires a valid Tealium account to access) for the full developer instruction set and for a partical list of automatically tracked default data sources.
 
 Checkout mobile articles at community.tealiumiq.com (requires approved acount access) for the most recent information, including an up-to-date list of all automatically tracked default data sources .
  
 */

@interface TealiumiOSTagger : NSObject

/**
 Set these properties to enable/disable particular console log reports. displayConciseLogs + displayErrorLogs are on by default.
 */
@property BOOL displayConciseLogs;
@property BOOL displaySkipLogs;
@property BOOL displayErrorLogs;
@property BOOL displayVerboseLogs;
@property BOOL displayLifecycleLogs;

/**
 Delay after a tappable object has fired that library should wait before re-scanning all objects on view to update auto tracking. If you have animations that result in new interface objects appearing, this delay should be longer than those animations. Default delay is 1.0 seconds.
 */
@property float postClickRefreshDelay;

#pragma mark - INITIALIZATION
/**
 Recommended Class-level init method.
 
 @warning Class-level messages are convenience messages for when a single account/profile/environment context exists. However, if more than one tealium context is needed (unlikely), or a dependency injection framework is already employed, it is recommended to directly utilize the instance init message init:profile:target:rootController:. Autotracking is enabled by default using this method.
 @param accountName Name of Tealium account
 @param profileName Target Account profile
 @param environmentName Target profile environment (dev, qa, etc.)
 @param rootController The root UIViewController, UINavigationController, UISplitViewController or UITabBarController. If nil is passed, iosTagger will attempt to determine your root controller.
 */
+ (TealiumiOSTagger*) initSharedInstance: accountName
                                 profile: (NSString*) profileName
                                  target: (NSString*) environmentName
                          rootController: (id) rootController;

+ (TealiumiOSTagger *) sharedInstance;

/**
 Optional initialization method if needing to track a UINavigationController, UISplitViewController, UITabBarController or UIViewController and not using the class method or if using a custom view controller hiearchy outside of the class methods ability to track (ie modals).
 
 @warning Class-level messages are convenience messages for when a single account/profile/environment context exists. However, if more than one tealium context is needed (unlikely), or a dependency injection framework is already employed, it is recommended to directly utilize the instance init message init:profile:target:navigationController:
 @param accountName Name of Tealium account
 @param profileName Target Account profile
 @param environmentName Target profile environment (dev, qa, etc.)
 @param rootController Root view controller. May be a UINavigationController, UITabeBarController or UISplitViewController. If parameter passed is nil then autoTracking will be disabled.
 */
- (TealiumiOSTagger*) init: (NSString*) accountName
                   profile: (NSString*) profileName
                    target: (NSString*) environmentName
            rootController: (id) rootController;

#pragma mark - LEGACY INITIALIZATION METHODS

/**
 (Deprecated. Use initSharedInstanceWithRootController: instead)
 
 @warning Class-level messages are convenience messages for when a single account/profile/environment context exists. However, if more than one tealium context is needed (unlikely), or a dependency injection framework is already employed, it is recommended to directly utilize the instance init message init:profile:target:navigationController:
 @param accountName Name of Tealium account
 @param profileName Target Account profile
 @param environmentName Target profile environment (dev, qa, etc.)
 @param firstNavigationController Root navigation controller. If parameter passed is nil then autoTracking will be disabled.
 */
+ (TealiumiOSTagger*) initSharedInstance: accountName
profile: (NSString*) profileName
target: (NSString*) environmentName
navigationController: (UINavigationController*) firstNavigationController __attribute__((deprecated));

/**
 (Deprecated. Use initSharedInstance:profile:target:rootController: instead)
 
 @warning convenience message for when a single account/profile/environment context exists. However, if more than one tealium context is needed (unlikely), or a dependency injection framework is already employed, it is recommended to directly utilize the instance init message init:profile:target:navigationController:.
 @param accountName Name of Tealium account
 @param profileName Target Account profile
 @param environmentName Target profile environment (dev, qa, etc.)
 @param firstNavigationController Root navigation controller
 */
+ (TealiumiOSTagger *) initInstance: accountName profile:(NSString*) profileName target:(NSString*) environmentName navigationController: (UINavigationController*) firstNavigationController __attribute__((deprecated));

/**
 (Deprecated. Use +(TealiumiOSTagger*)sharedInstance instead)
 */
+ (TealiumiOSTagger *) getInstance __attribute__((deprecated));

/**
 (Deprecated. Use -(TealiumiOSTagger*)init:profile:target:rootController: instead)
 
 Optional initialization method if needing to track more than one UINavigationController hierarchy.
 
 @warning This init message is optional. The API user should choose between explicitly sending this init message or simply using the class-level messages above, initInstance and getInstance. Unless a dependency injection framework is used, it is recommended to simply use the class messages.
 @param accountName Name of Tealium account
 @param profileName Name of Tealium account profile to attach tagger singleton to
 @param environmentName Target Tealium enviornment (dev, qa, etc.)
 @param navigationController Root navigation controller
 */
- (TealiumiOSTagger *) init:(NSString*) accountName profile:(NSString*) profileName target:(NSString*) environmentName navigationController: (UINavigationController*) navigationController __attribute__((deprecated));


#pragma mark - OPTIONAL COMMANDS
/**
 Force the library to check for any updated published configuration settings.  Note: If the power save mode is on, it will fire off any queued calls at this time.
 */
- (void) checkForNewPublishedSettings;

/**
 Force the library to rescan the root controller for autotrackable objects.  This call is recommended after any custom delegate reassignments so that the library can update it's delegate tracking.
 */
- (void) rescan;

/**
 Puts Tealium tagger to permenant sleep. This is an optional method if your app has a manual option for users to disable analytic tracking. Enable must be called to reactivate.
 */
- (void) disable;

/**
 To re-enable the library from a disable call.
 */
- (void) enable;

/**
 Disables the autotracking feature.  NOTE: This will automatically suppress Mobile Companion as well.
 */
- (void) disableAutotracking;

/**
 To re-enable the autotracking system.
 */
- (void) enableAutotracking;

/**
 Unlocks all mobile companion security stages.  Use this method to enable mobile companion testing in the simulator or for debugging.  This method is auto-suppressed if 
 1) your account target environment is NOT set to "dev" 
 2) your iOS Library Manager extension setting for Mobile Companion has been set to "off".
 3) autotracking has been disabled
 */
- (void) unlockMobileCompanion;


/**
 Suppresses all logs from library operations, except for Initialization and Error logs.
 */
- (void) suppressTealiumLogs;

#pragma mark - AUTOTRACKING METHODS

/*
 TEALIUM API MESSAGES
 Following are the Tealium messages available to API users. 
 
 If auto tracking navigation controller(s) is on (default is on), there is no
 need to use either of the trackScreenViewed_* messages, unless a view is being displayed
 which is not controlled by a navigation controller.
 
 See the README on the github repo for samples.
 */

/**
 Manually call if you are invoking a modal view or other view that is not apart of the rootController's view hierarchy.
 
 @param viewController Accepts a UIViewController, UINavigationController, UITabBarController, UISplitViewController OR a NSNotification if the notifications object is one of the previously mentioned view controller types.
 */
-(void) autoTrackController:(id)viewController;

/**
 Deprecated method for auto-tracking multiple UINavigationControllers. Recommend using autoTrackController:
 
 @warning Only needs to be used when more than one navigationController
 should be tracked. The first (and main) one is already passed in with the init methods above.
 @param navigationController Navigtation controller to track
 */
- (void) autoTrackNavigationController: (UINavigationController*) navigationController __attribute__((deprecated));
/*
 Use this method to autotrack objects that are not automatically detected by the library's scanning method (ie Modally or storyboard only UI objects)
 @param obj Object to track
 @param tealiumId Tealium Reference ID of object to track.  TealiumId is optional. If nil passed in, then a TealiumId may be assigned to it by the library if it is able to scan it later. Library assigned TealiumIds are always 5 digit alphanumerics. If assigning use 6 or more alphanumberic characters to avoid namespace collisions.
 */
- (void) autoTrackObject:(id)obj tealiumId:(NSString*)tealiumId;

/**
 Track video player milestones
 @param milestones NSArray of percent video completed as NSNumber floats (0.5 = halfway, 1.0 = finished). Does not need to be ordered.
 @param object The AVPlayerItem, AVPlayer, MPMoviePlayerViewController or MPMoviePlayerController to add milestone tracking to.
 */
- (void) autoTrackVideoDurationPercentMilestones:(NSArray*)milestones of:(id)object;

/**
 Exclude an entire class of objects and their subclasses from the autotracking system. Case sensitive.
 @param className NSString representation of an object Class name (ie UIButton)
 */
- (void) excludeClassFromAutotracking:(NSString*)className;

/*
 Exclude multiple classes and their subclasses from the autotracking system. Case sensitive.
 @param classNames Array must be made up of string values
 */
- (void) excludeClassesFromAutotracking:(NSArray*)classNames;

/*
 Exclude an object from the autotracking system. Note: if a viewcontroller object is targeted, it's view will also be excluded.
 
 @param object The NSObject subclass to exclude.
 */
- (void) excludeObjectFromAutotracking:(id)object;

/*
 Use this method if you want to continue tracking a particular object, but not it's delegate
 
 @param object The object whose delegate is to be excluded. DO NOT point to the delegate itself.
 */
- (void) excludeDelegateOfObjectFromAutotracking:(id)object;


#pragma mark - MANUAL TRACKING METHODS
/*
 *  --------------------------------------------------------------------------
 *  !!! WARNING !!! Use these methods directly only if the autotracking feature is DISABLED or is not detecting the desired object. Double call dispatches may result otherwise.
 *  --------------------------------------------------------------------------
 */

/**
 Recommended method for firing all manual tracking calls. Takes advantage of the auto-detected default data sources and additional Event Data Tracking methods below (ie addVariable:value:to: and addGlobalEventData:). To replace all other manual tracking calls.  Object required. Title and eventData is optional.
 @param object The NSObject associated with the call.  Use UIViewControllers instead of UIView's for page changes
 @param title NSString title for the page or event title.  Optional. Otherwise is auto-filled with following format: (object name): (title/selected value if available): (status). Example: "UIButton: Buy_Button: tapped" 
 @param eventData NSDictionary with custom data. Keys become Tealium IQ Data Sources. Values will be the value passed into the analytic variable mapped to the Data Source.
 */
- (void) trackObject:(id) object
               title:(NSString*)title
           eventData:(NSDictionary*) eventData;
/**
 (Deprecated. Use trackScreenViewedWithTitle:withEventData: passing a nil or NSNull argument to withEventData: instead.)
 
 @warning   If auto tracking navigation controller(s) is on (default is on), there is no need to use any trackScreenViewed_* messages, unless a view is being displayed which is not controlled by a navigation controller.
 @param title Custom title of view to track
 */
- (void) trackScreenViewedWithTitle:(NSString*) title __attribute__((deprecated));

/**
 Legacy method for tracking views directly. Recommend using autoTrackController: or trackObject: withEventData: instead.  NOTE: Using this method will not retrieve information attached to an object via the addVariable:value:to or addEventData:to: methods.
 
 @warning If auto tracking navigation controller(s) is on (default is on), there is no
 need to use any trackScreenViewed_* messages, unless a view is being displayed
 which is not controlled by a navigation controller.
 @param title Custom title of view to track
 @param eventData Required format for utag data
 */
- (void) trackScreenViewedWithTitle:(NSString*) title 
                      withEventData:(NSDictionary*) eventData;
/**
 (Deprecated. Use trackScreenViewedWithViewController:WithEventData: passing nil or NSNull to WithEventData: instead.)
 
 @warning If auto tracking navigation controller(s) is on (default is on), there is no need to use any trackScreenViewed_* messages, unless a view is being displayed which is not controlled by a navigation controller.
 @param viewController UIViewController to track
 */
- (void) trackScreenViewedWithViewController:(UIViewController*) viewController __attribute__((deprecated));
/**
 Legacy method for tracking view appearances directly. Recommend using autoTrackController: or trackObject: withEventData: instead.
 
 @warning If auto tracking navigation controller(s) is on (default is on), there is no
 need to use any trackScreenViewed_* messages, unless a view is being displayed. If the autotracking system is running and the viewController passed in is already being tracked, then 2 tracking calls will fire. Use only if the autoTracking methods are unable to hook onto this particular viewController.
 which is not controlled by a navigation controller.
 @param viewController UIViewController to track
 @param eventData Required format for utag data
 */
- (void) trackScreenViewedWithViewController:(UIViewController*) viewController 
                               WithEventData:(NSDictionary*) eventData;

/**
 (Deprecated. Use trackItemClicked:withEventData: instead)
 
 Use to track a click-type action (segue, click, etc). Analytic vendors will track this as a 'link' click.(Deprecated. Use trackItemClicked:withEventData: passing in nil or NSNull to the eventData argument.)
 
 @param clickableItemId Uniquely assigned item identification string
 */
- (void) trackItemClicked:(NSString*) clickableItemId __attribute__((deprecated));

/**
 Legacy method. Recommend using the trackObject:title:eventData: method instead. This method used to track a click-type action (segue, click, etc) that is not being autoTracked. Analytic vendors will track this as a 'link' click. NOTE: Using this method will not retrieve information attached to an object via the addVariable:value:to or addEventData:to: methods.
 
 @warning Do not use on an object being autoTracked, or two calls per click will occur.
 
 @param clickableItemId Uniquely assigned item identification string
 @param eventData NSDicitionary with any additional data to track. Nil acceptable.
 */
- (void) trackItemClicked:(NSString*) clickableItemId 
            withEventData:(NSDictionary*) eventData;

/**
 Use to pass custom data to specialized vendor tags. Consult your Tealium Account Manager before implementing this method.  trackObject:title:eventData: is the recommended track event method for all events or actions.
 
 @param eventType Tealium event type
 @param eventData Required format for utag data
 */
- (void) trackCustomEvent:(NSString*) eventType 
            withEventData:(NSDictionary*) eventData;

/**
 Fires of a caught exception dispatch.  NOTE: Uncaught exceptions are recorded by the library and automatically sent upon next successful launch.
 */
- (void) trackCaughtException:(NSException*)exception;


#pragma mark - OVERRIDE COMMANDS

/**
 Method for overriding the default Tealium mobile html url destination to retrieve utui data.
 @param override NSString of the URL to override with
 */
- (void) setMobileHtmlUrlOverride:(NSString*)override;

/**
 To manually replace the root controller object after init.
 */
- (void) setRootController:(id)rootController;


/**
 Overwrites Tealium's UUID created string.
 
 @param uuid NSString to set Tealium UUID with
 @return BOOL answer if new UUID successfully overwrote Tealium's default
 */
-(BOOL) setUUID:(NSString*)uuid;

/**
 (Deprecated. Set your library's power save call limit within the iOS Library Manager extension in your IQ console)
 */
-(void) setPowerSaveCallLimit:(int)limit __attribute__((deprecated));

#pragma mark - ADDITIONAL EVENT DATA TRACKING

/**
 Add a custom data source-value pair to an object for all it's event tracking calls.
 
 @param variable NSString variable key name that will be the Data Source key name. This is what will be entered in Tealium's IQ Data Sources tab.
 @param value The value of the variable. Must be an NSObject type (ie. NSString, NSDate, etc.). NSString types are recommended, otherwise the library will use an object's description property to determine the value to send.
 @param object The NSObject to assign the variable-value pair to
 @return Boolean indicating whether or not the data pair was successfully assigned to the object
 */
-(BOOL) addVariable:(NSString*)variable value:(NSObject*)value to:(id)object;

/**
 Add multiple variable-value pairs of data to an object.
 
 @param dict NSDictionary of any additional data to pass to Tealium
 @param object The object to attach the dict data to
 */
-(BOOL) addEventData:(NSDictionary*)dict to:(NSObject*)object;

/**
 Adds a variable-value for ALL objects for all event tracking calls
 
 @param variable The NSString key to set as the variable name of data pair
 @param value The value of the variable as an NSObject subclass
 @return Boolean indicating whether or not the variable and value were successfully saved.
 */
-(BOOL) addGlobalVariable:(NSString*)variable value:(NSObject*)value;

/**
 Adds multiple variable-value pairs to ALL objects for all event tracking calls
 
 @param variable Key
 @param key
 @return Boolean indicating whether or not the data dictionary was successfully added to the global utagVariables.
 */
-(BOOL) addGlobalEventData:(NSDictionary*)dictionary;


/**
 Set a custom title for a view or the view of viewController. Overwrites auto-titling feature.
 
 @param title String to identify view
 @param viewOrViewController Target UIView, UIViewController, or subclass of either for custom title assignment
 */
-(void) setTitle:(NSString*)title for:(id)viewOrViewController __attribute__((deprecated));

#pragma mark - INFORMATION
/**
 All the default data source key-value pairs for ALL dispatches, including custom assigned global data. (read-only)
 */
- (NSDictionary*) defaultData;

/**
 Deprecated and no longer supported. Use defaultData instead.
 */
- (NSDictionary*) baseCustomerUTagVariables __attribute__((deprecated));


/**
 (Deprecated. Simply set your view controller's title property to desired title.)
 
 Retrieves the autoTracked titled of a viewController, normally the view controller's title or nibname property.
 
 @param object UIViewController to retrieve title for
 */
- (NSString*) autoTrackTitle:(id) object __attribute__((deprecated));

/**
 (Deprecated.  Will currently return ALL data source keys and values for object at time of call. This method WILL be dropped in the next library release)
 Retrieves any additional data that has should be sent with all calls related to the object argument.
 
 @param object The object to check for additional data
 */
-(NSDictionary*) additionalEventDataFor:(id)object __attribute__((deprecated));

/**
 Returns the currently tracked root controller
 */
- (id) rootController;
- (NSMutableDictionary*) utag_config;
- (NSDictionary*) outboundQueue;
- (NSDictionary*) outboundLog;
- (BOOL) powerSaveStatus;
- (int)  powerSaveCallLimit;

/**
 Retrieves a Tealium generated Universally Unique Identifier that distinguishes the current device from others now that the use of UDIDs are no longer permitted.  If this UUID is not already available, it will generate a new UUID before returning.
 
 @return An NSString object
 */
-(NSString*) retrieveUUID;

#pragma mark - DELIVERY METHODS

/**
 Manually starts dispatch of any queued events.  Used this method if you have disabled the power save system.
 */
- (void) deliver;

@end
