//
//  TealiumiOSTagger.m
//  TealiumiOSTagger
//
//  Created by Charles Glommen.
//  Copyright (c) 2012 Tealium, Inc. All rights reserved.
//
 
#import "TealiumiOSTagger.h"

@implementation TealiumiOSTagger

@synthesize autoViewTrackingEnabled;
@synthesize mobileHtmlUrlOverride;

#define ReachabilityHostname @"www.google.com"
#ifndef MobileURLTemplate
#define MobileURLTemplate @"http://tealium.hs.llnwd.net/o43/utag/%@/%@/%@/mobile.html"
#endif
#define NavPairUINavigationControllerIndex 0
#define NavPairDelegateIndex 1

// EventData Keys
NSString * const TealiumEventDataTrackTypeKey = @"track_type";
NSString * const TealiumEventDataTrackTypeValueAuto = @"auto";

NSString * const TealiumEventDataScreenTitleKey = @"screen_title";
NSString * const TealiumEventDataClickableItemIdKey = @"link_id";

// Event Names
NSString * const TealiumEventView = @"view";
NSString * const TealiumEventItemClicked = @"link";
NSString * const TealiumEventVideoPlayed = @"video_played";

// Environment Names
NSString * const TealiumTargetProduction = @"prod";
NSString * const TealiumTargetQA = @"qa";
NSString * const TealiumTargetDev = @"dev";



/*
 These are only used to initialize the singleton
 */

TealiumiOSTagger *_sharedTaggerInstance;

+ (TealiumiOSTagger*) initSharedInstance: accountName 
                           profile: (NSString*) profileName 
                            target: (NSString*) environmentName 
              navigationController: (UINavigationController*) firstNavigationController {
    

    if( _sharedTaggerInstance ){
#ifdef DEBUG
        NSLog(@"initInstance called twice.");
#endif
    }

    
    static dispatch_once_t p = 0;
    
    dispatch_once(&p, ^{
        _sharedTaggerInstance = [[TealiumiOSTagger alloc] init: accountName
                                               profile: profileName
                                                target: environmentName 
                                  navigationController: firstNavigationController];
    });

    return [self sharedInstance];
}

+ (TealiumiOSTagger *) initInstance:(id)accountName profile:(NSString *)profileName target:(NSString *)environmentName navigationController:(UINavigationController *)firstNavigationController {
    return [self initSharedInstance:accountName profile:profileName target:environmentName navigationController:firstNavigationController];
}

+ (TealiumiOSTagger *) sharedInstance {
    
    NSAssert(     _sharedTaggerInstance != nil, @"TealiumOSTagger singleton message initSharedInstance must be called once before sharedInstance" );    
#if __has_feature(objc_arc)
    return _sharedTaggerInstance;
#else
    return [[_sharedTaggerInstance retain] autorelease];
#endif
}

// To keep with old naming.

+ (TealiumiOSTagger *) getInstance { 
#ifdef DEBUG
    NSLog(@"getInstance is deprecated in favor of sharedInstance, which is a drop in replacment for this call.");
#endif    
    return [self sharedInstance]; 
}

- (TealiumiOSTagger*) init: (NSString*) accountName 
                   profile: (NSString*) profileName 
                    target: (NSString*) environmentName 
      navigationController: (UINavigationController*) firstNavigationController {
    
    self = [super init];
    if (!self) {
        return self;
    }
#ifdef DEBUG
    NSLog(@"initializing Tealium iOSTagger...");
#endif
    
    autoViewTrackingEnabled = NO;
    mobileHtmlUrlOverride = nil;
    
#if __has_feature(objc_arc)
    _account = accountName;
    _profile = profileName;
    _environment = environmentName;
#else
    if( _account != accountName ){
        [_account release];
        _account = [accountName retain]; 
    }
    if( _account != profileName ){
        [_profile release];
        _profile = [profileName retain];
    }
    if( _environment != environmentName ){
        [_environment release];
        _environment = [environmentName retain];
    }

#endif
    
    [self initializeWebView];
    [self initializeNetworkDetection];
    [self autoTrackNavigationController:firstNavigationController];
    [self wakeUp];
    
    NSLog(@"Tealium iOSTagger initialized and started");
    
    return self;
}

