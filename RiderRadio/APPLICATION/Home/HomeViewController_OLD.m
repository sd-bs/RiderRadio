//
//  HomeViewController_OLD.m
//  RiderRadio
//
//  Created by Fabien Moussavi on 16/02/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "HomeViewController_OLD.h"
#import "AppDelegate.h"


@interface HomeViewController_OLD ()
@end

@implementation HomeViewController_OLD
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
        // PanGestureRecognizer
        self.recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan)];
        self.recognizer.maximumNumberOfTouches = 1;
//        [self.view addGestureRecognizer:self.recognizer];
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
    
    // Replace/Resize elements for the two different screen height sizes
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    
    // Build panels
    // Left panel
    self.leftPanel = [[CULeftPanel alloc] initWithDelegate:self];
    [self.leftPanel setFrame:CGRectMake(self.view.frame.origin.x,
                                        self.view.frame.origin.y,
                                        self.leftPanel.frame.size.width,
                                        self.view.frame.size.height)];
    
    // Right panel
    self.rightPanel = [[CURightPanel alloc] initWithDelegate:self];
    [self.rightPanel setFrame:CGRectMake(55.f,
                                         self.view.frame.origin.y,
                                         self.rightPanel.frame.size.width,
                                         self.view.frame.size.height)];
    
    // Creates the new RootViewController (masterVC)
    self.masterNC = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] initWithDelegate:self]];
    [self.masterNC.navigationBar setHidden:YES];
    // Bullshit bug with status bar ... -_-
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        [self.masterNC.view setFrame:CGRectMake(0.f,
                                                -20.f,
                                                [[UIScreen mainScreen] bounds].size.width,
                                                [[UIScreen mainScreen] bounds].size.height + 20.f)];
    
    // Add all childs to the mother view
    [self.view addSubview:self.leftPanel];
    [self.view addSubview:self.rightPanel];
    [self.view addSubview:self.masterNC.view];
    
    // Facebook
//    [self updateFacebookConnectionState];
    [self connectToFacebook];
}

//**/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
        [self.masterNC viewWillAppear:animated];
    
    // No native navigation bar
    [self.navigationController.navigationBar setHidden:YES];
}

//**/
- (void)viewWillDisappear:(BOOL)animated
{
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
        [self.masterNC viewWillDisappear:animated];
}


/////////////////////
#pragma mark - Method
//====================================================================================================//
//                                             Method                                                 //
//====================================================================================================//


///////////////////////
#pragma mark - Facebook
//====================================================================================================//
//                                            Facebook                                                //
//====================================================================================================//
//**/ First connection launch on view did load
- (void)connectToFacebook
{
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    if (!appDelegate.fbSession.isOpen) {
//        // Created a new session if it doesn't still exist
//        appDelegate.fbSession = [[FBSession alloc] init];
//        
//        if (appDelegate.fbSession.state == FBSessionStateCreatedTokenLoaded) {
//            // even though we had a cached token, we need to login to make the session usable
//            [appDelegate.fbSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                // ...
//            }];
//        }
//    }
}

//**/ IBAction call by the Facebook button on the central panel
- (void)openFacebookSessionAndShareMounts:(NSString *)mountsName
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (!appDelegate.fbSession.isOpen) {
        // Created a new session if it doesn't still exist
        if (!appDelegate.fbSession || appDelegate.fbSession.state != FBSessionStateCreated) {
            appDelegate.fbSession = [[FBSession alloc] init];
        }
        
        // even though we had a cached token, we need to login to make the session usable
        [appDelegate.fbSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self shareCurrentMountsOnFacebook:mountsName];
        }];
    }
    else {
        [self shareCurrentMountsOnFacebook:mountsName];
    }
}

//**/
- (void)shareCurrentMountsOnFacebook:(NSString *)mountsName
{
    NSLog(@"%@", [[URL_MOUNTS_THUMBNAIL stringByAppendingFormat:@"%@.jpg", mountsName]
                  stringByReplacingOccurrencesOfString:@" " withString:@"%20"]);
    
    // OBJECT
    //
//    NSMutableDictionary<FBGraphObject> *object = [FBGraphObject openGraphObjectForPostWithType:@"music.song"
//                                                                      title:mountsName
//                                                                      image:[[URL_MOUNTS_THUMBNAIL stringByAppendingFormat:@"%@.jpg", mountsName]
//                                                                             stringByReplacingOccurrencesOfString:@" " withString:@"%20"]
//                                                                        url:URL_RIDER_RADIO
//                                                                description:@""];
//    
//    [FBRequestConnection startForPostWithGraphPath:@"me/objects/music.song"
//                                       graphObject:object
//                                 completionHandler:^(FBRequestConnection *connection,
//                                                     id result,
//                                                     NSError *error) {
//                                     // handle the result
//                                     NSLog(@"Error: %@", error.description);
//                                 }];
    
    // ACTION
    //
//    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
//    [action setObject:object forKey:@"song"];
//    [action setTags:[NSArray arrayWithObject:@"RiderRadio"]];
//    
//    [FBDialogs presentShareDialogWithOpenGraphAction:action
//                                          actionType:@"song:is_listening"
//                                 previewPropertyName:@"song"
//                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error.description);
//        } else {
//            NSLog(@"Success!");
//        }
//    }];
    
    
    // **/////*****///******///*****//** //
    // Very simple share (temp)
    // **/////*****///******///*****//** //
    [FBDialogs presentShareDialogWithLink:[NSURL URLWithString:URL_RIDER_RADIO_FRESHNEWS]
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          NSLog(@"Error: %@", error.description);
                                      } else {
                                          NSLog(@"Success!");
                                      }
                                  }];
    // **/////*****///******///*****//** //
}

