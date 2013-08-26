//
//  RHTripInfoViewController.m
//  Rushour
//
//  Created by Nathan Levine on 6/23/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import "RHTripInfoViewController.h"

@interface RHTripInfoViewController ()

@end

@implementation RHTripInfoViewController
@synthesize commute;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupInitialAppearance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupInitialAppearance
{
    tripTitleLabel.text = [NSString stringWithFormat:@"%@ to %@", commute.startPlaceName, commute.endPlaceName];
    stopLabel.text = @"this will come from the api";
}
@end