- (NSDictionary *)baseCustomerUTagVariables {
    if(_baseCustomerUTagVariables == nil){
        _baseCustomerUTagVariables = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    return _baseCustomerUTagVariables;
}

- (NSDictionary *)baseUTagVariables {
    NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];
    NSString *application_version = [bundle objectForKey:@"CFBundleVersion"];
    NSString *application_name = [bundle objectForKey:@"CFBundleName"];
    if (_baseUTagVariables == nil) {
        _baseUTagVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"ios", @"platform", 
                              [[UIDevice currentDevice] model], @"device",
                              application_version, @"app_version",
                              application_name, @"app_name",
                              nil];
    }
    return _baseUTagVariables;
}

- (void) initializeWebView {
   
    CGRect frame = CGRectMake(0, 0, 0, 0);
    
#if !(__has_feature(objc_arc))
    if( _webView != nil ){
        [_webView release];
    }
#endif
    _webView = [[UIWebView alloc] initWithFrame:frame];
    [_webView setHidden:YES];
    [_webView setDelegate:self];
    
    NSString* mobileUrl = [NSString stringWithFormat:MobileURLTemplate, _account, _profile, _environment]; 
    
    if (mobileHtmlUrlOverride != nil) {
        mobileUrl = mobileHtmlUrlOverride;
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mobileUrl]]];
}

- (__TealiumReachability *) reachabilityObject {
    
    if (_reach == nil) {
#if __has_feature(objc_arc)
        _reach = [__TealiumReachability reachabilityWithHostname:ReachabilityHostname];
#else
        _reach = [[__TealiumReachability reachabilityWithHostname: ReachabilityHostname] retain];
#endif
    }
    return _reach;
}

- (void) initializeNetworkDetection {
    
    __TealiumReachability *reach = [self reachabilityObject];
    TealiumiOSTagger* me = self;
    
    reach.reachableBlock = ^(__TealiumReachability* reach) {
        me->_networkReachable = YES;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [me trySendingQueuedUTagItems];
        });
    };
    
    reach.unreachableBlock = ^(__TealiumReachability* reach) {
        me->_networkReachable = NO;
        me->_timerIsRunning = NO;
    };
    
}

- (void) sleep {
    @synchronized(self) {
        if (!_tealiumEnabled) {
#ifdef DEBUG
            NSLog(@"Tealium Tagger sleep called, but is already asleep");
#endif
            return;
        }
#ifdef DEBUG
        NSLog(@"Tealium Tagger going to sleep");
#endif
        [[self reachabilityObject] stopNotifier];
        _tealiumEnabled = NO;
        [[NSUserDefaults standardUserDefaults] setObject:_eventQueue forKey:@"_tealium_tagger_"];
    }
}

-(void) wakeUp {
    @synchronized(self) {
        if (_tealiumEnabled) {
#ifdef DEBUG
            NSLog(@"Tealium Tagger wakeUp called, but is already active");
#endif
            return;
        }

#ifdef DEBUG
        NSLog(@"Tealium Tagger is waking up");
#endif
        _eventQueue = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"_tealium_tagger_"]];
        if (_eventQueue == nil) {
            _eventQueue = [[NSMutableArray alloc] init];
        }
        _tealiumEnabled = YES;
        [[self reachabilityObject] startNotifier];
    
        //there is no need to call [self trySendingQueuedUTagItems] here
        //because [_reach startNotifier] will call the 'reachable' block (assuming connectivity) 
        //which will invoke this call
    }
}


#pragma mark Tealium API

- (void) setVariables:(NSDictionary *)variablesDict {
    if( _baseCustomerUTagVariables == variablesDict ){
        return; // NOOP if the same.
    }
#if !(__has_feature(objc_arc))
    [_baseCustomerUTagVariables release];
#endif
    _baseCustomerUTagVariables = (NSMutableDictionary *)[variablesDict mutableCopy];
}

