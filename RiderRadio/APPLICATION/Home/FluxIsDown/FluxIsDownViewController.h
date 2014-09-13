//
//  FluxIsDownViewController.h
//  RiderRadio
//
//  Created by Fabien Moussavi on 12/09/2014.
//  Copyright (c) 2014 Fabien Moussavi. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface FluxIsDownViewController : UIViewController

//**/ IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView                      *errorMsg_Imv;
@property (strong, nonatomic) IBOutlet UIButton                         *close_Btn;

//**/ Properties
@property (strong, nonatomic) UIImage                                   *errorMsg_Img;

//**/ Methods
- (id)initWithImage:(UIImage *)errorMsgImg;

@end

