//
//  RHPlacesTableViewController.h
//  Rushour
//
//  Created by Nathan Levine on 6/16/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@protocol PlacesTableViewControllerDelegate <NSObject>

- (void)addPlaceNameFromTableviewWithPlace:(Place *)place;

@end

@interface RHPlacesTableViewController : UITableViewController
{
    
}

@property (nonatomic,strong) NSManagedObjectContext* myManagedObjectContext;
@property (nonatomic, weak) id <PlacesTableViewControllerDelegate> delegate;


@end
