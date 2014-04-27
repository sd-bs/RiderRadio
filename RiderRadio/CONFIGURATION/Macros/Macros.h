//
//  Macros.h
//  RiderRadio
//
//  Created by Fabien Moussavi on 16/02/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface Macros : NSObject
@end


// TEMP
#define DEBUG_LAYER(view, color) view.layer.borderColor = [UIColor color].CGColor; view.layer.borderWidth = 2;

/////////////////////////////
#pragma mark - iOS Versioning
//====================================================================================================//
//                                             iOS Versioning                                         //
//====================================================================================================//
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


///////////////////////////
#pragma mark - Screen sizes
//====================================================================================================//
//                                              Screen sizes                                          //
//====================================================================================================//
#define iPhone_3_5_inches_screen_height             480.f
#define iPhone_4_inches_screen_height               568.f


/////////////////////
#pragma mark - Colors
//====================================================================================================//
//                                                 Colors                                             //
//====================================================================================================//
#define colorDarkGrey                               [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]
#define colorBurgundy                               [UIColor colorWithRed:166.0/255.0 green:54.0/255.0 blue:46.0/255.0 alpha:1.0]
#define colorAniseGreen                             [UIColor colorWithRed:88.0/255.0 green:157.0/255.0 blue:163.0/255.0 alpha:1.0]
#define colorGold                                   [UIColor colorWithRed:175.0/255.0 green:156.0/255.0 blue:105.0/255.0 alpha:1.0]
#define colorGrey                                   [UIColor colorWithRed:147.0/255.0 green:149.0/255.0 blue:152.0/255.0 alpha:1.0]
#define colorCream                                  [UIColor colorWithRed:241.0/255.0 green:237.0/255.0 blue:223.0/255.0 alpha:1.0]


////////////////////
#pragma mark - Enums
//====================================================================================================//
//                                                 Enums                                              //
//====================================================================================================//
typedef NS_ENUM(NSInteger, SectionName) {
    On_Air,
    Mixes,
    Replays,
    Fresh_news,
    Infos
};


///////////////////////////////////
#pragma mark - PanGestureRecognizer
//====================================================================================================//
//                                          PanGestureRecognizer                                      //
//====================================================================================================//
#define NO_SLIDE                                    0
#define RIGHT_SLIDE                                 1
#define LEFT_SLIDE                                  2
#define LONG_SLIDE_TO_RIGHT                         3
#define LONG_SLIDE_TO_LEFT                          4


/////////////////////////////
#pragma mark - CUCentralPanel
//====================================================================================================//
//                                             CUCentralPanel                                         //
//====================================================================================================//
#define FACEBOOK_SHARE_BTN                          1
#define TWITTER_SHARE_BTN                           2
#define EMAIL_SHARE_BTN                             3


///////////////////
#pragma mark - URLs
//====================================================================================================//
//                                                 URLs                                               //
//====================================================================================================//
// ON AIR
#define URL_RIDER_RADIO_STREAMING_FLUX              @"http://stream.myjungly.fr/RIDER-RADIO2"
#define URL_MOUNTS_FLUX_JSON                        @"http://stream.myjungly.fr/json.xsl"
//#define URL_MOUNTS_THUMBNAIL                        @"http://cdn.myjungly.fr/mobile/" // Temporaire: pour tester images cf. lien du dessous
#define URL_MOUNTS_THUMBNAIL                        @"http://cdn.myjungly.fr/web/"

// MIXES
#define URL_RIDER_RADIO_MIXES                       @"https://soundcloud.com/riderradio"

// REPLAYS
#define URL_RIDER_RADIO_REPLAYS                     @"http://www.rider-radio.com/rider-live-sessions-mobile/"

// FRESHNEWS
#define URL_RIDER_RADIO_FRESHNEWS                   @"http://www.rider-radio.com/?lang="


///////////////////////
#pragma mark - Constant
//====================================================================================================//
//                                               Constant                                             //
//====================================================================================================//
#define PLAYING_MOUNT_TAG                           @"/RIDER-RADIO2"
#define WEB_VIEW_CACHE_DURATION                     60 * 5                              // 5 min





