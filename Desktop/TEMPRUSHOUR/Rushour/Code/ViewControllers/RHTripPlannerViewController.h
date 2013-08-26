//
//  RHTripPlannerViewController.h
//  Rushour
//
//  Created by Nathan Levine on 6/13/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHPlacesTableViewController.h"
#import "Place.h"
#import "Commute.h"
#import "RHAppDelegate.h"

@interface RHTripPlannerViewController : UIViewController <PlacesTableViewControllerDelegate>
{
    __weak IBOutlet UILabel *startAddressLabel;
    __weak IBOutlet UILabel *endAddressLabel;
    
    __weak IBOutlet UIButton *wedBtn;
    __weak IBOutlet UIButton *tuesBtn;
    __weak IBOutlet UIButton *monBtn;
}
- (IBAction)startAddressBtn:(id)sender;
- (IBAction)endAddressBtn:(id)sender;

- (IBAction)monBtn:(id)sender;
- (IBAction)tuesBtn:(id)sender;
- (IBAction)wedBtn:(id)sender;
- (IBAction)thursBtn:(id)sender;
- (IBAction)friBtn:(id)sender;
- (IBAction)satBtn:(id)sender;
- (IBAction)sunBtn:(id)sender;

- (IBAction)schedBtn:(id)sender;

@property (nonatomic, strong) RHPlacesTableViewController *tableOfPlacesVC;
@property (nonatomic,strong) NSManagedObjectContext* myManagedObjectContext;




@end
