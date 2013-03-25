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
    __weak IBOutlet UIButton *directionsBtnRef;
    __weak IBOutlet UIButton *phoneBtnRef;
    __weak IBOutlet UINavigationItem *navBar;
    __weak IBOutlet UILabel *longLabel;
    __weak IBOutlet UILabel *latLabel;
    __weak IBOutlet UILabel *zipLabel;
    __weak IBOutlet UILabel *phoneLabel;
    __weak IBOutlet UILabel *stateLabel;
    __weak IBOutlet UILabel *addressLabel;
    __weak IBOutlet UIImageView *imageRatingView;
    __weak IBOutlet UIImageView *thumbnail;
    BOOL bookmark;
    
    NSString *formattedPhone;
}
- (IBAction)bookmarkButton:(id)sender;

- (IBAction)takeMeThereBtn:(UIButton *)sender;
- (IBAction)phoneBtn:(UIButton *)sender;
@end

@implementation TMNTDetailViewController

@synthesize businessNameForLabel, businessLong, businessLat, businessZip, businessAddress, businessImageRating, businessPhoneNumber, businessState, businessThumbnail, userLocation, coord, myManagedObjectContext, persistedData, placevisted;

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
    navBar.title = businessNameForLabel;
    latLabel.text = [NSString stringWithFormat:@"%@",businessLat];
    longLabel.text = [NSString stringWithFormat:@"%@",businessLong];
    zipLabel.text = businessZip;
    
    //format the phone string
    NSString *firstThreeCharsPhone = [businessPhoneNumber substringToIndex:3];
    NSString *lastSevenCharsPhone = [businessPhoneNumber substringFromIndex:3];
    NSString *midThreeCharsPhone = [lastSevenCharsPhone substringToIndex:3];
    NSString *lastFourCharsPhone = [businessPhoneNumber substringFromIndex:6];
    formattedPhone = [NSString stringWithFormat:@"(%@) %@-%@",firstThreeCharsPhone, midThreeCharsPhone, lastFourCharsPhone];
    phoneLabel.text = formattedPhone;
    
    stateLabel.text = businessState;
    addressLabel.text = businessAddress;
    bookmark = YES;
    
    NSURL *urlStringForRating = [NSURL URLWithString:businessImageRating];
    UIImage *ratingImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlStringForRating]];
    [imageRatingView setImage:ratingImage];
    
    NSURL *urlStringForThumbnail = [NSURL URLWithString:businessThumbnail];
    UIImage *thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlStringForThumbnail]];
    [thumbnail setImage:thumbnailImage];
    
    //NSLog(@"%@",businessZip);
	// Do any additional setup after loading the view.
    
    coord.longitude = (CLLocationDegrees)[businessLong doubleValue];
    coord.latitude = (CLLocationDegrees)[businessLat doubleValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bookmarkButton:(id)sender
{
    placevisted.isBookmarked = [NSNumber numberWithBool:bookmark];
    NSError *error;
    if (![myManagedObjectContext save:&error])
    {
        NSLog(@"failed to save error: %@", [error userInfo]);
    }
}

- (IBAction)takeMeThereBtn:(id)sender
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"My Place"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    } else
    {
        //NSURL *url = [NSURL URLWithString:@"http://maps.google.com/maps?q=\'%f,%f\'", coord.latitude, coord.longitude];
        //[[UIApplication sharedApplication] openURL:url];
    }
}

+ (BOOL)openMapsWithItems:(NSArray *)mapItems launchOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (IBAction)phoneBtn:(UIButton *)sender
{
    NSString *telString = @"telprompt://";
    NSString *appendedString = [NSString stringWithFormat:@"%@%@", telString, businessPhoneNumber];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appendedString]];
}


@end
