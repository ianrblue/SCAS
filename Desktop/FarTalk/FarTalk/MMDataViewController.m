//
//  MMDataViewController.m
//  FarTalk
//
//  Created by Nathan Levine on 2/6/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "MMDataViewController.h"

@interface MMDataViewController ()

@end

@implementation MMDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
