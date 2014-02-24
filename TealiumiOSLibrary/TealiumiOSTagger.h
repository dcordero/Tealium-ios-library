//
//  TealiumiOSTagger.h
//  TealiumiOSTagger
//
//  Created by Charles Glommen.
//  Extended by Gautam Day & Jason Koo
//  Copyright (c) 2012 Tealium, Inc. All rights reserved.
//
/*
 *  Quick install:
 *  + Add the SystemConfiguration.framework to your project
 *  + Add the CoreTelephony.framework to your project
 *  + Add the class level init method to your app delegate or wherever your primary navigation controller is initialized
 *  ! Use valid Account, Profile and Environment strings in the init method
 *  ! Set autoviewTrackingEnabled property to YES after init to enable.
 *  + Add sleep and wake calls to your app delegate
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import "TealiumReachability.h"
#define __TealiumReachability TealiumReachability

// EventData Keys
extern NSString * const TealiumEventDataTrackTypeKey;
extern NSString * const TealiumEventDataTrackTypeValueAuto;
extern NSString * const TealiumEventDataScreenTitleKey;
extern NSString * const TealiumEventDataClickableItemIdKey;

// Event Names
extern NSString * const TealiumEventView;
extern NSString * const TealiumEventItemClicked;
extern NSString * const TealiumEventVideoPlayed;

// Environment Names
extern NSString * const TealiumTargetProduction;
extern NSString * const TealiumTargetQA;
extern NSString * const TealiumTargetDev;

// AutoTracking
extern NSString * const TealiumGlobalAutoTitles;

/**
 Primary TealiumiOS Tagger class object for tracking analytics data on iOS devices.  The following default data is included with each call: platform(iOS), OS_version, device (iPhone, iPod, etc.), app_version, app_name, connection_type, carrier and uuid. For additional information consult included XCode docset or goto:  https://github.com/Tealium/ios-tagger (requires a valid Tealium account to access).
 */
@interface TealiumiOSTagger : NSObject<UINavigationControllerDelegate, UIWebViewDelegate> {
    
@private
    NSDictionary* _baseUTagVariables;
    UIWebView* _webView;
    NSMutableArray* _eventQueue;
    __TealiumReachability* _reach;
    NSString* _lastViewControllerViewed;
    NSString* _account;
    NSString* _profile;
    NSString* _environment;
    
    BOOL _tealiumEnabled;
    BOOL _timerIsRunning;
    BOOL _networkReachable;
    BOOL _webViewReady;
    
    NSMutableDictionary*    autoTrackedNavigationControllers;
    NSMutableDictionary*    _autoTitles;
    NSMutableDictionary*    _baseCustomerUTagVariables;
}

/**
 A Boolean value that indicates whether Tealium should auto track views. This is normally auto set by the init method but can be overridden.
 @warning Requires UINavigationController to manage application views.
 */
@property BOOL autoViewTrackingEnabled;
@property (strong, nonatomic) NSString* mobileHtmlUrlOverride; 

/**
 Recommended class-level init method.
 
 @warning Class-level messages are convenience messages for when a single account/profile/environment context exists. However, if more than one tealium context is needed (unlikely), or a dependency injection framework is already employed, it is recommended to directly utilize the instance init message init:profile:target:navigationController: 
 @param accountName Name of Tealium account
 @param profileName Target Account profile
 @param environmentName Target profile environment (dev, qa, etc.)
 @param firstNavigationController Root navigation controller. If parameter passed is nil then autoTracking will be disabled.
 */
+ (TealiumiOSTagger*) initSharedInstance: accountName
                                 profile: (NSString*) profileName 
                                  target: (NSString*) environmentName 
                    navigationController: (UINavigationController*) firstNavigationController;
/**
 (Deprecated. User initSharedInstance:profile:target:navigationController: instead.)
 
 @warning convenience message for when a single account/profile/environment context exists. However, if more than one tealium context is needed (unlikely), or a dependency injection framework is already employed, it is recommended to directly utilize the instance init message init:profile:target:navigationController:.
 @param accountName Name of Tealium account
 @param profileName Target Account profile
 @param environmentName Target profile environment (dev, qa, etc.)
 @param firstNavigationController Root navigation controller
 */
+ (TealiumiOSTagger *) initInstance: accountName profile:(NSString*) profileName target:(NSString*) environmentName navigationController: (UINavigationController*) firstNavigationController __attribute__((deprecated));


+ (TealiumiOSTagger *) sharedInstance;
/**
 (Deprecated. Use +(TealiumiOSTagger*)sharedInstance instead.)
 */
+ (TealiumiOSTagger *) getInstance __attribute__((deprecated));

/**
 Optional initialization method if needing to track more than one UINavigationController hierarchy.
 
 @warning This init message is optional. The API user should choose between explicitly sending this init message or simply using the class-level messages above, initInstance and getInstance. Unless a dependency injection framework is used, it is recommended to simply use the class messages.
 @param accountName Name of Tealium account
 @param profileName Name of Tealium account profile to attach tagger singleton to
 @param environmentName Target Tealium enviornment (dev, qa, etc.)
 @param navigationController Root navigation controller
 */
