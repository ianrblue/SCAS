//
//  Commute.h
//  Rushour
//
//  Created by Nathan Levine on 8/25/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Route;

@interface Commute : NSManagedObject

@property (nonatomic, retain) NSDate * arriveByTime;
@property (nonatomic, retain) NSNumber * endPlaceLat;
@property (nonatomic, retain) NSNumber * endPlaceLong;
@property (nonatomic, retain) NSString * endPlaceName;
@property (nonatomic, retain) NSNumber * friday;
@property (nonatomic, retain) NSNumber * monday;
@property (nonatomic, retain) NSNumber * saturday;
@property (nonatomic, retain) NSNumber * startPlaceLat;
@property (nonatomic, retain) NSNumber * startPlaceLong;
@property (nonatomic, retain) NSString * startPlaceName;
@property (nonatomic, retain) NSNumber * sunday;
@property (nonatomic, retain) NSNumber * thursday;
@property (nonatomic, retain) NSString * transportationMode;
@property (nonatomic, retain) NSNumber * tueday;
@property (nonatomic, retain) NSNumber * wednesday;
@property (nonatomic, retain) NSNumber * totalTime;
@property (nonatomic, retain) Route *routes;
@end

@interface Commute (CoreDataGeneratedAccessors)

- (void)addRoutesObject:(Route *)value;
- (void)removeRoutesObject:(Route *)value;
- (void)addRoutes:(NSSet *)values;
- (void)removeRoutes:(NSSet *)values;

@end
