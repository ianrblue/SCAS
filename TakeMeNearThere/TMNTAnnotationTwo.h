//
//  TMNTAnnotationTwo.h
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/21/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface TMNTAnnotationTwo : MKPointAnnotation <MKAnnotation>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) NSString *zip;
@property (assign, nonatomic) NSString *state;
@property (assign, nonatomic) NSString *address;
@property (assign, nonatomic) NSString *phoneNumber;
@property (assign, nonatomic) NSString *ratingImage;
@property (assign, nonatomic) NSString *thumbnail;
@property (assign, nonatomic) BOOL bookmark;
@property (assign, nonatomic) NSString *city;


- initWithPosition:(CLLocationCoordinate2D *)coords
            andZip: (NSString*)zip2
          andState: (NSString *)state2
        andAddress: (NSString *)address2
    andPhoneNumber: (NSString*)phone2
    andRatingImage: (NSString*)RatingImage2
      andThumbnail: (NSString*)thumbnail2
       andBookmark: (BOOL)bookmark2
           andCity: (NSString*)city2;

@end
