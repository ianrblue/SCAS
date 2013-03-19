//
//  TMNTLocation.h
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface TMNTLocationTest : NSObject <CLLocationManagerDelegate>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

//- (TMNTLocationTest*)init;

//- (TMNTLocationTest *)initWithLatitude:(float)latitude andLongitude:(float)longitude;

//- (id)initWithCurrentLocationAndUpdates;

//ians stuff

- (id)initWithCurrentLocationAndUpdates;
- (void)startLocationUpdates;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

//- (void)updatePersonalCoordinates:(CLLocationCoordinate2D)newCoordinate;

@end