- (void) setVariable:(NSString *)value forKey:(NSString *)key {
    // Just to make sure we have a good _baseCustomerUTagVariable.
    [self baseCustomerUTagVariables];
    if (value == nil) {
        [_baseCustomerUTagVariables removeObjectForKey:key];
        return;
    }
    [_baseCustomerUTagVariables setValue:value forKey:key];
}

- (void) autoTrackNavigationController: (UINavigationController*) navigationController {
    if (navigationController == nil)
        return;

    if( !autoTrackedNavigationControllers ){
        autoTrackedNavigationControllers = [[NSMutableDictionary alloc] initWithCapacity:2];
    }

   NSAssert([autoTrackedNavigationControllers objectForKey:navigationController] == nil, @"Trying to autotrack a uinavigation controller that is already being tracked." );

    id<UINavigationControllerDelegate> delegate = [navigationController delegate];
    NSArray *navPair = nil;
    if (delegate == nil) {
        // We need to store the delegate to proxy things to.
        // But we also want to store null objects, for nil
        // delegates so, that we can release later.
        navPair = [NSArray arrayWithObjects:navigationController,[NSNull null], nil];
    } else {
        navPair = [NSArray arrayWithObjects:navigationController, delegate, nil];
    }
    [autoTrackedNavigationControllers setObject:navPair forKey:[NSNumber numberWithInt:[navigationController hash]]];
    [navigationController setDelegate:self];

}

- (void) trackScreenViewedWithViewController: (UIViewController*) viewController 
                               withEventData: (NSDictionary *)eventData
                              wasAutoTracked: (BOOL) isAuto {
    NSAssert(viewController,@"ViewController should not be nil, when calling trackScreenViewedWithViewController methods.");
    if (viewController == nil) {
        return;
    }
    NSString *title = [eventData objectForKey:TealiumEventDataScreenTitleKey];
    if(title == nil){
        title = [viewController title];
    }
    [self trackScreenViewedWithTitle:title withEventData:eventData wasAutoTracked:isAuto];
}

- (void) trackScreenViewedWithViewController:(UIViewController*) viewController 
                              wasAutoTracked:(BOOL) isAuto {
    [self trackScreenViewedWithViewController:viewController 
                                withEventData:nil 
                               wasAutoTracked:isAuto];
}

- (void) trackScreenViewedWithViewController:(UIViewController *)viewController 
                               WithEventData:(NSDictionary *)eventData {
    
    [self trackScreenViewedWithViewController:viewController 
                                withEventData:eventData 
                               wasAutoTracked:NO];
}

- (void) trackScreenViewedWithViewController:(UIViewController*) viewController {
    [self trackScreenViewedWithViewController:viewController 
                                withEventData:nil 
                               wasAutoTracked:NO];
}


- (void) trackScreenViewedWithTitle:(NSString *)title 
                      withEventData:(NSDictionary *)eventData 
                     wasAutoTracked:(BOOL)isAuto {
 
    
    NSAssert(title != nil,@"Title can not be nil, when calling trackScreenViewedWithTitle");
    /*
     * The data precedence for this is the following:
     *  the passed in title overwrites all values.
     *  the eventData overwrites and base values.
     *  the customer baseVariables overwrites our baseVariables
     *  our baseVariables set the foundation.
     */
    
    //since the delegate message is a bit unreliable (it can be called twice)
    //we need to ensure we only count the first one
    if (_lastViewControllerViewed != nil && [_lastViewControllerViewed isEqualToString: title]) {
        return;
    }
    
#if !(__has_feature(objc_arc))
    [_lastViewControllerViewed release];
#endif
    _lastViewControllerViewed = [[NSString alloc] initWithString: title];
    
    NSMutableDictionary *myEventData = [[NSMutableDictionary alloc] initWithDictionary:eventData ];
    if (isAuto) {
        [myEventData setObject: TealiumEventDataTrackTypeValueAuto forKey: TealiumEventDataTrackTypeKey ];
    } 
    [myEventData setObject: title forKey: TealiumEventDataScreenTitleKey ];
#ifdef DEBUG
    NSLog(@"Screen with title %@ is being tracked",title);
#endif

    [self trackCustomEvent: TealiumEventView withEventData: eventData ];
#if !(__has_feature(objc_arc))
    [myEventData release];
#endif
}

