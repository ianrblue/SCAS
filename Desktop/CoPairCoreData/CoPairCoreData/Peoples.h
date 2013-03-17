//
//  Peoples.h
//  CoPairCoreData
//
//  Created by Nathan Levine on 3/12/13.
//  Copyright (c) 2013 Nathan & Nirav incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Peoples : NSManagedObject

@property (nonatomic, retain) NSString * faveColor;
@property (nonatomic, retain) NSNumber * shoeSize;
@property (nonatomic, retain) NSNumber * waistline;

@end
