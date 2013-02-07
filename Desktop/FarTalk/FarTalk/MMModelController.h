//
//  MMModelController.h
//  FarTalk
//
//  Created by Nathan Levine on 2/6/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMDataViewController;

@interface MMModelController : NSObject <UIPageViewControllerDataSource>

- (MMDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(MMDataViewController *)viewController;

@end
