//
//  TMNTAnnotationTwo.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/21/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "TMNTAnnotationTwo.h"

@implementation TMNTAnnotationTwo

@synthesize coordinate,title,subtitle, zip, state, address, phoneNumber, ratingImage, thumbnail, bookmark, city;

- initWithPosition:(CLLocationCoordinate2D *)coords
            andZip: (NSString*)zip2
          andState: (NSString *)state2
        andAddress: (NSString *)address2
    andPhoneNumber: (NSString*)phone2
    andRatingImage: (NSString*)ratingImage2
      andThumbnail: (NSString*)thumbnail2
       andBookmark: (BOOL)bookmark2
           andCity: (NSString*)city2;
{
    if (self = [super init])
    {
        self.coordinate = *(coords);
        zip = zip2;
        state = state2;
        address = address2;
        phoneNumber = phone2;
        ratingImage = ratingImage2;
        thumbnail = thumbnail2;
        bookmark = bookmark2;
        city = city2;
    }
    return self;
}


@end
