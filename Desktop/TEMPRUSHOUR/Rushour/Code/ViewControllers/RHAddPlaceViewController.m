//
//  RHAddPlaceViewController.m
//  Rushour
//
//  Created by Nathan Levine on 6/16/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import "RHAddPlaceViewController.h"
#import "Place.h"
#import "RHAppDelegate.h"

@interface RHAddPlaceViewController ()

@end

@implementation RHAddPlaceViewController
@synthesize myManagedObjectContext;

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
    
    //pass the context
    RHAppDelegate *appDelegate = (RHAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.myManagedObjectContext = [appDelegate managedObjectContext];
    
    geoCoder = [[CLGeocoder alloc] init];
    userLocationManager = [[CLLocationManager alloc] init];
    [userLocationManager setDelegate:self];
    [userLocationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [userLocationManager startUpdatingLocation];
    CLLocation *userLocation = userLocationManager.location;
    
    //set span on opening map
    CLLocationCoordinate2D myCoordinate =
    {
        .latitude = userLocation.coordinate.latitude,
        .longitude = userLocation.coordinate.longitude
    };
    
    MKCoordinateSpan span =
    {
        .latitudeDelta = .009f,
        .longitudeDelta = .009f
    };
    
    MKCoordinateRegion myRegion = {myCoordinate, span};
    [myMapView setRegion:myRegion];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)findBtn:(id)sender
{
    //add pin to map
    [self geoCodeAddress:sender];
}

- (IBAction)saveBtn:(id)sender
{
    //add pin to the map and get lat/log
    [self geoCodeAddress:sender];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [addressTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    return YES;
}

#pragma mark - Mapview
- (IBAction)geoCodeAddress:(id)sender {  // same thing as using "Find" button
    [geoCoder geocodeAddressString:addressTextField.text completionHandler:^(NSArray *placeMarks,NSError *error) {
        if (error) {
            return;
        }
        
        if ([placeMarks count] > 0) {
            CLPlacemark *placemark = [placeMarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D placeCoordinate = location.coordinate;
            placeCoord = placeCoordinate;
            RHPlaceAnnotation *labAnnotation = [[RHPlaceAnnotation alloc] initWithCoordinate:placeCoordinate Location:nameTextField.text];
            [myMapView addAnnotation:labAnnotation];
            [myMapView setCenterCoordinate:placeCoordinate];
            
            //make place to save
            Place *placeToSave = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:myManagedObjectContext];
            placeToSave.name = nameTextField.text;
            placeToSave.address = addressTextField.text;
            placeToSave.latitude = [NSNumber numberWithDouble:(double)placeCoord.latitude];
            placeToSave.longitude = [NSNumber numberWithDouble:(double)placeCoord.longitude];
            
            //save it to core data
            NSError *error;
            if (![myManagedObjectContext save:&error])
            {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
            //popviewcontroller back to list
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:resultAnnotation reuseIdentifier:nil];
    pinView.enabled = YES;
    return pinView;
}
@end
