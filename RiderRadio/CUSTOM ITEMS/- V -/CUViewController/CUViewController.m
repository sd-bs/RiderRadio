//
//  CUViewController.m
//  RiderRadio
//
//  Created by Fabien Moussavi on 14/09/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "CUViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "OnAirViewController.h"
#import "MixesViewController.h"
#import "ReplaysViewController.h"
#import "FreshnewsViewController.h"
#import "InfosViewController.h"


@interface CUViewController ()
@end

@implementation CUViewController
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
        self.oldVolume = .25f;
        self.currentMountsTitle = @"";
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
    
    // UI
    [self.aivBackground.layer setCornerRadius:5.f];
    
    // Status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // On Air
    // Backing view
//    DEBUG_LAYER(self.volume_View, blackColor)
    
    // Volume slider
    [self.mpVolumeView setShowsRouteButton:NO];
    [self.mpVolumeView setShowsVolumeSlider:YES];
    
    // available since iOS 5
    [[UISlider appearanceWhenContainedIn:
      [MPVolumeView class], nil] setMinimumTrackImage:[[UIImage imageNamed:@"img_minTrack"]
                                                       resizableImageWithCapInsets:UIEdgeInsetsMake(3, 13, 3, 13)] forState:UIControlStateNormal];
    [[UISlider appearanceWhenContainedIn:
      [MPVolumeView class], nil] setMaximumTrackImage:[[UIImage imageNamed:@"img_maxTrack"]
                                                       resizableImageWithCapInsets:UIEdgeInsetsMake(3, 13, 3, 13)] forState:UIControlStateNormal];
    
    // Load the WebView
    [self loadWebView];
    self.webView.scrollView.bounces = NO;
}

//**/
- (void)viewWillAppear:(BOOL)animated
{
    // Set the volume slider button skin
    if ([self isKindOfClass:OnAirViewController.class]) {
        [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setThumbImage:[UIImage imageNamed:@"btn_volume_cursor"] forState:UIControlStateNormal];
        [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setThumbImage:[UIImage imageNamed:@"btn_volume_cursor"] forState:UIControlStateHighlighted];
    }
    else {
        [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setThumbImage:[UIImage imageNamed:@"btn_volume_cursor_negatif"] forState:UIControlStateNormal];
        [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setThumbImage:[UIImage imageNamed:@"btn_volume_cursor_negatif"] forState:UIControlStateHighlighted];
    }
    
    // Select the mute button if the volume is down
    if (0.f == [[MPMusicPlayerController applicationMusicPlayer] volume]) {
        [self.mute_Btn setSelected:YES];
        [self.mpVolumeView setUserInteractionEnabled:NO];
    }
    
    [self restartPlayingFromBackgrounded];
}


///////////////////////
#pragma mark - IBAction
//====================================================================================================//
//                                            IBAction                                                //
//====================================================================================================//
//**/
- (IBAction)popViewController:(UIButton *)button
{
    [self goBack];
}


/////////////////////
#pragma mark - Method
//====================================================================================================//
//                                             Method                                                 //
//====================================================================================================//
//**/
- (void)loadWebView
{
    if ([self isKindOfClass:MixesViewController.class]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_RIDER_RADIO_MIXES]
                                                   cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                               timeoutInterval:WEB_VIEW_CACHE_DURATION]];
    }
    else if ([self isKindOfClass:ReplaysViewController.class]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_RIDER_RADIO_REPLAYS]
                                                   cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                               timeoutInterval:WEB_VIEW_CACHE_DURATION]];
    }
    else if ([self isKindOfClass:FreshnewsViewController.class]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:
                                   [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_RIDER_RADIO_FRESHNEWS, [[NSLocale preferredLanguages] objectAtIndex:0]]]
                                                   cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                               timeoutInterval:WEB_VIEW_CACHE_DURATION]];
    }
}

//**/
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


/////////////////////
#pragma mark - On Air
//====================================================================================================//
//                                             On Air                                                 //
//====================================================================================================//
//**/
- (IBAction)mute:(UIButton *)button
{
    if (![button isSelected]) {
        [button setSelected:YES];
        self.oldVolume = [[MPMusicPlayerController applicationMusicPlayer] volume];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.f];
        [self.mpVolumeView setUserInteractionEnabled:NO];
    }
    else {
        [button setSelected:NO];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:self.oldVolume];
        [self.mpVolumeView setUserInteractionEnabled:YES];
    }
}

//**/
- (void)restartPlayingFromBackgrounded
{
    if (self.player) {
        if (!self.player.isPreparedToPlay)
            [self.player setContentURL:[NSURL URLWithString:URL_RIDER_RADIO_STREAMING_FLUX_WINAMP]];
        [self.player play];
    }
}

