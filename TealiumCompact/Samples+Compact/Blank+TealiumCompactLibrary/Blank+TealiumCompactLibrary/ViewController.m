//
//  ViewController.m
//  Blank+TealiumCompactLibrary
//
//  Created by George Webster on 9/15/14.
//  Copyright (c) 2014 tealium. All rights reserved.
//

#import "ViewController.h"
#import <TealiumLibrary/Tealium.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Tealium trackCallType:TealiumViewCall customData:nil object:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
