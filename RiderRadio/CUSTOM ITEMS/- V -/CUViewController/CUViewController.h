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
#import "MountsArrayModel.h"


@interface CUViewController : UIViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate>

//**/ IBOutlets
// Backing items
@property (nonatomic, strong) IBOutlet UIView                       *backing_View;
@property (nonatomic, strong) IBOutlet UIButton                     *back_Btn;
@property (nonatomic, strong) IBOutlet UIWebView                    *webView;
@property (nonatomic, strong) IBOutlet UIView                       *aivBackground;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView      *aiv;
// Player components
@property (nonatomic, strong) IBOutlet UIView                       *playerComponents_View;
// On Air
@property (nonatomic, strong) IBOutlet UIView                       *onAir_View;
// Song Thumbnail
@property (nonatomic, strong) IBOutlet UIImageView                  *currentSound_Img;
// Timeline
@property (nonatomic, strong) IBOutlet UIView                       *timeline_View;
@property (nonatomic, strong) IBOutlet UIImageView                  *timelineBackground_Img;
@property (nonatomic, strong) IBOutlet UILabel                      *timeline_Lbl;
@property (nonatomic, assign) BOOL                                  timelineScrollingEnabled;
// MPVolume
@property (nonatomic, strong) IBOutlet UIView                       *volume_View;
@property (nonatomic, strong) IBOutlet MPVolumeView                 *mpVolumeView;
@property (nonatomic, strong) IBOutlet UIButton                     *mute_Btn;
@property (nonatomic, assign) float                                 oldVolume;

//**/ Properties
// PanGestureRecognizer
@property (nonatomic, strong) UIPanGestureRecognizer                *recognizer;

// Mounts
@property (nonatomic, strong) MountsArrayModel                      *mountsArrayModel;
@property (nonatomic, strong) NSMutableArray                        *mounts_MutableArray;
@property (nonatomic, strong) Mounts                                *currentMount;
@property (nonatomic, strong) NSString                              *previousMountsTitle;

// Player
@property (nonatomic, strong) MPMoviePlayerController               *player;

// Various
@property (nonatomic, assign) BOOL                                  isFirstAlert;


//**/ IBActions
- (IBAction)popViewController:(UIButton *)button;
- (IBAction)share:(UIButton *)button;
- (IBAction)mute:(UIButton *)button;


//**/ Methods
- (void)goBack;
// Only for OnAirViewController
- (void)getCurrentMountsList;
- (void)fillCurrentMountInformations;
- (void)restartPlayingFromBackgrounded;
// Only for Mixes, Replays and Freshnews ViewControllers
- (void)loadWebView;
// Facebook
- (void)openFacebookSessionAndShareMounts:(NSString *)mountsName;
// Twitter
- (void)openTwitterSessionAndShareMounts:(NSString *)mountName;


@end

