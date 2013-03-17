//
//  Person.h
//  Feb20_vokalAPI2
//
//  Created by Nathan Levine on 3/14/13.
//  Copyright (c) 2013 Genius and Madness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Freak, Geek;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) Freak *freak;
@property (nonatomic, retain) Geek *geek;

@end
