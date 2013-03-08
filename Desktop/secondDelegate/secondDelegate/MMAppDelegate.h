//
//  MMAppDelegate.h
//  secondDelegate
//
//  Created by Nathan Levine on 2/11/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMViewController;

@interface MMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MMViewController *viewController;

@end
