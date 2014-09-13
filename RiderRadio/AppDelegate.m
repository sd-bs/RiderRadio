//
//  AppDelegate.m
//  RiderRadio
//
//  Created by Fabien Moussavi on 16/02/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "AppDelegate.h"


@implementation AppDelegate

//**/ Facebook
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.fbSession];
//}

//**/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    
    // For pushing directly to the OnAirViewController
//    UIViewController *rootVC = (UIViewController *)[self.window.rootViewController.childViewControllers objectAtIndex:[self.window.rootViewController childViewControllers].count - 1];
//    if ([rootVC isKindOfClass:HomeViewController.class]) {
//        NSLog(@"Push to On Air VC");
//        OnAirViewController *onAirVC = [[OnAirViewController alloc] init];
//        [onAirVC setPlayer:((HomeViewController *)rootVC).player];
//        [((HomeViewController *)rootVC).navigationController pushViewController:onAirVC animated:YES];
//    }
//    else
        // Restart playing
        [self restartPlaying];
    
    // Facebook
//    [FBAppCall handleDidBecomeActiveWithSession:self.fbSession];
}

//**/
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Facebook
//    [self.fbSession close];
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


@end