- (void) trackScreenViewedWithTitle:(NSString *)title 
                     wasAutoTracked:(BOOL) isAuto {
    [self trackScreenViewedWithTitle: title
                       withEventData: nil
                      wasAutoTracked: isAuto];
}

- (void) trackScreenViewedWithTitle:(NSString *)title 
                      withEventData:(NSDictionary *)eventData {
    [self trackScreenViewedWithTitle: title
                       withEventData: eventData
                      wasAutoTracked: NO];
}

- (void) trackScreenViewedWithTitle:(NSString *)title {
    [self trackScreenViewedWithTitle: title
                       withEventData: nil
                      wasAutoTracked: NO];
}

- (void) trackItemClicked:(NSString *)clickableItemId 
            withEventData:(NSDictionary *) eventData {
    NSMutableDictionary *myEventData = [[NSMutableDictionary alloc] initWithDictionary:eventData];
    [myEventData setObject:clickableItemId forKey:TealiumEventDataClickableItemIdKey];
#ifdef DEBUG
    NSLog(@"Item %@ was click",clickableItemId);
#endif
    [self trackCustomEvent: TealiumEventItemClicked withEventData: myEventData];
#if !(__has_feature(objc_arc))
    [myEventData release];
#endif
    
}

- (void) trackItemClicked:(NSString*) clickableItemId {
    [self trackItemClicked:clickableItemId withEventData:nil];   
} 



- (NSDictionary *)getCompositeDictionaryWithDictionary:(NSDictionary *)optionalDictionary {
    NSMutableDictionary *baseDict = [[NSMutableDictionary alloc] initWithDictionary:[self baseUTagVariables]];
    [baseDict addEntriesFromDictionary:[self baseCustomerUTagVariables]];
    [baseDict addEntriesFromDictionary:optionalDictionary];
#if __has_feature(objc_arc)
    return baseDict;
#else
    return [baseDict autorelease];
#endif
}

- (void) trackCustomEvent:(NSString*) eventType withEventData: (NSDictionary*)eventData {
    
    NSDictionary *finalItem = [self getCompositeDictionaryWithDictionary:eventData];
#ifdef DEBUG
    NSLog(@"Adding item of Type: %@ to queue with data: %@",eventType, finalItem);
#endif

    [self addToQueue:eventType utagItem:finalItem];
}


 
- (void) addToQueue: (NSString*) trackType utagItem:(NSDictionary*) item {
    
    if (!_tealiumEnabled) {
#ifdef DEBUG
        NSLog(@"A Tealium iOSTagger track message was sent, but this tealium object has already been put to sleep. Maybe you just forgot to send the 'wakeUp' message to the tealium instance?");
#endif
        return;
    }
    
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:item 
                                                       options:0
                                                         error:&error];
    
    if (jsonData != nil) {
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSString* utagCommand = [NSString stringWithFormat:@"track('%@', '%@')", trackType, jsonString];
        
        NSString* utagCommand = [NSString stringWithFormat:@"utag.track('%@', %@)", trackType, jsonString];
#if !__has_feature(objc_arc)
        [jsonString release];
        jsonString = nil;
#endif
        @synchronized(_eventQueue) {
            [_eventQueue addObject:utagCommand];
        }
    }
    
    [self trySendingQueuedUTagItems];
}

- (void) trySendingQueuedUTagItems {
    //first check if the timer is already running
    //If so, just exit so it doesn't double up on itself
    if (_timerIsRunning)
        return;
    
    //start the background timer if the network is reachable and of there
    //are events queued. This timer will quickly send all the pixels in a controlled manner.
    if (_tealiumEnabled && _networkReachable && _webViewReady && _eventQueue.count > 0) {
        [self scheduleNextQueuedUTagItem];
    }
}

- (void) scheduleNextQueuedUTagItem {
    _timerIsRunning = true;
    
    //do not set this to repeat, as this may cause the sendItem message to double
    //up on itself, if it happens to execute slower than the interval
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(queueTimerTriggered:) userInfo:nil repeats:NO];
}

