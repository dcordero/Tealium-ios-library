//
//  ITTDetailViewController.h
//  TealiumiOSTaggerTestApp
//
//  Created by Charles Glommen.
//  Copyright (c) 2012 Tealium, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITTDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
