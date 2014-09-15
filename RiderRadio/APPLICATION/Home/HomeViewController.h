//
//  HomeViewController.h
//  RiderRadio
//
//  Created by Fabien Moussavi on 05/09/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "OnAirViewController.h"
#import "MixesViewController.h"
#import "ReplaysViewController.h"
#import "FreshnewsViewController.h"
#import "InfosViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface HomeViewController : CUViewController <UITableViewDataSource, UITableViewDelegate>

//**/ IBOutlets
@property (strong, nonatomic) IBOutlet UIButton                         *topImage_Btn;
@property (strong, nonatomic) IBOutlet UIImageView                      *topImage_Imv;
@property (strong, nonatomic) IBOutlet UITableView                      *tableView;

//**/ Properties
@property (strong, nonatomic) NSArray                                   *section_Array;
@property (assign, nonatomic) BOOL                                      isErrorMsgFirstLaunch;
@property (strong, nonatomic) NSString                                  *errorFluxMessageURL_Str;
@property (strong, nonatomic) UIImage                                   *errorFluxMessage_Img;

// Player
@property (strong, nonatomic) MPMoviePlayerController                   *player;


//**/ Methods
- (void)pushSection:(int)sectionIndex;

@end

