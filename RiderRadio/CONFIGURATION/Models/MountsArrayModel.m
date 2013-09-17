//
//  MountsArrayModel.m
//  RiderRadio
//
//  Created by Fabien Moussavi on 06/05/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "MountsArrayModel.h"


//**/ Mounts
@implementation Mounts
@synthesize mount                       = _mount;
@synthesize server_name                 = _server_name;
@synthesize title                       = _title;
@end

//**/ MountsArray
@implementation MountsArray
- (Class)getTypeClassForIndex:(unsigned int)index
{
    return Mounts.class;
}
@end

//**/ MountsArrayModel
@implementation MountsArrayModel
@synthesize mounts                      = _mounts;
@end

