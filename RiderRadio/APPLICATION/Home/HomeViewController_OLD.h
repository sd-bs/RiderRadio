//
//  HomeViewController_OLD.h
//  RiderRadio
//
//  Created by Fabien Moussavi on 16/02/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Macros.h"

// Left view
#import "CULeftPanel.h"

// Central view
#import "RootViewController.h"

// Right view
#import "CURightPanel.h"

// Twitter
#import <Twitter/Twitter.h>


@interface HomeViewController_OLD : UIViewController <CULeftPanelDelegate, CUCentralPanelDelegate, CURightPanelDelegate>

@property (nonatomic, strong) UINavigationController            *masterNC;
@property (nonatomic, strong) CULeftPanel                       *leftPanel;
@property (nonatomic, strong) CURightPanel                      *rightPanel;

// PanGestureRecognizer
@property (nonatomic, strong) UIPanGestureRecognizer            *recognizer;
@property (nonatomic, assign) float                             initial_x_centralPanel;
@property (nonatomic, assign) float                             last_x_slided;
@property (nonatomic, assign) int                               slidingDirection;
@property (nonatomic, assign) BOOL                              longSlide;

- (void)enableSlides:(BOOL)enabled;
//- (void)displayLeftView;
//- (void)displayRightView;

// Method
// Facebook
- (void)openFacebookSessionAndShareMounts:(NSString *)mountsName;

// Twitter
- (void)openTwitterSessionAndShareMounts:(NSString *)mountName;

@end

