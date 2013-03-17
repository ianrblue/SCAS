//
//  Geek.h
//  Feb20_vokalAPI2
//
//  Created by Nathan Levine on 3/14/13.
//  Copyright (c) 2013 Genius and Madness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Geek : NSManagedObject

@property (nonatomic, retain) NSSet *people;
@end

@interface Geek (CoreDataGeneratedAccessors)

- (void)addPeopleObject:(Person *)value;
- (void)removePeopleObject:(Person *)value;
- (void)addPeople:(NSSet *)values;
- (void)removePeople:(NSSet *)values;

@end
