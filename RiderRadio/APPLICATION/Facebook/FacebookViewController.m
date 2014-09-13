//
//  FacebookViewController.m
//  RiderRadio
//
//  Created by Fabien Moussavi on 11/06/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "FacebookViewController.h"
#import "AppDelegate.h"


@interface FacebookViewController ()
@end

@implementation FacebookViewController
///////////////////
#pragma mark - Init
//====================================================================================================//
//                                              INIT                                                  //
//====================================================================================================//
//**/
- (id)initWithDelegate:(id<CUCentralPanelDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
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
    [self updateFacebookConnectionState];
    [self connectToFacebook];
}


///////////////////////
#pragma mark - IBAction
//====================================================================================================//
//                                             IBAction                                               //
//====================================================================================================//
//**/
- (IBAction)buttonClickHandler:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.fbSession.isOpen) {
        [appDelegate.fbSession closeAndClearTokenInformation];
    }
    else {
        if (appDelegate.fbSession.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.fbSession = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.fbSession openWithCompletionHandler:^(FBSession *session,
                                                           FBSessionState status,
                                                           NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateFacebookConnectionState];
        }];
    }
}

//**/
- (IBAction)close
{
    [self dismissModalViewControllerAnimated:YES];
}


/////////////////////
#pragma mark - Method
//====================================================================================================//
//                                              Method                                                //
//====================================================================================================//
//**/
- (void)connectToFacebook
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (!appDelegate.fbSession.isOpen) {
        // Created a new session if it doesn't still exist
        appDelegate.fbSession = [[FBSession alloc] init];
        
        if (appDelegate.fbSession.state == FBSessionStateCreatedTokenLoaded) {
            NSLog(@"Passe par là ?");
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.fbSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                [self updateFacebookConnectionState];
            }];
        }
    }
}

//**/
- (void)updateFacebookConnectionState
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.fbSession.isOpen) {
        [self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
    }
    else {
        [self.buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
    }
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

