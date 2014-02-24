//
//  SamplesTableViewController.h
//  TealiumiOSTestApp
//
//  Created by Jason Koo on 9/30/13.
//  Copyright (c) 2013 Tealium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SamplesTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *testSwitch;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *testSegmentedControl;
@property (weak, nonatomic) IBOutlet UIStepper *testStepper;
@property (weak, nonatomic) IBOutlet UISlider *testSlider;
@property (weak, nonatomic) IBOutlet UITextField *testTextView;



@end
