//
//  AppDelegate.m
//  RiderRadio
//
//  Created by Fabien Moussavi on 16/02/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "AppDelegate.h"
#import <Crashlytics/Crashlytics.h>


@implementation AppDelegate

//**/ Facebook
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Here goes the code to handle the links
                                      // Use the links to show a relevant view of your app to the user
                                      
                                      // For pushing directly to the OnAirViewController
                                      [self pushOnAirViewController];
                                  }];
    
    return urlWasHandled;
}

//**/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Crashlytics
    [Crashlytics startWithAPIKey:@"6470076a4e8d89c0ff40969b610709937de85a09"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    // ...
    
    // Audio player
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    // Window
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}

//**/
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Resign Active");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//**/
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Enter Background");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//**/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // ...
    NSLog(@"Enter Foreground");
    
    // Restart playing
    [self restartPlaying];
}

//**/
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"Become Active");
    
    // Restart playing
    [self restartPlaying];
}

//**/
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//**/
- (void)restartPlaying
{
    UIViewController *rootVC = (UIViewController *)[self.window.rootViewController.childViewControllers objectAtIndex:[self.window.rootViewController childViewControllers].count - 1];
    if ([rootVC isKindOfClass:CUViewController.class]) {
        NSLog(@"Restart playing");
        [(CUViewController *)rootVC restartPlayingFromBackgrounded];
    }
}

//**/
- (void)pushOnAirViewController
{
    UIViewController *rootVC = (UIViewController *)[self.window.rootViewController.childViewControllers objectAtIndex:[self.window.rootViewController childViewControllers].count - 1];
    if ([rootVC isKindOfClass:HomeViewController.class]) {
        [(HomeViewController *)rootVC pushSection:On_Air];
    }
}


@end