//**/
- (void)fillCurrentMountInformations
{
    // Fill the timeline label and resize it
    [self.timeline_Lbl setText:self.currentMountsTitle];
    
    // Set the timeline_Lbl label width
    [self setTimeLineUILabelWidth];
    
    // Start the timeline label animation
    [self scrollTimelineLabel];
    
    // Load the current mount thumbnail only if it's necessary
    if (![self.previousMountsTitle isEqualToString:self.currentMountsTitle])
        [self loadCurrentMountThumbnail];
}

//**/
- (void)setTimeLineUILabelWidth
{
    [self.timeline_Lbl setFrame:CGRectMake(self.timeline_Lbl.frame.origin.x,
                                           self.timeline_Lbl.frame.origin.y,
                                           [self.timeline_Lbl.text boundingRectWithSize:CGSizeMake(9999.f, self.timeline_Lbl.frame.size.height)
                                                                                options:NSStringDrawingUsesFontLeading
                                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:14.f]}
                                                                                context:nil].size.width,
                                           self.timeline_Lbl.frame.size.height)];
}

//**/
- (void)loadCurrentMountThumbnail
{
    // Get the current Mount title
//    NSString *mountsInfo = [self getCurrentMountTitle];
    NSString *mountsTitle = self.currentMountsTitle;
    
    // Set the current mount thumbnail
    __block UIImageView *imgView = self.currentSound_Img;
    [self.currentSound_Img setImageWithURLRequest:
     [NSURLRequest requestWithURL:
      [NSURL URLWithString:
       [[URL_RIDER_RADIO_CURRENT_SONG_JACKET stringByAppendingFormat:@"%@.jpg", mountsTitle] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]
                                    placeholderImage:[UIImage imageNamed:@"img_placeholder"]
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                NSLog(@"Succeed");
                                                NSLog(@"Image size width: %f height: %f", image.size.width, image.size.height);
                                                // TEST
                                                // ... utiliser un UIGraphicContext pour redessiner l'image en 300x300
                                                // FIN TEST
                                                [imgView setImage:image];
                                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                NSLog(@"Failed:");
                                                NSLog(@"%@", [[URL_RIDER_RADIO_CURRENT_SONG_JACKET stringByAppendingFormat:@"%@.jpg", mountsTitle] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]);
                                            }];
    
    // Save the current mount title
    self.previousMountsTitle = mountsTitle;
    NSLog(@"-- FIN --");
}


/////////////////////////
#pragma mark - WebService
//====================================================================================================//
//                                             WebService                                             //
//====================================================================================================//
//**/
- (void)getCurrentMountInfos
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_RIDER_RADIO_CURRENT_SONG_INFO]];
    
    // Set to no caching
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        self.currentMountsTitle = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [self fillCurrentMountInformations];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error.description);
    }];
    [operation start];
    
    [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(getCurrentMountInfos) userInfo:nil repeats:NO];
}


//////////////////////
#pragma mark - Sharing
//====================================================================================================//
//                                            Sharing                                                 //
//====================================================================================================//
//**/
- (IBAction)share:(UIButton *)button
{
    switch (button.tag) {
        case FACEBOOK_SHARE_BTN:
            [self shareWithFaceBook];
            break;
            
        case TWITTER_SHARE_BTN:
            [self shareWithTwitter];
            break;
            
        case EMAIL_SHARE_BTN:
            [self shareWithMail];
            break;
    }
}

//**/
- (void)shareWithFaceBook
{
    NSLog(@"Facebook sharing...");
    [self openFacebookSessionAndShareMounts:self.currentMountsTitle];
}

//**/
- (void)shareWithTwitter
{
    NSLog(@"Twitter sharing...");
    [self openTwitterSessionAndShareMounts:self.currentMountsTitle];
}

