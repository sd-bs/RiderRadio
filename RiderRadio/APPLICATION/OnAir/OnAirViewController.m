//
//  OnAirViewController.m
//  RiderRadio
//
//  Created by Fabien Moussavi on 14/09/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "OnAirViewController.h"
#import "Parallax.h"


@interface OnAirViewController ()
@end

@implementation OnAirViewController
///////////////////
#pragma mark - Init
//====================================================================================================//
//                                              INIT                                                  //
//====================================================================================================//
//**/
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


/////////////////////////////
#pragma mark - View lifecycle
//====================================================================================================//
//                                            LIFECYCLE                                               //
//====================================================================================================//
//**/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init the bool to manage the alert view about getting mounts infos
    self.isFirstAlert = YES;
    
    // Timeline layer
    [self.timeline_View.layer setMasksToBounds:YES];
    
    // Simply init the NSString for the previous mounts title
    // (Used to minimize the number of thumbnails downloading request)
    self.previousMountsTitle = [[NSString alloc] init];
    
    // Get Mounts information
    self.timelineScrollingEnabled = YES;
    [self getCurrentMountInfos];
    
    // Translate the view
    [ViewTranslater translate:self.view];
    
    // Parallax effect on the OnAir view
    [Parallax registerEffectForView:self.onAir_View withDepth:20];
    [Parallax registerEffectForView:self.facebook_Btn withDepth:20];
    [Parallax registerEffectForView:self.twitter_Btn withDepth:20];
    [Parallax registerEffectForView:self.mail_Btn withDepth:20];
}


/////////////////////
#pragma mark - Memory
//====================================================================================================//
//                                              MEMORY                                                //
//====================================================================================================//
//**/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

