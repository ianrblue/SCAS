//
//  TMNTBookmarks.h
//  TakeMeNearThere
//
//  Created by Ian Blue on 3/23/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceVisited.h"

@interface TMNTBookmarks : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property NSManagedObjectContext *myManagedObjectContext2;
@property PlaceVisited *placeVisted;
@property (strong, nonatomic) NSArray *historyPersistedArray1;


@end