-(void) queueTimerTriggered:(NSTimer*)timer {
    if (_eventQueue == nil || _eventQueue.count == 0) {
        _timerIsRunning = false;
        return;
    }
    
    //pop the first item off the queue
    NSString* itemToSend = nil;
    @synchronized(_eventQueue) {
#if __has_feature(objc_arc)
        itemToSend = [_eventQueue objectAtIndex:0];
#else
        itemToSend = [[_eventQueue objectAtIndex:0] retain];
#endif
        [_eventQueue removeObjectAtIndex:0]; 
    }
    
    //fire the item into the utag javascript code for processing
    if (itemToSend != nil && _networkReachable && _webViewReady) {
#ifdef DEBUG
        NSLog(@"Eval the following Javascript: %@",itemToSend);
#endif
       NSString *result = [_webView stringByEvaluatingJavaScriptFromString:itemToSend];

#if !__has_feature(objc_arc)
        [itemToSend release];
#endif
    }
    
    //now schedule the next one
    [self scheduleNextQueuedUTagItem]; 
}

#pragma mark UINavigationController Delegate Functions

- (void)navigationController:(UINavigationController*) navigationController didShowViewController:(UIViewController*)viewController animated:(BOOL) animated {
    
    if (!autoViewTrackingEnabled)
        return;
    [self trackScreenViewedWithViewController:viewController 
                                wasAutoTracked:YES];
    // TODO
    // Add proxing to original delegate, here
    NSArray *navPair = [autoTrackedNavigationControllers objectForKey:[NSNumber numberWithInt:[navigationController hash]]];
    if ([navPair objectAtIndex:NavPairDelegateIndex] != [NSNull null]) {
        id<UINavigationControllerDelegate> delegate = [navPair objectAtIndex:NavPairDelegateIndex];
        if([delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]){
            [delegate navigationController:navigationController
                     didShowViewController:viewController
                                  animated:animated];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Add proxing to original delegate, here
    NSArray *navPair = [autoTrackedNavigationControllers objectForKey:[NSNumber numberWithInt:[navigationController hash]]];
    if ([navPair objectAtIndex:NavPairDelegateIndex] != [NSNull null]) {
        id<UINavigationControllerDelegate> delegate = [navPair objectAtIndex:NavPairDelegateIndex];
        if([delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]){
            [delegate navigationController:navigationController
                     didShowViewController:viewController
                                  animated:animated];
        }
    } 
}

#pragma mark webview Delegate Functions.

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _webViewReady = YES;
    [self trySendingQueuedUTagItems];
}


#pragma mark Memory Management Functions

#if !(__has_feature(objc_arc))
-(void)dealloc
{
#ifdef DEBUG
    NSLog(@"Tealium: dealloc");
#endif
    
// These are set in the init function.
    [_account release];
    _account = nil;
    [_profile release];
    _profile = nil;
    [_environment release];
    _environment = nil;
    
    
// These are set by initializeWebView
    [_webView setDelegate: nil];
    [_webView release];
    _webView = nil;
    [_baseUTagVariables release];
    _baseUTagVariables = nil;
    
// Now it's time to stop the reachablity
    if ( _reach != nil ) {
        [_reach stopNotifier];
        [_reach release];
        _reach = nil;
    }
    
// These are set in wakeUp
    
    [_eventQueue release];
    _eventQueue = nil;
    
// Need to release and remove delegate for this.
    
    for (NSArray *navPair  in [autoTrackedNavigationControllers allValues]) {
        [(UINavigationController *)[navPair objectAtIndex:NavPairUINavigationControllerIndex] setDelegate:nil];
    }
    [autoTrackedNavigationControllers release];
    autoTrackedNavigationControllers = nil;
    
// Need to release
    [_lastViewControllerViewed release];
    _lastViewControllerViewed = nil;
    
    [_baseCustomerUTagVariables release];
    _baseCustomerUTagVariables = nil;
    
    [super dealloc];
    

}
#endif





@end
