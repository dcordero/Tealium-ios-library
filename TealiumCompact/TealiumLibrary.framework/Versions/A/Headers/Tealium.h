//
//  Tealium.h
//
//  ------------
//  *** INFO ***
//  ------------
//
//  Version: 3.2c
//
//  Minimum OS Version supported: iOS 5.0+
//
//  Brief: The is the primary TealiumiOS library class object for tracking analytics data on iOS devices.  It includes both the UI Autotracking and Mobile Companion features. The below methods in this header file are the only public methods needed to initialize and run the library. Configuration should be done from Tealium's IQ dashboard at https://www.tealium.com
//
//  Authors: Originally Created by Charles Glommen and Gautam Dey, rewritten, extended and maintained by Jason Koo
//
//  Copyright: (c) 2014 Tealium, Inc. All rights reserved.
//
// ----------------------------------
// *** QUICK INSTALL INSTRUCTIONS ***
// ----------------------------------
//
// 1. Copy/link the TealiumiOSLibrary.framework into your XCode project
// 
// 2. Link the following framework to your project:
//
//      * SystemConfiguration.framework
// 
// 2a. Optionally link the following framework:
// 
//      * CoreTelephony.framework (for carrier data tracking)
// 
// 3. Add the class level init method (initSharedInstance:profile:target:options:globalCustomData:) to your app delegate or wherever your primary root controller is initialized
// 
// 4. Add "#import <TealiumLibrary/Tealium.h>" to your -Prefix.pch file, within the #ifdef __OBJC__ block statement for app wide access. Otherwise, add this import statment to the header file of every class that will use the library.
//
//  -----------------------
//  *** ADDITIONAL INFO ***
//  -----------------------
//  This library runs the majority of it's operations on a background thread, so there is no need to wrap it, although doing so will not adversly affect it.
// 
//  See the github Readme.md file and wiki at: https://github.com/Tealium/ios-library for full developer instructions. You will require a Github account and permissions approval by your Tealium Account Manager to access.
//
//  Checkout our mobile related articles at http://community.tealiumiq.com for supplemental information. See your Tealium Account Manager for access.

#import <Foundation/Foundation.h>
#import "TealiumConstants.h"

@interface Tealium : NSObject

#pragma mark - INITIALIZATION

/*
 Library status indicator.
 
 @return Boolean whether the Tealium library is currently active.
 */
+ (BOOL) isActive;

/**
 The Class-level init method. Available version 3.2+.
 
 @param accountName NSString of your Tealium account name
 @param profileName NSString of your account-profile name
 @param environmentName NSString Target environment (dev/qa/prod)
 @param options Tealium Options to configure the library. Multiple options may be used using a pipe (|) operator between options. Enter "0" or TLNone for no options.
 */
+ (void) initSharedInstance: (NSString*) accountName
                    profile: (NSString*) profileName
                     target: (NSString*) environmentName
                    options: (TealiumOptions) options
           globalCustomData: (NSDictionary*)customData;

/**
 Legacy version 3.0 Class-level init method. This method now calls the new recommended Class-level init method above, with no globalCustomData.
 
 @param accountName Name of Tealium account
 @param profileName Target Account profile
 @param environmentName Target profile environment (dev, qa, etc.)
 @param options USe Tealium Options constants to configure the library.
 */
+ (void) initSharedInstance: (NSString*) accountName
                    profile: (NSString*) profileName
                     target: (NSString*) environmentName
                    options: (TealiumOptions) options;

/**
 Legacy version 1.0 Class-level init method. This method now calls the new recommended Class-level init method above, with no options or globalCustomData.
 
 @param accountName Name of Tealium account
 @param profileName Target Account profile
 @param environmentName Target profile environment (dev, qa, etc.)
 */
+ (void) initSharedInstance: (NSString*) accountName
                        profile: (NSString*) profileName
                         target: (NSString*) environmentName;

/**
 New universal method for firing all manual tracking calls. Takes advantage of the auto-detected default data sources and additional Custom Data methods below (ie addCustomData:to: and addGlobalCustomData:).
 
 @param callType Enter either TealiumEventCall or TealiumViewCall for the appropriate track type
 @param eventData NSDictionary with custom data. Keys become Tealium IQ Data Sources. Values will be the value passed into the analytic variable mapped to the Data Source.
 @param object NSObject source of the call if you want auto property detection added to the tracking call for a particular object */
+ (void) trackCallType:(NSString*)callType customData:(NSDictionary*)data object:(NSObject*)object;

/**
 Puts Tealium tagger to permenant sleep. This is an optional method if your app has a manual option for users to disable analytic tracking. Enable must be called to reactivate. Supercedes any remote configuration settings.
 */
+ (void) disable;

/**
 To re-enable the library from a disable call.
 */
+ (void) enable;

/*
 Use this method to access the library's global custom data dictionary.
 */
+ (NSMutableDictionary*) globalCustomData;

/*
 Use this method to access any custom data dictionary associated with a given object.
 
 @param NSObject Required.
 */
+ (NSMutableDictionary*) customDataForObject:(NSObject*)object;


