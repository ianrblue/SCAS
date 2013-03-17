//
//  NNAppDelegate.h
//  CoPairCoreData
//
//  Created by Nathan Levine on 3/12/13.
//  Copyright (c) 2013 Nathan & Nirav incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
