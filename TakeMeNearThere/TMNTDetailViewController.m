//
//  TMNTDetailViewController.m
//  TakeMeNearThere
//
//  Created by Ian Blue on 3/20/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "TMNTDetailViewController.h"

@interface TMNTDetailViewController ()
{
    __weak IBOutlet UILabel *businessNameLabel;
    
}
@end

@implementation TMNTDetailViewController

@synthesize businessNameForLabel;

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
    businessNameLabel.text = businessNameForLabel;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
