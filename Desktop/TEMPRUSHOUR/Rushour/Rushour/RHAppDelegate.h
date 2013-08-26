//
//  RHAppDelegate.h
//  Rushour
//
//  Created by Nathan Levine on 5/30/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
