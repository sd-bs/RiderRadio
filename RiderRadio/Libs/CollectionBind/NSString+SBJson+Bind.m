//
//  SBJson+CollectionBind.m
//  CollectionBindDemo
//
//  Created by Salomon BRYS on 24/11/11.
//  Copyright (c) 2011 Kick Your App. All rights reserved.
//

#import "NSString+SBJson+Bind.h"
#import <objc/runtime.h>

@implementation NSString (CollectionBind)

- (id) JSONObjectValueOfClass:(Class)objectClass
{
    id json = [self JSONValue];
    if (![json isKindOfClass:NSDictionary.class])
        return nil;
    
    id object = [[objectClass alloc] init];
    if (object)
        [(NSDictionary*)json FillObject:object];

    return [object autorelease];
}

- (NSArray*) JSONArrayValueOfClass:(Class)arrayClass
{
    if (![arrayClass isSubclassOfClass:CollectionBindArray.class])
        [NSException raise:@"arrayValueOfClass class should be a CollectionBindArray subclass" format:nil];
    
    id json = [self JSONValue];
    if (![json isKindOfClass:NSArray.class])
        return nil;

    CollectionBindArray *array = [[[arrayClass alloc] init] autorelease];
    if (array)
        [(NSArray*)json FillArray:array];
    
    return [[array.array retain] autorelease];
}

@end
