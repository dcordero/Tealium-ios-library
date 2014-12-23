/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application-specific delegate class.
*/

#import "AAPLAppDelegate.h"
#import <TealiumLibrary/Tealium.h>

@interface AAPLAppDelegate() <UISplitViewControllerDelegate>
@end

@implementation AAPLAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    
    splitViewController.delegate = self;
    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;

    [Tealium initSharedInstance:@"tealiummobile" profile:@"demo" target:@"dev" options:0 globalCustomData:nil];

    return YES;
}

#pragma mark - UISplitViewControllerDelegate

- (UISplitViewControllerDisplayMode)targetDisplayModeForActionInSplitViewController:(UISplitViewController *)splitViewController {
    return UISplitViewControllerDisplayModeAllVisible;
}

@end
