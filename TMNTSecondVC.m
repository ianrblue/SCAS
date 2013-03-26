//
//  TMNTSecondVC.m
//  TakeMeNearThere
//
//  Created by Ian Blue on 3/24/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "TMNTSecondVC.h"
#import "TMNTTableViewController.h"

@interface TMNTSecondVC ()
{
    __weak IBOutlet UINavigationItem *navBar;
    __weak IBOutlet UILabel *phoneLabel;
    __weak IBOutlet UIImageView *thumbnailImageView;
    __weak IBOutlet UIImageView *ratingImageView;
    __weak IBOutlet UILabel *stateLabel;
    __weak IBOutlet UILabel *addressLabel;
}
- (IBAction)phoneBtn:(UIButton *)sender;
- (IBAction)directionsBtn:(UIButton *)sender;
- (IBAction)tweetBtn:(id)sender;

@end

@implementation TMNTSecondVC

@synthesize placeVisitedSecondDetail, userLocation, coord;

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
    
    coord.longitude = (CLLocationDegrees)[placeVisitedSecondDetail.longitude doubleValue];
    coord.latitude = (CLLocationDegrees)[placeVisitedSecondDetail.latitude doubleValue];
    
    [self detailItemWithEntity];
}

-(void)detailItemWithEntity
{
    navBar.title = placeVisitedSecondDetail.title;
    //format the phone string
    NSString *firstThreeCharsPhone = [placeVisitedSecondDetail.phone substringToIndex:3];
    NSString *lastSevenCharsPhone = [placeVisitedSecondDetail.phone substringFromIndex:3];
    NSString *midThreeCharsPhone = [lastSevenCharsPhone substringToIndex:3];
    NSString *lastFourCharsPhone = [placeVisitedSecondDetail.phone substringFromIndex:6];
    NSString *formattedPhone = [NSString stringWithFormat:@"(%@) %@-%@",firstThreeCharsPhone, midThreeCharsPhone, lastFourCharsPhone];
    phoneLabel.text = formattedPhone;
    addressLabel.text = placeVisitedSecondDetail.address;
    stateLabel.text = [NSString stringWithFormat:@"%@, %@ %@", placeVisitedSecondDetail.city, placeVisitedSecondDetail.state, placeVisitedSecondDetail.zipCode];
    
    NSURL *urlStringForRating = [NSURL URLWithString:placeVisitedSecondDetail.ratingURL];
    UIImage *ratingImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlStringForRating]];
    [ratingImageView setImage:ratingImage];
    
    NSURL *urlStringForThumbnail = [NSURL URLWithString:placeVisitedSecondDetail.thumbnailURL];
    UIImage *thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlStringForThumbnail]];
    [thumbnailImageView setImage:thumbnailImage];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)phoneBtn:(id)sender
{
    NSString *telString = @"telprompt://";
    NSString *appendedString = [NSString stringWithFormat:@"%@%@", telString, placeVisitedSecondDetail.phone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appendedString]];
}

- (IBAction)directionsBtn:(UIButton *)sender
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
       // NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", startCoordinate.latitude, startCoordinate.longitude, coord.latitude, endCoordinate.longitude];
        //[[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
}

- (IBAction)tweetBtn:(id)sender
{
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"Tweet about your experience:)"];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send a tweet right now"
                                      delegate:self
                                      cancelButtonTitle:@"OK"                                                   
                                      otherButtonTitles:nil];
            [alertView show];
        }
}

+ (BOOL)openMapsWithItems:(NSArray *)mapItems launchOptions:(NSDictionary *)launchOptions
{
    return YES;
}
@end
