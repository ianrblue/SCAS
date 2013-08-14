//
//  TMNTDataSourceDelegate.h
//  TakeMeNearThere
//
//  Created by Dexter Teng on 3/7/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TMNTDataSourceDelegate <NSObject>

- (void)grabYelpArray:(NSArray *)data;

- (void)grabFlickrArray:(NSArray *)data;
@end
