//
//  AppDelegate.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/23/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoCollectionViewController.h"

#import "PhotoManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface AppDelegate () {
    PhotoManager *_photoManager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Create new window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // Set window to be the key window and put it in front of all other windows
    [self.window makeKeyAndVisible];
    
    // Create a root view controller for the window
    PhotoCollectionViewController *viewController = [[PhotoCollectionViewController alloc] initWithNibName:@"PhotoCollectionView" bundle:nil];
    self.window.rootViewController = viewController;
    
    return YES;
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

- (PhotoManager*)getSharedPhotoManager {
    // Create a shared instance of the photo manager
    if(!_photoManager) {
        _photoManager = [[PhotoManager alloc] init];
    }
    
    return _photoManager;
}

@end
