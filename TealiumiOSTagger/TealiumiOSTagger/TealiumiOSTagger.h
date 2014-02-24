//
//  TealiumiOSTagger.h
//  TealiumiOSTagger
//
//  Created by Charles Glommen.
//  Copyright (c) 2012 Tealium, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
    
    NSMutableDictionary* autoTrackedNavigationControllers;
    NSMutableDictionary* _baseCustomerUTagVariables;
}

@property BOOL autoViewTrackingEnabled;
@property (strong, nonatomic) NSString* mobileHtmlUrlOverride; 

/*
 These class-level messages are convenience messages for when a single account/profile/environment context exists.
 However, if more than one tealium context is needed (unlikely), or a dependency injection framework is already employed, 
 it is recommended to directly utilize the init message below. 
 */
+ (TealiumiOSTagger*) initSharedInstance: accountName 
                                 profile: (NSString*) profileName 
                                  target: (NSString*) environmentName 
                    navigationController: (UINavigationController*) firstNavigationController;
+ (TealiumiOSTagger *) initInstance: accountName profile:(NSString*) profileName target:(NSString*) environmentName navigationController: (UINavigationController*) firstNavigationController;

/*
   sharedInstance is a better name, and follow Apple recommended convention.
 
*/
+ (TealiumiOSTagger *) sharedInstance;
+ (TealiumiOSTagger *) getInstance;

/*
 This init message is optional. The API user should choose between 
 explicitly sending this init message or simply using the class-level
 messages above, initInstance and getInstance. Unless a dependency injection
 framework is used, it is recommended to simply use the class messages
 */
- (TealiumiOSTagger *) init:(NSString*) accountName profile:(NSString*) profileName target:(NSString*) environmentName navigationController: (UINavigationController*) navigationController;

/*
 API users MUST call these before and after the application closes or opens 
 or goes to or from the background. 
 Ideally, the sleep is called from from [AppDelegate applicationWillResignActive] or [AppDelegate applicationWillEnterForeground]
 while wakeUp should be called from [AppDelegate applicationDidBecomeActive]
 
 NOTE: these messages are idempotent, so therefore calling them multiple times is safe 
 */
- (void) sleep;
- (void) wakeUp;

/*
 These are the Tealium messages available to API users. 
 
 If auto tracking navigation controller(s) is on (default is on), there is no
 need to use either of the trackScreenViewed_* messages, unless a view is being displayed
 which is not controlled by a navigation controller.
 
 autoTrackNavigationController only needs to be used when more than one navigationController
 should be tracked. The first (and main) one is already passed in with the init methods above.
 
 Use trackItemClicked to track a click-type action (segue, click, etc). Analytic vendors will track this as a 'link' click.
 
 Use trackCustomEvent to pass any other action that a vendor tag might utilize. This will only be useful when used
 in conjunction with the proper configuration from within the Tealium console. 
 
 See the README on the github repo for samples.
 */



- (void) autoTrackNavigationController: (UINavigationController*) navigationController;

- (void) trackScreenViewedWithTitle:(NSString*) title;
- (void) trackScreenViewedWithTitle:(NSString*) title 
                      withEventData:(NSDictionary*) eventData;

- (void) trackScreenViewedWithViewController:(UIViewController*) viewController;
- (void) trackScreenViewedWithViewController:(UIViewController*) viewController 
                               WithEventData:(NSDictionary*) eventData;

- (void) trackItemClicked:(NSString*) clickableItemId;
- (void) trackItemClicked:(NSString*) clickableItemId 
            withEventData:(NSDictionary*) eventData;

- (void) trackCustomEvent:(NSString*) eventType 
            withEventData:(NSDictionary*) eventData;

- (NSDictionary*) baseCustomerUTagVariables;
- (void) setVariables:(NSDictionary*) variablesDict;
- (void) setVariable:(NSString*) value forKey:(NSString*) key;
- (NSDictionary *)getCompositeDictionaryWithDictionary:(NSDictionary*) optionalDictionary;


/*
 These are delegate messages, not intended for API users. 
 The first is used to ensure we have a usable UIWebView, while the second allows auto-view tracking.
*/
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void) navigationController:(UINavigationController*) navigationController didShowViewController:(UIViewController*) viewController animated:(BOOL) animated;

@end
