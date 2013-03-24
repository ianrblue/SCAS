//
//  PlaceVisited.h
//  TakeMeNearThere
//
//  Created by Ian Blue on 3/24/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlaceVisited : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSNumber * isBookmarked;
@property (nonatomic, retain) NSString * ratingURL;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSDate * viewDate;

@end
