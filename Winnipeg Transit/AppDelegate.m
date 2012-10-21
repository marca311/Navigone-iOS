//
//  AppDelegate.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-02.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#import "AppDelegate.h"
#import "navigoViewController.h"
#import "timetableViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*UIViewController *navigoVC = [[navigoViewController alloc]initWithNibName:@"NavigoView" bundle:nil];
    //UIViewController *timetableVC = [[timetableViewController alloc]initWithNibName:@"TheNib" bundle:nil];
    self.window.rootViewController = navigoVC;
    [self.window makeKeyAndVisible];*/
    
    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc]init];
    [appDefaults setObject:@"4" forKey:@"walk_speed"];
    [appDefaults setObject:@"20" forKey:@"max_walk_time"];
    [appDefaults setObject:@"0" forKey:@"min_transfer_wait_time"];
    [appDefaults setObject:@"20" forKey:@"max_transfer_time"];
    [appDefaults setObject:@"0" forKey:@"max_transfers"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    
    if (IS_IPHONE_5) {
        <#statements#>
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
