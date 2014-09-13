//
//  InfosViewController.h
//  RiderRadio
//
//  Created by Fabien Moussavi on 14/09/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "CUViewController.h"


@interface InfosViewController : CUViewController

//**/ IBOutlets
@property (strong, nonatomic) IBOutlet UIScrollView                         *scrollView;
@property (strong, nonatomic) IBOutlet UIButton                             *fluxRadio_Btn;
@property (strong, nonatomic) IBOutlet UIButton                             *liveSession_Btn;

@end

