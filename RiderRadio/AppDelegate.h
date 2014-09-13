//
//  AppDelegate.h
//  RiderRadio
//
//  Created by Fabien Moussavi on 16/02/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HomeViewController.h"

// Facebook
#import <AVFoundation/AVFoundation.h>
//#import <FacebookSDK/FacebookSDK.h>

// Twitter
#import <Twitter/Twitter.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                  *window;
@property (strong, nonatomic) UINavigationController    *viewController;

// Facebook
//@property (strong, nonatomic) FBSession                 *fbSession;

@end