- (TealiumiOSTagger *) init:(NSString*) accountName profile:(NSString*) profileName target:(NSString*) environmentName navigationController: (UINavigationController*) navigationController;

/**
 Method is idempotent, calling multiple times is safe. If using auto-tracking (default) this method will automatically be called.
 
 @warning MUST be called before application closes or goes to background if not using auto-tracking. Ideally called from [AppDelegate applicationWillResignActive] or [AppDelegate applicationWillEnterForeground]
 */
- (void) sleep;

/**
 Method is idempotent, calling multiple times is safe. If using auto-tracking (default) this will automatically be called.
 
 @warning MUST be called after application reopens if not using auto-tracking. Ideally called from [AppDelegate applicationDidBecomeActive]
 */
- (void) wakeUp;

/*
 TEALIUM API MESSAGES
 Following are the Tealium messages available to API users. 
 
 If auto tracking navigation controller(s) is on (default is on), there is no
 need to use either of the trackScreenViewed_* messages, unless a view is being displayed
 which is not controlled by a navigation controller.
 
 See the README on the github repo for samples.
 */


/**
 For auto-tracking multiple UINavigationControllers.
 
 @warning Only needs to be used when more than one navigationController
 should be tracked. The first (and main) one is already passed in with the init methods above.
 @param navigationController Navigtation controller to track
 */
- (void) autoTrackNavigationController: (UINavigationController*) navigationController;

/**
 (Deprecated. Use trackScreenViewedWithTitle:withEventData: passing a nil or NSNull argument to withEventData: instead.)
 
 @warning   If auto tracking navigation controller(s) is on (default is on), there is no need to use any trackScreenViewed_* messages, unless a view is being displayed which is not controlled by a navigation controller.
 @param title Custom title of view to track
 */
- (void) trackScreenViewedWithTitle:(NSString*) title __attribute__((deprecated));

/**
 To track a view not being auto-tracked.
 
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
 To track a view not being auto-tracked.
 
 @warning If auto tracking navigation controller(s) is on (default is on), there is no
 need to use any trackScreenViewed_* messages, unless a view is being displayed
 which is not controlled by a navigation controller.
 @param viewController UIViewController to track
 @param eventData Required format for utag data
 */
- (void) trackScreenViewedWithViewController:(UIViewController*) viewController 
                               WithEventData:(NSDictionary*) eventData;

/**
 Use to track a click-type action (segue, click, etc). Analytic vendors will track this as a 'link' click.(Deprecated. Use trackItemClicked:withEventData: passing in nil or NSNull to the eventData argument.)
 
 @param clickableItemId Uniquely assigned item identification string
 */
- (void) trackItemClicked:(NSString*) clickableItemId __attribute__((deprecated));

/**
 Use to track a click-type action (segue, click, etc). Analytic vendors will track this as a 'link' click.
 
 @param clickableItemId Uniquely assigned item identification string
 @param eventData Required format for utag data
 */
- (void) trackItemClicked:(NSString*) clickableItemId 
            withEventData:(NSDictionary*) eventData;

/**
 Use to pass any other action that a vendor tag might utilize. This will only be useful when used in conjunction with the proper configuration from within the Tealium console.
 
 @param eventType Tealium event type
 @param eventData Required format for utag data
 */
- (void) trackCustomEvent:(NSString*) eventType 
            withEventData:(NSDictionary*) eventData;

- (NSDictionary*) baseCustomerUTagVariables;
- (void) setVariables:(NSDictionary*) variablesDict;
- (void) setVariable:(NSString*) value forKey:(NSString*) key;
- (NSDictionary *)getCompositeDictionaryWithDictionary:(NSDictionary*) optionalDictionary;


/**
 Ensures usable UIWebView is available.
 
 @warning Delegate message - NOT intended for API use.
 @param webView UIWebview created by TealiumiOSTagger
*/
- (void)webViewDidFinishLoad:(UIWebView *)webView;

/**
 Used by auto-view tracking methods.
 
 @warning Delegate message - NOT intended for API use.
 @param navigationController UINavigationController being auto-tracked
 @param viewController UIViewController being displayed by navigationController
 @param animated Animate the view transition
 */
- (void) navigationController:(UINavigationController*) navigationController didShowViewController:(UIViewController*) viewController animated:(BOOL) animated;

/**
 Retrieves a Tealium generated Universally Unique Identifier that distinguishes the current device from others now that the use of UDIDs are no longer permitted.  If this UUID is not already available, it will generate a new UUID before returning.
 
 @return An NSString object
 */
-(NSString*) retrieveUUID;

/**
 Overwrites Tealium's UUID created string.
 
 @param uuid NSString to set Tealium UUID with
 @return BOOL answer if new UUID correctly overwrote Tealium's default
 */
-(BOOL) setUUID:(NSString*)uuid;


@end
