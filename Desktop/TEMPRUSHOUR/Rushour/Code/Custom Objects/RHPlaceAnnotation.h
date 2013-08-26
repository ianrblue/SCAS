//
//  RHPlaceAnnotation.h
//  Rushour
//
//  Created by Nathan Levine on 6/16/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RHPlaceAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord Location:(NSString *)location;


@end
