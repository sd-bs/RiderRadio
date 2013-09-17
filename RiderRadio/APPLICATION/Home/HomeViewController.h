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
@property (nonatomic, strong) IBOutlet UIButton                         *topImage_Btn;
@property (nonatomic, strong) IBOutlet UITableView                      *tableView;

//**/ Properties
@property (nonatomic, strong) NSArray                                   *section_Array;

// Player
@property (nonatomic, strong) MPMoviePlayerController                   *player;

@end

