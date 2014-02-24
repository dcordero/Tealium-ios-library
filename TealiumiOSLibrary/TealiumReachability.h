/*
 Copyright (c) 2011, Tony Million.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE. 
 */

 /* 

  TealiumiOSReachability is a modification of the original code from: https://github.com/tonymillion/Reachability

  */

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000 // iOS 6.0 or later
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else                                         // iOS 5.X or earlier
#define NEEDS_DISPATCH_RETAIN_RELEASE 1
#endif

extern NSString *const kTealiumReachabilityChangedNotification;

typedef enum 
{
	// Apple NetworkStatus Compatible Names.
	TealiumNotReachable     = 0,
	TealiumReachableViaWiFi = 2,
	TealiumReachableViaWWAN = 1
} TealiumNetworkStatus;

@class TealiumReachability;

typedef void (^NetworkReachable)(TealiumReachability * reachability);
typedef void (^NetworkUnreachable)(TealiumReachability * reachability);


/**
 ARC-Compliant version of the original non-arc complaint reachability class provided by Apple at: "http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html". 
 */
@interface TealiumReachability : NSObject

@property (nonatomic, copy) NetworkReachable    reachableBlock;
@property (nonatomic, copy) NetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) SCNetworkReachabilityRef  reachabilityRef;

#if NEEDS_DISPATCH_RETAIN_RELEASE
@property (nonatomic, assign) dispatch_queue_t          reachabilitySerialQueue;
#else
@property (nonatomic, strong) dispatch_queue_t          reachabilitySerialQueue;
#endif

@property (nonatomic, assign) BOOL reachableOnWWAN;

@property (nonatomic, strong) id reachabilityObject;


+(TealiumReachability*)reachabilityWithHostname:(NSString*)hostname;
+(TealiumReachability*)reachabilityForInternetConnection;
+(TealiumReachability*)reachabilityWithAddress:(const struct sockaddr_in*)hostAddress;
+(TealiumReachability*)reachabilityForLocalWiFi;

-(TealiumReachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;


/**
 Notifier.
 
 @warning NOTE: this uses GCD to trigger the blocks - they *WILL NOT* be called on THE MAIN THREAD - In other words DO NOT DO ANY UI UPDATES IN THE BLOCKS. INSTEAD USE dispatch_async(dispatch_get_main_queue(), ^{UISTUFF}) (or dispatch_sync if you want)
 */
-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired; // Identical DDG variant.
-(BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;
// Is user intervention required?
-(BOOL)isInterventionRequired;

-(TealiumNetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;

@end