//**/
- (void)shareWithMail
{
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    [mail setMailComposeDelegate:self];
    
    // Set the mail object
    [mail setSubject:NSLocalizedString(@"Hey_Listen", @"")];
    
    // Get the mounts info for the body message
    // (The current string format is: <Artiste> - <Title>)
    NSArray *mountsInfo = [self.currentMountsTitle componentsSeparatedByString:@" - "];
    if (2 <= mountsInfo.count) {
        NSString *msgBody = [NSString stringWithFormat:@"%@\n%@ %@\n%@ %@",
                             NSLocalizedString(@"Heard_on_RR", @""),
                             NSLocalizedString(@"-Artist:", @""),
                             [mountsInfo objectAtIndex:0],
                             NSLocalizedString(@"-Title:", @""),
                             [mountsInfo objectAtIndex:1]];
        [mail setMessageBody:msgBody isHTML:NO];
    }
    
    // Add the image to the mail
    [mail addAttachmentData:UIImageJPEGRepresentation(self.currentSound_Img.image, 1) mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@.jpg", self.currentMountsTitle]];
    
    [self presentViewController:mail animated:YES completion:NULL];
}


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
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    if (!appDelegate.fbSession.isOpen) {
//        // Created a new session if it doesn't still exist
//        if (!appDelegate.fbSession || appDelegate.fbSession.state != FBSessionStateCreated) {
//            appDelegate.fbSession = [[FBSession alloc] init];
//        }
//        
//        // even though we had a cached token, we need to login to make the session usable
//        [appDelegate.fbSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//            [self shareCurrentMountsOnFacebook:mountsName];
//        }];
//    }
//    else {
//        [self shareCurrentMountsOnFacebook:mountsName];
//    }
}

//**/
- (void)shareCurrentMountsOnFacebook:(NSString *)mountsName
{
    NSLog(@"%@", [[URL_RIDER_RADIO_CURRENT_SONG_JACKET stringByAppendingFormat:@"%@.jpg", mountsName] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]);
    
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
//    [FBDialogs presentShareDialogWithLink:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_RIDER_RADIO_FRESHNEWS, [[NSLocale preferredLanguages] objectAtIndex:0]]]
//                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                      if(error) {
//                                          NSLog(@"Error: %@", error.description);
//                                      } else {
//                                          NSLog(@"Success!");
//                                      }
//                                  }];
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
        [vc setInitialText:[NSLocalizedString(@"Heard_on_RR_Twitter", @"") stringByAppendingFormat:@"\n%@", mountName]];
        // Adding an Image
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:[[URL_RIDER_RADIO_CURRENT_SONG_JACKET stringByAppendingFormat:@"%@.jpg", mountName] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
        [vc addImage:image];
        // Adding a URL
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_RIDER_RADIO_FRESHNEWS, [[NSLocale preferredLanguages] objectAtIndex:0]]];
        [vc addURL:url];
        // Setting a Completing Handler
        [vc setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            [self dismissViewControllerAnimated:YES completion:NULL];
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
#pragma mark - Mail Composer Delegate
//====================================================================================================//
//                                       Mail Composer Delegate                                       //
//====================================================================================================//
//**/
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


///////////////////////////////
#pragma mark - WebView Delegate
//====================================================================================================//
//                                         WebView Delegate                                           //
//====================================================================================================//
//**/
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.aivBackground setHidden:NO];
}

//**/
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.aivBackground setHidden:YES];
}

//**/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"WebView event Type: %d", navigationType);
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSLog(@"Le lien cliqué est: %@", request.URL.scheme);
    }
    return YES;
}

//**/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.aivBackground setHidden:YES];
    
//    UIAlertView *webViewLoadingAlert = [[UIAlertView alloc] initWithTitle:@"Web View loading failed"
//                                                                  message:@""
//                                                                 delegate:nil
//                                                        cancelButtonTitle:@"Ok"
//                                                        otherButtonTitles:nil, nil];
//    [webViewLoadingAlert show];
}


////////////////////////
#pragma mark - Animation
//====================================================================================================//
//                                            Animation                                               //
//====================================================================================================//
//**/ Launches the animation if the Artist name and the song title are larger than the UILabel width
- (void)scrollTimelineLabel
{
    if (self.timelineScrollingEnabled && 230.f < self.timeline_Lbl.frame.size.width) {
        self.timelineScrollingEnabled = NO;
        [UIView animateWithDuration:10.f animations:^{
            [self.timeline_Lbl setFrame:CGRectMake(-(self.timeline_Lbl.frame.size.width + 5.f),
                                                   self.timeline_Lbl.frame.origin.y,
                                                   self.timeline_Lbl.frame.size.width,
                                                   self.timeline_Lbl.frame.size.height)];
        } completion:^(BOOL finished) {
            [self.timeline_Lbl setFrame:CGRectMake(240.f,
                                                   self.timeline_Lbl.frame.origin.y,
                                                   self.timeline_Lbl.frame.size.width,
                                                   self.timeline_Lbl.frame.size.height)];
            [UIView animateWithDuration:3.f animations:^{
                [self.timeline_Lbl setFrame:CGRectMake(5.f,
                                                       self.timeline_Lbl.frame.origin.y,
                                                       self.timeline_Lbl.frame.size.width,
                                                       self.timeline_Lbl.frame.size.height)];
            } completion:^(BOOL finished) {
                self.timelineScrollingEnabled = YES;
                [self scrollTimelineLabel];
            }];
        }];
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

