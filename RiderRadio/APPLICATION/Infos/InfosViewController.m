//
//  InfosViewController.m
//  RiderRadio
//
//  Created by Fabien Moussavi on 14/09/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "InfosViewController.h"
#import "Parallax.h"


@interface InfosViewController ()
@end

@implementation InfosViewController
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
    
    // ScrollView content Size
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 620.f)];
    
    // Parallax effect on buttons
    [Parallax registerEffectForView:self.fluxRadio_Btn withDepth:20];
    [Parallax registerEffectForView:self.liveSession_Btn withDepth:20];
}


///////////////////////
#pragma mark - IBAction
//====================================================================================================//
//                                            IBAction                                                //
//====================================================================================================//
//**/
- (IBAction)visitPartnersite:(UIButton *)button
{
    switch (button.tag) {
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://myjungly.com"]];
            break;
            
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.glowbl.com/"]];
            break;
    }
}


/////////////////////
#pragma mark - Memory
//====================================================================================================//
//                                             MEMORY                                                 //
//====================================================================================================//
//**/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

