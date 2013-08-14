//
//  TMNTAppDelegate.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "TMNTAppDelegate.h"

@implementation TMNTAppDelegate
@synthesize myManagedObjectContext = managedObjectContext;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    //Setup for loading page
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:self.window.bounds];
    
    if (screenHeight == 480)
    {
        //Device is iPhone 4 or 4S in point height
        UIImage *image = [UIImage imageNamed:@"Default@2x.png"];
        if (!image)
        {
            NSLog(@" we failed to load the image during the screen thing in the didFinish.. in the AppDelegate at line 64");
        }
        imageView.image = image;
    
    }
    if (screenHeight == 568)
    {
        //Device is iPhone 5 in point height
        UIImage *image = [UIImage imageNamed:@"Default-568h@2x.png"];
        if (!image)
        {
            NSLog(@" we failed to load the image during the screen thing in the didFinish.. in the AppDelegate at line 74");
        }
        imageView.image = image;
    }
    [self.window addSubview:imageView];
    [self.window makeKeyAndVisible];
    [self.window bringSubviewToFront:imageView];
    [self performSelector:@selector(removeSplash:) withObject:imageView afterDelay:1];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *modelURL = [[NSBundle mainBundle]URLForResource:@"Model" withExtension:@"momd"];
    NSURL *sqliteURL = [documentsDirectory URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error;
    
    myManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    myPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:myManagedObjectModel];
    
    if ([myPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqliteURL options:nil error:&error])
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        
        managedObjectContext.persistentStoreCoordinator = myPersistentStoreCoordinator;
    }

    return YES;
}

-(void)removeSplash:(UIImageView*)splashView
{
    splashView.alpha = 1.0;
    [UIView animateWithDuration:1.5 animations:^{
        splashView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [splashView removeFromSuperview];
    }];
//    [UIView animateWithDuration:0.5 animations:^
//     {
//         splashView.alpha = 0.0f;
//     }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
