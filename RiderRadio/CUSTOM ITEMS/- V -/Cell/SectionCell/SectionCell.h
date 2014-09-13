//
//  SectionCell.h
//  RiderRadio
//
//  Created by Fabien Moussavi on 05/09/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface SectionCell : UITableViewCell

//**/ IBOutlets
@property (strong, nonatomic) IBOutlet UIView                           *background_View;
@property (strong, nonatomic) IBOutlet UIImageView                      *sectionIcon_Imv;
@property (strong, nonatomic) IBOutlet UILabel                          *sectionName_Lbl;
@property (strong, nonatomic) IBOutlet UIImageView                      *rightArrow_Imv;

@end

