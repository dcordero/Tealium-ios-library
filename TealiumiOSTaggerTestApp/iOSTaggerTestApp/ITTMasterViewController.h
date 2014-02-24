//
//  ITTMasterViewController.h
//  TealiumiOSTaggerTestApp
//
//  Created by Charles Glommen.
//  Copyright (c) 2012 Tealium, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITTDetailViewController;

@interface ITTMasterViewController : UITableViewController

@property (strong, nonatomic) ITTDetailViewController *detailViewController;

@end
