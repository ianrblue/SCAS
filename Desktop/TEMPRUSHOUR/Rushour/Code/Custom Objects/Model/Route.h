//
//  Route.h
//  Rushour
//
//  Created by Nathan Levine on 8/25/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Route : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * startStopName;
@property (nonatomic, retain) NSString * endStopName;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSString * name;

@end
