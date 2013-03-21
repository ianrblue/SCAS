//
//  TMNTDetailViewController.h
//  TakeMeNearThere
//
//  Created by Ian Blue on 3/20/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TMNTDetailViewController : UIViewController

@property (strong, nonatomic) NSString *businessNameForLabel;
@property (strong, nonatomic) NSNumber *businessLat;
@property (strong, nonatomic) NSNumber *businessLong;
@property (strong, nonatomic) NSString *businessZip;

@property (strong, nonatomic) NSString *businessState;
@property (strong, nonatomic) NSString *businessAddress;
@property (strong, nonatomic) NSString *businessPhoneNumber;
@property (strong, nonatomic) NSString *businessImageRating;
@property (strong, nonatomic) NSString *businessThumbnail;
@property (assign, nonatomic) CLLocation *userLocation;


@end