#pragma mark - DEPRECATED METHODS
/*
 The below methods are marked for deprecation.  Some of these methods will still continue to produce the intended results this version but the recommended alternatives are suggested. Additionaly these methods will be entirely removed in the next iteration.  Methods that no longer function at all will report an error log upon use.
 */

/**
 Deprecated method for adding data source-value pairs to future calls related to the target object. Use the class level customDataForObject: method to retrieve the NSMutableDictionary custom data store for a given object to modify it's contents.
 
 @param customData NSDictionary of any additional data to pass to Tealium. Can not be nil
 @param object The object to attach the dict data to. Can not be nil
 */
- (void) addCustomData:(NSDictionary*)customData to:(NSObject*)object __attribute__((deprecated));

/**
 Deprecated method to add multiple data source-value pairs to ALL objects for all future tracking calls. Use the class level globalCustomData method to retrieve the global NSMutableDictionary store to modify it's contents.
 
 @param customData NSDictionary of key-value pairs to become data source-value pairs in Tealium IQ. Nil will result in a NO return
 */
- (void) addGlobalCustomData:(NSDictionary*)customData __attribute__((deprecated));

/**
 Deprecated method to put library to permenant sleep. Use the new disable: class method instead. This is an optional method if your app has a manual option for users to disable analytic tracking. Enable must be called to reactivate. Supercedes any remote configuration settings.
 */
- (void) disable __attribute__((deprecated));

/**
 Deprecated method to re-enable the library from a disable call. Use the new enable: class method instead.
 */
- (void) enable __attribute__((deprecated));

 /**
 Deprecated method to use if the TLPauseInit option was used in the library's init method to finalize the startup sequence. This option was required if you wish to add global custom data BEFORE the initial wake calls. Use the class level method with customData argument now.
 */
- (void) resumeInit __attribute__((deprecated));

/*
 Deprecated method to retrieves the Tealium generated Universally Unique Identifier that distinguishes the current device and app from other devices with your application.  Use the globalCustomData: class method instead to retrieve the global data dictionary with the "uuid" key, like so: NSString *uuid = [Tealium globalCustomData][TealiumDSK_UUID].  If needed, you can also replace the UUID with your own identifier like so: [Tealium globalCustomData][TealiumDSK_UUID] = @"myUUID";. NOTE: Do not confuse this with the deprecated UDID, which is no longer permitted by Apple.
 
 @return An NSString object
 */
- (NSString*) retrieveUUID __attribute__((deprecated));

/**
 Deprecated method for overriding the default Tealium mobile html url destination for retrieving configuration and mapping data. Use the initSharedInstance:profile:target:options:globalCustomData: method and insert an NSString of the full URL address for the key TealiumDSK_OverrideUrl, like so:  [Tealium initSharedInstance:@"myAccount" profile:@"myProfile" target:@"dev" options:0 globalCustomData:@{TealiumDSK_OverrideUrl:@"http://www.myOverrideAddress.com"}];.
 
 @param override NSString of the full URL to override default with
 */
- (void) setMobileHtmlUrlOverride:(NSString*)override __attribute__((deprecated));

/*
 Deprecated method for overriding automatically assigned Tealium ID.  Recommend using the new customData:forObject: method and override the "tealiumId" key, like so: [Tealium customDataForObject:self][TealiumDSK_TealiumId] = @"myTealiumId";.
 
 @param tealiumId Tealium Reference ID of object to track.  Use 6 or more alphanumberic characters to avoid namespace collisions with automatically assigned library ids.
 @param object Object to track - Must be a subclass of NSObject
 */
- (void) setTealiumId:(NSString*)tealiumId to:(id)object __attribute__((deprecated));

/**
 Deprecated method to overwrites Tealium's UUID created string. Use the new globalCustomData: method to retrieve the global data containing the "uuid" key to manipulate the default uuid or set it from the initSharedInstance:profile:target:options:globalCustomData: class method by adding a "uuid" key-value pair to the globalCustomData: argument, like so: [Tealium initSharedInstance:@"myAccount" profile:@"myProfile" target:@"dev" options:0 globalCustomData:@{TealiumDSK_UUID:@"myOwnId"}];. NOTE: Do not confuse UUID with the deprecated UDID, the identifier no longer supported by Apple.
 
 @param uuid NSString to set Tealium UUID with
 @return BOOL answer if new UUID successfully overwrote Tealium's default
 */
- (BOOL) setUUID:(NSString*)uuid __attribute__((deprecated));

/**
 Deprecated method for accessing the Tealium Library Singleton. No longer needed with class level use
 */
+ (id) sharedInstance __attribute__((deprecated));

/**
 Deprecated method for firing all manual tracking calls. Use the new class level +trackCallType:customData:object: method instead.
 
 @param object The NSObject associated with the call.  Use UIViewControllers instead of UIView's for view tracking
 @param eventData NSDictionary with custom data. Keys become Tealium IQ Data Sources. Values will be the value passed into the analytic variable mapped to the Data Source.
 @param callType NSString of call type - use either provided constants "TealiumViewCall" for views or "TealiumEventCall" for events - other string values reserved for future use.
 */
- (void) track:(NSObject*)object customData:(NSDictionary*)customData as:(NSString*)callType __attribute__ ((deprecated));

@end
