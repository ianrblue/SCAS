//
//  RHPlaceAnnotation.m
//  Rushour
//
//  Created by Nathan Levine on 6/16/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import "RHPlaceAnnotation.h"

@implementation RHPlaceAnnotation
@synthesize coordinate, address;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord Location:(NSString *)location {
    if (self  = [super init]) {
        coordinate = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
        address = location;
    }
    return self;
}


@end
