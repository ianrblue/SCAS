//
//  TMNTSecondVC.m
//  TakeMeNearThere
//
//  Created by Ian Blue on 3/24/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "TMNTSecondVC.h"

@interface TMNTSecondVC ()
{
    __weak IBOutlet UILabel *phoneLabel;
    
}

@end

@implementation TMNTSecondVC

@synthesize placeVisited, historyPersistedArray2, phoneThatIsATitleTest;

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
    //PlaceVisited *place = [historyPersistedArray2 objectAtIndex:[];
    //NSString *placeName = place.title;
    phoneLabel.text = phoneThatIsATitleTest;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
