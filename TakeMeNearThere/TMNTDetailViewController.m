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
    __weak IBOutlet UILabel *longLabel;
    __weak IBOutlet UILabel *latLabel;
    __weak IBOutlet UILabel *zipLabel;
    __weak IBOutlet UILabel *phoneLabel;
    __weak IBOutlet UILabel *stateLabel;
    __weak IBOutlet UILabel *addressLabel;
    __weak IBOutlet UIImageView *imageRatingView;
}
@end

@implementation TMNTDetailViewController

@synthesize businessNameForLabel, businessLong, businessLat, businessZip, businessAddress, businessImageRating, businessPhoneNumber, businessState;

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
    latLabel.text = [NSString stringWithFormat:@"%@",businessLat];
    longLabel.text = [NSString stringWithFormat:@"%@",businessLong];
    zipLabel.text = businessZip;
    phoneLabel.text = businessPhoneNumber;
    stateLabel.text = businessState;
    addressLabel.text = businessAddress;
    
    NSURL *urlString = [NSURL URLWithString:businessImageRating];
    UIImage *ratingImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlString]];
    [imageRatingView setImage:ratingImage];
    
    NSLog(@"%@",businessZip);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
