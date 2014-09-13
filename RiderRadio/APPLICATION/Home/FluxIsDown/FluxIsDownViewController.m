//
//  FluxIsDownViewController.m
//  RiderRadio
//
//  Created by Fabien on 12/09/2014.
//  Copyright (c) 2014 Fabien Moussavi. All rights reserved.
//


#import "FluxIsDownViewController.h"


@interface FluxIsDownViewController ()
@end

@implementation FluxIsDownViewController
///////////////////
#pragma mark - Init
//====================================================================================================//
//                                              INIT                                                  //
//====================================================================================================//
//**/
- (id)initWithImage:(UIImage *)errorMsgImg
{
    self = [super init];
    if (self) {
        self.errorMsg_Img = errorMsgImg;
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
    
    // Load the error message as an image passed as argument
    [self.errorMsg_Imv setImage:self.errorMsg_Img];
}


///////////////////////
#pragma mark - IBAction
//====================================================================================================//
//                                            IBAction                                                //
//====================================================================================================//
//**/
- (IBAction)closeAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

