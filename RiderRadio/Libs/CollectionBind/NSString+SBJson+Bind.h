//
//  SBJson+CollectionBind.h
//  CollectionBindDemo
//
//  Created by Salomon BRYS on 24/11/11.
//  Copyright (c) 2011 Kick Your App. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "NSObject+SBJson.h"
#import "NSCollection+Bind.h"

@interface NSString (CollectionBind)

- (id) JSONObjectValueOfClass:(Class)objectClass;

- (NSArray*) JSONArrayValueOfClass:(Class)arrayClass;

@end
