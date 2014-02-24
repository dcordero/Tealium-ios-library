//
//  TealiumiOSTagger.m
//  TealiumiOSTagger
//
//  Created by Charles Glommen.
//  Extended by Gautam Day & Jason Koo
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
#define UUIDKey @"com.tealium.uuid"

//Uncomment below #if-block if you are NOT using your own NSLog silencing macro
//#ifndef __OPTIMIZE__
//# define NSLog(...) NSLog(__VA_ARGS__)
//#else
//# define NSLog(...) {}
//#endif

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

// AutoTracking
NSString * const TealiumGlobalAutoTitles = @"auto_titles";


TealiumiOSTagger *_sharedTaggerInstance;

+ (TealiumiOSTagger*) initSharedInstance: accountName 
                           profile: (NSString*) profileName 
                            target: (NSString*) environmentName 
              navigationController: (UINavigationController*) firstNavigationController {
    

    if( _sharedTaggerInstance ){
        NSLog(@"%s:%d: initInstance called twice.", __FUNCTION__, __LINE__);
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
    NSLog(@"%s:%d: getInstance is deprecated in favor of sharedInstance, which is a drop-in replacment for this call.", __FUNCTION__, __LINE__);
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
    NSLog(@"%s:%d: initializing Tealium iOSTagger...", __FUNCTION__, __LINE__);
    
    if (firstNavigationController) autoViewTrackingEnabled = YES;
    else autoViewTrackingEnabled = NO;
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
    [self listenForDelegateNotifications];
    [self createDefaultAutoTitles];
    
    NSLog(@"%s:%d: Tealium iOSTagger initialized and started.", __FUNCTION__, __LINE__);
    
    return self;
}

- (void) listenForDelegateNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wakeUp) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sleep) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sleep) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sleep) name:UIApplicationWillTerminateNotification object:nil];
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
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSString *application_name = [bundle objectForKey:@"CFBundleName"];
    __TealiumReachability *reach = [self reachabilityObject];
    NSString *reachabilityType = [reach currentReachabilityString];
    NSString *carrier = [self carrier];
    NSString *uuid = [self retrieveUUID];
    
    if (_baseUTagVariables == nil) {
        _baseUTagVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"ios", @"platform",
                              osVersion, @"OS_version",
                              [[UIDevice currentDevice] model], @"device",
                              application_version, @"app_version",
                              application_name, @"app_name",
                              reachabilityType, @"connection_type",
                              carrier, @"carrier",
                              uuid, @"uuid",
                              nil];
    }
    NSLog(@"%s: baseUTagVariables:%@", __FUNCTION__, _baseUTagVariables);

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

- (NSString*) carrier{
    NSString *carrier = @"(Unknown carrier)";
    
    if (NSClassFromString(@"CTTelephonyNetworkInfo")){
        CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *car = [netinfo subscriberCellularProvider];
        carrier = car.carrierName;
#if !(__has_feature(objc_arc))
        if (netinfo != nil) [netinfo release];
#endif
    }
    return carrier;
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
            NSLog(@"%s:%d: Tealium Tagger sleep called, but is already asleep.", __FUNCTION__, __LINE__);
            return;
        }
        NSLog(@"%s:%d: Tealium tagger going to sleep.", __FUNCTION__, __LINE__);
        [[self reachabilityObject] stopNotifier];
        _tealiumEnabled = NO;
        [[NSUserDefaults standardUserDefaults] setObject:_eventQueue forKey:@"_tealium_tagger_"];
    }
}

