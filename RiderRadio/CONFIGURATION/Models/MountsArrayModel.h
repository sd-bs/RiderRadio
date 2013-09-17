//
//  MountsArrayModel.h
//  RiderRadio
//
//  Created by Fabien Moussavi on 06/05/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSCollection+Bind.h"


//**/ Mounts
@interface Mounts : NSObject
@property (nonatomic, strong) NSString                      *mount;
@property (nonatomic, strong) NSString                      *server_name;
@property (nonatomic, strong) NSString                      *title;
@end

//**/ MountsArray
@interface MountsArray : CollectionBindArray
@end


//**/ MountsArrayModel
@interface MountsArrayModel : NSObject
@property (nonatomic, strong) MountsArray                   *mounts;
@end

