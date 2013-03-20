//
//  TMNTLocation.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "TMNTLocationTest.h"
#import "TMNTAnnotation.h"

@implementation TMNTLocationTest
{
    CLLocationManager *locationManager;
    //from ian
    float newLatitude;
    float newLongitude;
    TMNTAnnotation *myAnnotation;
}
@synthesize coordinate;

//make our own version of cllocation, that currently is hard coded to MM
- (TMNTLocationTest *)init
{
    self = [super init];
    
    coordinate.latitude = 41.894032;
    coordinate.longitude = -87.634742;
    return self;
}

//- (TMNTLocationTest *)initWithLatitude:(float)latitude andLongitude:(float)longitude
//{
//    self = [super init];
//    coordinate.latitude = latitude;
//    coordinate.longitude = longitude;
//    return self;
//}

- (id)initWithCurrentLocationAndUpdates
{
    self = [super init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    [self startLocationUpdates];
    coordinate = CLLocationCoordinate2DMake(newLatitude, newLongitude);
    return self;
}
/*
- (BOOL) locationKnown
{
    
}

- (void)startUpdatingLocations
{
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* newestLocation = [locations objectAtIndex:0];
    NSLog(@"Hello world");
    if ( abs([newestLocation.timestamp timeIntervalSinceDate:[NSDate date]]) < 120)
    {
        self.coordinate = newestLocation.coordinate;
        NSLog(@"THIS IS THE LONGITUDE DUDE MOOD: %f", self.coordinate.longitude);
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
} */

- (void)startLocationUpdates
{
    if (locationManager==nil) {
        locationManager = [[CLLocationManager alloc]init];
    }
    locationManager.delegate = self;
    
    //firehose of updates
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"lat:%f - long:%f",newLocation.coordinate.latitude, newLocation.coordinate.longitude);
   // [self updatePersonalCoordinates:newLocation.coordinate];
    newLatitude=newLocation.coordinate.latitude;
    newLongitude=newLocation.coordinate.longitude;
}

//- (void)updatePersonalCoordinates:(CLLocationCoordinate2D)newCoordinate
//{
//    myAnnotation.coordinate = newCoordinate;
//}




@end