-(void) wakeUp {
    @synchronized(self) {
        if (_tealiumEnabled) {
            NSLog(@"%s:%d: Tealium Tagger wakeup called, but is already active.", __FUNCTION__, __LINE__);
            return;
        }

        NSLog(@"%s:%d: Tealium Tagger is waking up.", __FUNCTION__, __LINE__);
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


#pragma mark - Tealium API

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

-(NSString*)autoTrackTitleForObject:(id) object{
    
    NSArray *autoTitles = [self autoTitlesForObject:object];
    __block NSString *title;
    [autoTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([object valueForKey:obj]){
            title = [object valueForKey:obj];
            *stop = YES;
        }
    }];
    if (!title) title = @"(Unnamed View)";
    
    return title;
}

-(NSArray*) autoTitlesForObject:(id)object{
    
    NSArray *autoTitles = [_autoTitles objectForKey:(id)[object class]];
    if (!autoTitles) autoTitles = [_autoTitles objectForKey:TealiumGlobalAutoTitles];
    return autoTitles;
}

-(void) createDefaultAutoTitles{
    NSArray *defaults = [NSArray arrayWithObjects:@"title", @"nibName", nil];
    _autoTitles = [NSMutableDictionary dictionaryWithObjectsAndKeys:defaults, TealiumGlobalAutoTitles, nil];
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
        title = [self autoTrackTitleForObject:viewController];
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
    NSLog(@"%s:%d: Screen with title \"%@\" is being tracked.", __FUNCTION__, __LINE__, title);

    [self trackCustomEvent: TealiumEventView withEventData: myEventData ];

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

- (void) trackItemClicked:(NSString*) clickableItemId {
    [self trackItemClicked:clickableItemId withEventData:nil];
}

- (void) trackItemClicked:(NSString *)clickableItemId 
            withEventData:(NSDictionary *) eventData {
    NSMutableDictionary *myEventData = [[NSMutableDictionary alloc] initWithDictionary:eventData];
    [myEventData setObject:clickableItemId forKey:TealiumEventDataClickableItemIdKey];
    NSLog(@"%s:%d: Item %@ was tapped", __FUNCTION__, __LINE__, clickableItemId);
    [self trackCustomEvent: TealiumEventItemClicked withEventData: myEventData];
#if !(__has_feature(objc_arc))
    [myEventData release];
#endif
    
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
    NSLog(@"%s:%d: Adding item of Type: %@ to queue with data: %@", __FUNCTION__, __LINE__, eventType, finalItem);
    [self addToQueue:eventType utagItem:finalItem];
}


 
- (void) addToQueue: (NSString*) trackType utagItem:(NSDictionary*) item {
    
    if (!_tealiumEnabled) {
        NSLog(@"%s:%d: A Tealium iOSTagger track message was sent, but this tealium object has already been put to sleep. Maybe you just forgot to send the 'wakeUp' message to the tealium instance?", __FUNCTION__, __LINE__);
        return;
    }
    
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:item 
                                                       options:0
                                                         error:&error];
    
    if (jsonData != nil) {
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
    
    //start the background timer if the network is reachable and if there
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
        NSLog(@"%s:%d: Eval the following Javascript: %@", __FUNCTION__, __LINE__, itemToSend);
        
       NSString *result = [_webView stringByEvaluatingJavaScriptFromString:itemToSend];
        if (result != nil){
            NSLog(@"%s: %d: Javescript returned an unexpected result: %@", __FUNCTION__, __LINE__, result);
        }

#if !__has_feature(objc_arc)
        [itemToSend release];
#endif
    }
    
    //now schedule the next one
    [self scheduleNextQueuedUTagItem]; 
}

#pragma mark - UINavigationController Delegate Functions

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

#pragma mark - Webview Delegate Functions.

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _webViewReady = YES;
    [self trySendingQueuedUTagItems];
}

#pragma mark - UUID Functions

-(NSString*) retrieveUUID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentUUID = [defaults objectForKey:UUIDKey];
    
    if (!currentUUID || [currentUUID isEqualToString:@""]){
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef stringUUID = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        currentUUID = (__bridge NSString *)stringUUID;
        [defaults setObject:currentUUID forKey:UUIDKey];
        [defaults synchronize];
    }
    
    return currentUUID;
}

-(BOOL) setUUID:(NSString *)uuid{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:uuid forKey:UUIDKey];
    [defaults synchronize];
    
    NSString *checkUUID = [defaults objectForKey:UUIDKey];
    if ([checkUUID isEqualToString:uuid]) return TRUE;
    else return FALSE;
}

#pragma mark - Memory Management Functions

#if !(__has_feature(objc_arc))
-(void)dealloc
{
    NSLog(@"%s:%d", __FUNCTION__, __LINE__);
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
    
// Remove notification listeners
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
    

}
#endif





@end
