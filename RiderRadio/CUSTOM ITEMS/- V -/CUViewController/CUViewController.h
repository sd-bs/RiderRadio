//
//  CUViewController.h
//  RiderRadio
//
//  Created by Fabien Moussavi on 14/09/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Macros.h"
#import "ViewTranslater.h"
#import <MessageUI/MessageUI.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AFNetworking.h"


@interface CUViewController : UIViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate>

//**/ IBOutlets
// Backing items
//@property (nonatomic, strong) IBOutlet UIView                       *backing_View;
@property (strong, nonatomic) IBOutlet UIButton                     *back_Btn;
@property (strong, nonatomic) IBOutlet UIWebView                    *webView;
@property (strong, nonatomic) IBOutlet UIView                       *aivBackground;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView      *aiv;
// Player components
@property (strong, nonatomic) IBOutlet UIView                       *playerComponents_View;
// On Air
@property (strong, nonatomic) IBOutlet UIView                       *onAir_View;
// Song Thumbnail
@property (strong, nonatomic) IBOutlet UIImageView                  *currentSound_Img;
// Timeline
@property (strong, nonatomic) IBOutlet UIView                       *timeline_View;
@property (strong, nonatomic) IBOutlet UIImageView                  *timelineBackground_Img;
@property (strong, nonatomic) IBOutlet UILabel                      *timeline_Lbl;
@property (assign, nonatomic) BOOL                                  timelineScrollingEnabled;
// MPVolume
@property (strong, nonatomic) IBOutlet UIView                       *volume_View;
@property (strong, nonatomic) IBOutlet MPVolumeView                 *mpVolumeView;
@property (strong, nonatomic) IBOutlet UIButton                     *mute_Btn;
@property (assign, nonatomic) float                                 oldVolume;


//**/ Properties
// Mounts
@property (strong, nonatomic) NSString                              *currentMountsTitle;
@property (strong, nonatomic) NSString                              *previousMountsTitle;

// Player
@property (strong, nonatomic) MPMoviePlayerController               *player;

// Various
@property (assign, nonatomic) BOOL                                  isFirstAlert;


//**/ IBActions
- (IBAction)popViewController:(UIButton *)button;
- (IBAction)share:(UIButton *)button;
- (IBAction)mute:(UIButton *)button;


//**/ Methods
- (void)goBack;
// Only for OnAirViewController
- (void)getCurrentMountInfos;
- (void)fillCurrentMountInformations;
- (void)restartPlayingFromBackgrounded;
// Only for Mixes, Replays and Freshnews ViewControllers
- (void)loadWebView;
// Facebook
- (void)openFacebookSessionAndShareMounts:(NSString *)mountsName;
// Twitter
- (void)openTwitterSessionAndShareMounts:(NSString *)mountName;


@end

