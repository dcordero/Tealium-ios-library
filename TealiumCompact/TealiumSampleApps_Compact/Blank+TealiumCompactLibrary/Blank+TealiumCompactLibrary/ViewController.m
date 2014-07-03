//
//  ViewController.m
//  Blank+TealiumCompactLibrary
//
//  Created by Jason Koo on 7/1/14.
//  Copyright (c) 2014 Tealium. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Tealium trackCallType:TealiumViewCall customData:nil object:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
