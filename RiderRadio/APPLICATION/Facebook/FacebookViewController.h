//
//  FacebookViewController.h
//  RiderRadio
//
//  Created by Fabien Moussavi on 11/06/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CUCentralPanelDelegate.h"


@interface FacebookViewController : UIViewController

// Delegate
@property (nonatomic, strong) id<CUCentralPanelDelegate>        delegate;
@property (nonatomic, strong) IBOutlet UIButton                 *buttonLoginLogout;

// Methods
- (id)initWithDelegate:(id<CUCentralPanelDelegate>)delegate;

@end
