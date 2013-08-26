//
//  RHHomeViewController.h
//  Rushour
//
//  Created by Nathan Levine on 5/30/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHAppDelegate.h"
#import "Commute.h"
#import "RHTripInfoViewController.h"

@interface RHHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,
UIScrollViewDelegate>
{
    __weak IBOutlet UITableView *mainTableView;
    __weak IBOutlet UIScrollView *mainScrollView;
    __weak IBOutlet UIPageControl *mainPageControl;
}
- (IBAction)plusAction:(id)sender;

@property (nonatomic,strong) NSManagedObjectContext* myManagedObjectContext;

@end
