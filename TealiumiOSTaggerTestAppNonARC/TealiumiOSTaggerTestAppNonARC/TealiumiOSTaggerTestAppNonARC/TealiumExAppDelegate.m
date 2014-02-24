//
//  TealiumExAppDelegate.m
//  TealiumiOSTaggerTestAppNonARC
//
//  Created by Gautam Dey on 6/5/12.
//  Copyright (c) 2012 Tealium. All rights reserved.
//

#import "TealiumExAppDelegate.h"
#import "TealiumiOSTagger.h"

@implementation TealiumExAppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[self window] rootViewController]];
    [[self window] setRootViewController:navigationController];
    
    TealiumiOSTagger* tagger = [TealiumiOSTagger initInstance: @"account" 
                                                      profile: @"profile" 
                                                       target: @"prod" 
                                         navigationController: navigationController];
    tagger.autoViewTrackingEnabled = YES;
    [navigationController release];

    [[TealiumiOSTagger sharedInstance] trackItemClicked:@"start screen"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[TealiumiOSTagger sharedInstance] sleep];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[TealiumiOSTagger sharedInstance] sleep];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[TealiumiOSTagger sharedInstance] wakeUp];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[TealiumiOSTagger sharedInstance] sleep];
}

@end
