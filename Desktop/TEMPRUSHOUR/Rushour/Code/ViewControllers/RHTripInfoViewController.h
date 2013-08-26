//
//  RHTripInfoViewController.h
//  Rushour
//
//  Created by Nathan Levine on 6/23/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commute.h"

@interface RHTripInfoViewController : UIViewController
{
    __weak IBOutlet UILabel *tripTitleLabel;
    __weak IBOutlet UILabel *stopLabel;
    __weak IBOutlet UITableView *tableView;
}


@property (nonatomic, strong) Commute *commute;

@end
