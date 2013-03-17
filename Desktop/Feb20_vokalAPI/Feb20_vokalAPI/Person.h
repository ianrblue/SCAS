//
//  Person.h
//  Feb20_vokalAPI
//
//  Created by Nathan Levine on 3/11/13.
//  Copyright (c) 2013 Genius and Madness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * photoURL;

@end
