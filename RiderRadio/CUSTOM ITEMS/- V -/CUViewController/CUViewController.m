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
    [self.mpVolumeView setShowsRouteButton:YES]; // Set to YES to add the AirPlay functionality (A Vérifier)
    [self.mpVolumeView setShowsVolumeSlider:YES];
    
    // Available since iOS 5
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
    // Select the mute button if the volume is down
    if (0.f == [[MPMusicPlayerController applicationMusicPlayer] volume]) {
        NSLog(@"Mute");
        [self.mute_Btn setSelected:YES];
        [self.mpVolumeView setUserInteractionEnabled:NO];
    }
    else {
        NSLog(@"Sound");
        [self.mute_Btn setSelected:NO];
        [self.mpVolumeView setUserInteractionEnabled:YES];
    }
    
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
    [self shareCurrentMountsOnFacebook:self.currentMountsTitle];
}

//**/
- (void)shareWithTwitter
{
    NSLog(@"Twitter sharing...");
    [self shareCurrentMountsOnTwitter:self.currentMountsTitle];
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
////**/ First connection launch on view did load
//- (void)connectToFacebook
//{
//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        if (!appDelegate.fbSession.isOpen) {
//            // Created a new session if it doesn't still exist
//            appDelegate.fbSession = [[FBSession alloc] init];
//    
//            if (appDelegate.fbSession.state == FBSessionStateCreatedTokenLoaded) {
//                // even though we had a cached token, we need to login to make the session usable
//                [appDelegate.fbSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                    // ...
//                }];
//            }
//        }
//}

////**/ IBAction call by the Facebook button on the central panel
//- (void)openFacebookSessionAndShareMounts:(NSString *)mountsName
//{
//    // OLD (v1.0)
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
//}

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



//**/ Simple Share
- (void)shareCurrentMountsOnFacebook:(NSString *)mountsName
{
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] initWithLink:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_RIDER_RADIO_SHARED_URL, [[NSLocale preferredLanguages] objectAtIndex:0]]]
                                                                   name:self.currentMountsTitle
                                                                caption:URL_RIDER_RADIO_SHARE_LINK_CAPTION
                                                            description:URL_RIDER_RADIO_SHARE_MESSAGE
                                                                picture:[NSURL URLWithString:[[URL_RIDER_RADIO_CURRENT_SONG_JACKET stringByAppendingFormat:@"%@.jpg", self.currentMountsTitle] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    // If the Facebook app is installed on the current device => share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog on Wall
        [FBDialogs presentShareDialogWithParams:params
                                    clientState:nil
                                        handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                            if (error) {
                                                // An error occurred -> See: https://developers.facebook.com/docs/ios/errors
                                                NSLog(@"Error publishing story: %@", error.description);
                                            }
                                            else {
                                                // Success
                                                NSLog(@"result %@", results);
                                            }
                                        }];
        
        // Present the share dialog on Message
//        [FBDialogs presentMessageDialogWithParams:params
//                                      clientState:nil
//                                          handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                              if (error) {
//                                                  // An error occurred -> See: https://developers.facebook.com/docs/ios/errors
//                                                  NSLog(@"Error publishing story: %@", error.description);
//                                              }
//                                              else {
//                                                  // Success
//                                                  NSLog(@"result %@", results);
//                                              }
//                                          }];
    }
    // The Facebook app is not installed on the current device => feed dialog
    else {
        // Present the feed dialog
        // Put together the dialog parameters
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        URL_RIDER_RADIO_SHARED_URL, @"link",
                                        self.currentMountsTitle, @"name",
                                        URL_RIDER_RADIO_SHARE_LINK_CAPTION, @"caption",
                                        URL_RIDER_RADIO_SHARE_MESSAGE, @"description",
                                        [[URL_RIDER_RADIO_CURRENT_SONG_JACKET stringByAppendingFormat:@"%@.jpg", self.currentMountsTitle] stringByReplacingOccurrencesOfString:@" " withString:@"%20"], @"picture",
                                        nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:mutDict
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary *)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


//////////////////////
#pragma mark - Twitter
//====================================================================================================//
//                                            Twitter                                                 //
//====================================================================================================//
//**/
- (void)shareCurrentMountsOnTwitter:(NSString *)mountName
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancelled");
                
            }
            else {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:NULL];
        };
        controller.completionHandler = myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:[NSLocalizedString(@"Heard_on_RR_Twitter", @"") stringByAppendingFormat:@"\n%@", mountName]];
        
        // Adding the URL
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_RIDER_RADIO_FRESHNEWS, [[NSLocale preferredLanguages] objectAtIndex:0]]];
        [controller addURL:url];
        
        // Adding the Image
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:[[URL_RIDER_RADIO_CURRENT_SONG_JACKET stringByAppendingFormat:@"%@.jpg", mountName] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
        [controller addImage:image];
        
        // Display Tweet Compose View Controller Modally
        [self presentViewController:controller animated:YES completion:NULL];
    }
    
    // OLD (v1.0 with Twitter framework)
//    if ([TWTweetComposeViewController canSendTweet]) {
//        // Initialize Tweet Compose View Controller
//        TWTweetComposeViewController *vc = [[TWTweetComposeViewController alloc] init];
//        // Settin The Initial Text
//        [vc setInitialText:[NSLocalizedString(@"Heard_on_RR_Twitter", @"") stringByAppendingFormat:@"\n%@", mountName]];
//        // Adding an Image
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
//                                                 [NSURL URLWithString:[[URL_RIDER_RADIO_CURRENT_SONG_JACKET stringByAppendingFormat:@"%@.jpg", mountName] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
//        [vc addImage:image];
//        // Adding a URL
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_RIDER_RADIO_FRESHNEWS, [[NSLocale preferredLanguages] objectAtIndex:0]]];
//        [vc addURL:url];
//        // Setting a Completing Handler
//        [vc setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
//            [self dismissViewControllerAnimated:YES completion:NULL];
//        }];
//        // Display Tweet Compose View Controller Modally
//        [self presentViewController:vc animated:YES completion:nil];
//    }
    
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

