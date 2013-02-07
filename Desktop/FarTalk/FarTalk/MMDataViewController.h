//
//  MMDataViewController.h
//  FarTalk
//
//  Created by Nathan Levine on 2/6/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMDataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;

@end
