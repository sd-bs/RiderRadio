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
@property (nonatomic, strong) IBOutlet UIView                           *background_View;
@property (nonatomic, strong) IBOutlet UIImageView                      *sectionIcon_Imv;
@property (nonatomic, strong) IBOutlet UILabel                          *sectionName_Lbl;

@end

