//
//  TMNTSecondVC.h
//  TakeMeNearThere
//
//  Created by Ian Blue on 3/24/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceVisited.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface TMNTSecondVC : UIViewController

@property PlaceVisited *placeVisitedSecondDetail;
@property (assign, nonatomic) CLLocation *userLocation;
@property (assign, nonatomic) CLLocationCoordinate2D coord;

@end
