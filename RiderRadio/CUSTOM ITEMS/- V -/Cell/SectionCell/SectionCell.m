//
//  SectionCell.m
//  RiderRadio
//
//  Created by Fabien Moussavi on 05/09/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "SectionCell.h"


@implementation SectionCell
///////////////////
#pragma mark - Init
//====================================================================================================//
//                                              INIT                                                  //
//====================================================================================================//
//**/
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SectionCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        
    }
    return self;
}


/////////////////////
#pragma mark - Mehtod
//====================================================================================================//
//                                             Mehtod                                                 //
//====================================================================================================//
//**/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