////**/
//- (void)updateFacebookConnectionState
//{
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    
//    if (appDelegate.fbSession.isOpen) {
//        NSLog(@"The Facebook session is open");
//    }
//    else {
//        NSLog(@"The Facebook session is NOT open");
//    }
//}


//////////////////////
#pragma mark - Twitter
//====================================================================================================//
//                                            Twitter                                                 //
//====================================================================================================//
//**/
- (void)openTwitterSessionAndShareMounts:(NSString *)mountName
{
    if ([TWTweetComposeViewController canSendTweet]) {
        // Initialize Tweet Compose View Controller
        TWTweetComposeViewController *vc = [[TWTweetComposeViewController alloc] init];
        // Settin The Initial Text
        [vc setInitialText:[NSLocalizedString(@"Heard_on_RR", @"") stringByAppendingFormat:@"\n%@", mountName]];
        // Adding an Image
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:[[URL_MOUNTS_THUMBNAIL stringByAppendingFormat:@"%@.jpg", mountName] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
        [vc addImage:image];
        // Adding a URL
        NSURL *url = [NSURL URLWithString:URL_RIDER_RADIO_FRESHNEWS];
        [vc addURL:url];
        // Setting a Completing Handler
        [vc setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            [self dismissModalViewControllerAnimated:YES];
        }];
        // Display Tweet Compose View Controller Modally
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        // Show Alert View When The Application Cannot Send Tweets
        NSString *message = NSLocalizedString(@"No_Tweeter_Account_Joined_To_The_Device", @"");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", @"")
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}


/////////////////////////////////////
#pragma mark - CUCentralPanelDelegate
//====================================================================================================//
//                                      CUCentralPanelDelegate                                        //
//====================================================================================================//
//**/
- (void)pushPanelToCenter
{
    for (UIViewController *vc in self.masterNC.viewControllers) {
        if ([vc isKindOfClass:RootViewController.class]) {
            // CUCentralPanel
            [((RootViewController *)vc).centralPanel.navBar.left_Btn setSelected:NO];
            [((RootViewController *)vc).centralPanel.navBar.right_Btn setSelected:NO];
        }
    }
    
    [UIView animateWithDuration:.3f animations:^{
        [self.masterNC.view setFrame:CGRectMake(0,
                                                self.masterNC.view.frame.origin.y,
                                                self.masterNC.view.frame.size.width,
                                                self.masterNC.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [self hideAllOtherViews];
        self.last_x_slided = self.masterNC.view.frame.origin.x;
        [self enableSlides:YES];
    }];
}

//**/
- (void)pushPanelToRight
{
    for (UIViewController *vc in self.masterNC.viewControllers) {
        if ([vc isKindOfClass:RootViewController.class]) {
            // CUCentralPanel
            [((RootViewController *)vc).centralPanel.navBar.left_Btn setSelected:YES];
        }
    }
    
    [UIView animateWithDuration:.3f animations:^{
        [self.masterNC.view setFrame:CGRectMake(265.f,
                                                self.masterNC.view.frame.origin.y,
                                                self.masterNC.view.frame.size.width,
                                                self.masterNC.view.frame.size.height)];
    } completion:^(BOOL finished) {
        self.last_x_slided = self.masterNC.view.frame.origin.x;
        [self enableSlides:NO];
    }];
}

//**/
- (void)pushPanelToLeft
{
    for (UIViewController *vc in self.masterNC.viewControllers) {
        if ([vc isKindOfClass:RootViewController.class]) {
            // CUCentralPanel
            [((RootViewController *)vc).centralPanel.navBar.right_Btn setSelected:YES];
        }
    }
    
    [UIView animateWithDuration:.3f animations:^{
        [self.masterNC.view setFrame:CGRectMake(-265.f,
                                                self.masterNC.view.frame.origin.y,
                                                self.masterNC.view.frame.size.width,
                                                self.masterNC.view.frame.size.height)];
    } completion:^(BOOL finished) {
        self.last_x_slided = self.masterNC.view.frame.origin.x;
        [self enableSlides:NO];
    }];
}

//**/
- (void)enableSlides:(BOOL)enabled {}

//**/
- (void)hideAllOtherViews {}

//**/
- (void)displayLeftView
{
    [self.leftPanel setAlpha:1.f];
    [self.rightPanel setAlpha:0.f];
}

//**/
- (void)displayRightView
{
    [self.leftPanel setAlpha:0.f];
    [self.rightPanel setAlpha:1.f];
}



///////////////////////////////////
#pragma mark - CULeftPanelDelegate
//====================================================================================================//
//                                       CULeftPanelDelegate                                          //
//====================================================================================================//
//**/



///////////////////////////////////
#pragma mark - CURightPanelDelegate
//====================================================================================================//
//                                       CURightPanelDelegate                                         //
//====================================================================================================//
//**/



///////////////////////////////////
#pragma mark - PanGestureRecognizer
//====================================================================================================//
//                                       PanGestureRecognizer                                         //
//====================================================================================================//
//**/
- (void)handlePan
{
    BOOL longSlide = NO;
    
    // Touch began
    if (self.recognizer.state == UIGestureRecognizerStateBegan) {
        self.initial_x_centralPanel = self.masterNC.view.frame.origin.x;
        self.last_x_slided = self.masterNC.view.frame.origin.x;
    }
    // Touch changing
    else if (self.recognizer.state == UIGestureRecognizerStateChanged) {
        
        // Show the relevant subview
        if (0.f == floorf(self.initial_x_centralPanel)) {
            if (0.f < [self.recognizer translationInView:self.masterNC.view].x) {
                [self displayLeftView];
            } else {
                [self displayRightView];
            }
        }
        
        // Sliding management
        if (-265.f </* 0 <=*/ self.initial_x_centralPanel + [self.recognizer translationInView:self.masterNC.view].x
            && 265.f > self.initial_x_centralPanel + [self.recognizer translationInView:self.masterNC.view].x) {
            [self.masterNC.view setFrame:CGRectMake(self.initial_x_centralPanel + [self.recognizer translationInView:self.masterNC.view].x,
                                                    self.masterNC.view.frame.origin.y,
                                                    self.masterNC.view.frame.size.width,
                                                    self.masterNC.view.frame.size.height)];
        }
        else {
            longSlide = YES;
            if (-265.f < self.initial_x_centralPanel + [self.recognizer translationInView:self.masterNC.view].x)
                self.slidingDirection = LONG_SLIDE_TO_RIGHT;
            else if (265.f > self.initial_x_centralPanel + [self.recognizer translationInView:self.masterNC.view].x)
                self.slidingDirection = LONG_SLIDE_TO_LEFT;
        }
        
        // Check the slide direction
        if (self.last_x_slided == self.masterNC.view.frame.origin.x) {
            if (!longSlide)
                self.slidingDirection = NO_SLIDE;
        }
        else if (self.last_x_slided < self.masterNC.view.frame.origin.x)
            self.slidingDirection = RIGHT_SLIDE;
        else
            self.slidingDirection = LEFT_SLIDE;
        
        self.last_x_slided = self.masterNC.view.frame.origin.x;
    }
    // Touch ended
    else if (self.recognizer.state == UIGestureRecognizerStateEnded) {
        
        // The control began sliding from the center
        if (0.f == floorf(self.initial_x_centralPanel)) {
            // Show the relevant subview before pushing the central view
            switch (self.slidingDirection) {
                case LONG_SLIDE_TO_RIGHT:
                case RIGHT_SLIDE:
                    if (self.masterNC.view.frame.origin.x > self.initial_x_centralPanel) {
                        [self displayLeftView];
                        [self pushPanelToRight];
                    }
                    else
                        [self pushPanelToCenter];
                    break;
                    
                case LONG_SLIDE_TO_LEFT:
                case LEFT_SLIDE:
                    if (self.masterNC.view.frame.origin.x < self.initial_x_centralPanel) {
                        [self displayRightView];
                        [self pushPanelToLeft];
                    }
                    else
                        [self pushPanelToCenter];
                    break;
                    
                default:
                    if (!self.longSlide)
                        [self pushPanelToCenter];
                    break;
            }
        }
        // The control began sliding from the right
        else if (265.f == floorf(self.initial_x_centralPanel)) {
            if (265.f > self.masterNC.view.frame.origin.x) {
                switch (self.slidingDirection) {
                    case LONG_SLIDE_TO_LEFT:
                    case LEFT_SLIDE:
                        [self pushPanelToCenter];
                        break;
                        
                    default:
                        [self pushPanelToRight];
                        break;
                }
            }
        }
        // The control began sliding from the left
        else if (-265.f == floorf(self.initial_x_centralPanel)) {
            if (-265.f < self.masterNC.view.frame.origin.x) {
                switch (self.slidingDirection) {
                    case LONG_SLIDE_TO_RIGHT:
                    case RIGHT_SLIDE:
                        [self pushPanelToCenter];
                        break;
                        
                    default:
                        [self pushPanelToLeft];
                        break;
                }
            }
        }
        // The control began sliding from anywhere (special case)
        else
            [self pushPanelToCenter];
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
}


@end

