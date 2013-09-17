/*
Copyright 2011 KICK YOUR APP

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#import "NSCollection+Bind.h"
#import <objc/runtime.h>

@implementation CollectionBindArray
@synthesize array = __array;

- (Class) getTypeClassForIndex:(unsigned int)index
{
    [NSException raise:@"You need to override this message (getTypeClassForIndex:)" format:nil];
    return NULL;
}

- (NSArray *)getBypassPathForIndex:(unsigned int)index
{
    return nil;
}

- (NSString *)description
{
    return self.array.description;
}

@end

static char *salomon_strndup(const char *source, int len)
{
    char *ret = malloc(len + 1);
    strncpy(ret, source, len);
    ret[len] = '\0';
    return ret;
}

static char *property_copyAttribute(char attributeName, objc_property_t property)
{
    const char * attrs = property_getAttributes(property);
    
    while (*attrs) {
        if (*attrs == attributeName) {
            const char *start = ++attrs;
            while (*attrs && *attrs != ',')
                ++attrs;
            return salomon_strndup(start, attrs - start);
        }
        while (*attrs && *attrs != ',')
            ++attrs;
        if (*attrs == ',')
            ++attrs;
    }
    return NULL;
}

static void object_setPropertyInstanceVariable(id obj, objc_property_t property, void *value)
{
    char *variableName = property_copyAttribute('V', property);
    object_setInstanceVariable(obj, variableName, value);
    free(variableName);
}

static void object_setPropertyInstanceFloatVariable(id obj, objc_property_t property, float value)
{
    char *name = property_copyAttribute('V', property);
    Ivar var = class_getInstanceVariable([obj class], name);
    if (var)
    {
        void *varIndex = (void*)((char *)obj + ivar_getOffset(var));
        *((float*)varIndex) = value;
    }
    free(name);
}

static void object_setPropertyInstanceDoubleVariable(id obj, objc_property_t property, double value)
{
    char *name = property_copyAttribute('V', property);
    Ivar var = class_getInstanceVariable([obj class], name);
    if (var)
    {
        void *varIndex = (void*)((char *)obj + ivar_getOffset(var));
        *((double*)varIndex) = value;
    }
    free(name);
}

static NSNumberFormatter *decimalNumberFormatter()
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    return [f autorelease];
}

static void property_setInstanceTypedVariable(id obj, objc_property_t property, id<NSObject> value)
{
    char *typeName = property_copyAttribute('T', property);
    
    if (typeName[0] != '@' && [value isKindOfClass:NSArray.class]) {
        if (((NSArray*)value).count > 0) {
            property_setInstanceTypedVariable(obj, property, [(NSArray*)value objectAtIndex:0]);
        }
        free(typeName);
        return ;
    }
    
    switch (typeName[0]) {
        case 'B':
            // Type is BOOL
            if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj, property, (void*)(((NSNumber*)value).boolValue));
            break ;
        case 'c':
            // Type is char
            if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceVariable(obj, property, (void*)([((NSString*)value) cStringUsingEncoding:NSASCIIStringEncoding][0]));
            else if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj,  property, (void*)(((NSNumber*)value).charValue));
            break ;
        case 'C':
            // Type is unsigned char
            if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceVariable(obj, property, (void*)([((NSString*)value) cStringUsingEncoding:NSASCIIStringEncoding][0]));
            else if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj, property, (void*)(((NSNumber*)value).unsignedCharValue));
            break ;
        case 's':
            // Type is short
            if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj, property, (void*)(((NSNumber*)value).shortValue));
            else if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceVariable(obj, property, (void*)([decimalNumberFormatter() numberFromString:(NSString *)value].shortValue));
            break ;
        case 'S':
            // Type is unsigned short
            if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj, property, (void*)(((NSNumber*)value).unsignedShortValue));
            else if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceVariable(obj, property, (void*)([decimalNumberFormatter() numberFromString:(NSString *)value].unsignedShortValue));
            break ;
        case 'i':
            // Type is int
            if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj, property, (void*)(((NSNumber*)value).intValue));
            else if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceVariable(obj, property, (void*)([decimalNumberFormatter() numberFromString:(NSString *)value].intValue));
            break ;
        case 'I':
            // Type is unsigned int
            if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj, property, (void*)(((NSNumber*)value).unsignedIntValue));
            else if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceVariable(obj, property, (void*)([decimalNumberFormatter() numberFromString:(NSString *)value].unsignedIntValue));
            break ;
        case 'f':
            // Type is float
            if ([value isKindOfClass:NSDecimalNumber.class])
                object_setPropertyInstanceFloatVariable(obj, property, ((NSDecimalNumber*)value).floatValue);
            else if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceFloatVariable(obj, property, ((NSNumber*)value).floatValue);
            else if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceFloatVariable(obj, property, ([decimalNumberFormatter() numberFromString:(NSString *)value].floatValue));
            break ;
        case 'd':
            // Type is double
            if ([value isKindOfClass:NSDecimalNumber.class])
                object_setPropertyInstanceDoubleVariable(obj, property, ((NSDecimalNumber*)value).doubleValue);
            else if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceDoubleVariable(obj, property, ((NSNumber*)value).doubleValue);
            else if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceDoubleVariable(obj, property, ([decimalNumberFormatter() numberFromString:(NSString *)value].doubleValue));
            break ;
        case 'l':
            // Type is long
            if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj, property, (void*)(((NSNumber*)value).longValue));
            else if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceVariable(obj, property, (void*)([decimalNumberFormatter() numberFromString:(NSString *)value].longValue));
            break ;
        case 'L':
            // Type is unsigned long
            if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj,  property, (void*)(((NSNumber*)value).unsignedLongValue));
            else if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceVariable(obj, property, (void*)([decimalNumberFormatter() numberFromString:(NSString *)value].unsignedLongValue));
            break ;
        case 'q':
            // Type is long long
            if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj, property, (void*)(((NSNumber*)value).longLongValue));
            else if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceVariable(obj, property, (void*)([decimalNumberFormatter() numberFromString:(NSString *)value].longLongValue));
            break ;
        case 'Q':
            // Type is unsigned long long
            if ([value isKindOfClass:NSNumber.class])
                object_setPropertyInstanceVariable(obj, property, (void*)(((NSNumber*)value).unsignedLongLongValue));
            else if ([value isKindOfClass:NSString.class])
                object_setPropertyInstanceVariable(obj, property, (void*)([decimalNumberFormatter() numberFromString:(NSString *)value].unsignedLongLongValue));
            break ;
        case '@': {
            // Type is Objective-C class
            char *realTypeName = salomon_strndup(typeName + 2, strlen(typeName) - 3);
            Class typeClass = objc_getClass(realTypeName);
            free(realTypeName);
            
            if ([value isKindOfClass:NSDictionary.class]) {
                if ([typeClass isSubclassOfClass:NSMutableDictionary.class] || typeClass == NSDictionary.class) {
                    NSMutableDictionary *subDict = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)value];
                    object_setPropertyInstanceVariable(obj, property, subDict);
                }
                else {
                    id<NSObject> subObj = [[[typeClass alloc] init] autorelease];
                    if (subObj) {
                        [((NSDictionary*)value) FillObject:subObj];
                        object_setPropertyInstanceVariable(obj, property, [subObj retain]);
                    }
                }
            }
            
            else if ([value isKindOfClass:NSArray.class]) {
                if ([typeClass isSubclassOfClass:CollectionBindArray.class]) {
                    CollectionBindArray *subArray = [[[typeClass alloc] init] autorelease];
                    if (subArray) {
                        [((NSArray*)value) FillArray:subArray];
                        object_setPropertyInstanceVariable(obj, property, [subArray retain]);
                    }
                }
                else if ([typeClass isSubclassOfClass:NSMutableArray.class] || typeClass == NSArray.class) {
                    NSArray *subArray = [[NSMutableArray alloc] initWithArray:(NSArray*)value];
                    object_setPropertyInstanceVariable(obj, property, subArray);
                }
                else if (((NSArray*)value).count > 0) {
                    property_setInstanceTypedVariable(obj, property, [(NSArray*)value objectAtIndex:0]);
                }
            }
            
            else if ([value isKindOfClass:NSNumber.class] && [typeClass isSubclassOfClass:NSDecimalNumber.class]) {
                if ([value isKindOfClass:NSDecimalNumber.class])
                    object_setPropertyInstanceVariable(obj, property, [value retain]);
                else
                    object_setPropertyInstanceVariable(obj, property, [[NSDecimalNumber decimalNumberWithDecimal:((NSNumber*)value).decimalValue] retain]);
            }
            
            else if ([value isKindOfClass:NSString.class] && [typeClass isSubclassOfClass:NSNumber.class]) {
                if ([typeClass isSubclassOfClass:NSDecimalNumber.class])
                    object_setPropertyInstanceVariable(obj, property, [[NSDecimalNumber decimalNumberWithDecimal:[decimalNumberFormatter() numberFromString:(NSString *)value].decimalValue] retain]);
                else
                    object_setPropertyInstanceVariable(obj, property, [[decimalNumberFormatter() numberFromString:(NSString *)value] retain]);
            }
            
            else if ([value.class isSubclassOfClass:typeClass])
                object_setPropertyInstanceVariable(obj, property, [value retain]);
            
            break ;
        }
    }
    free(typeName);
}

@implementation NSDictionary (CollectionBind)

- (void) FillObject:(id<NSObject>)obj FromKey:(NSString*)key InProperty:(NSString*)propertyName
{
    id value = [self objectForKey:key];
    if (!value)
        return ;
    
    char *cPropName = strdup(propertyName.UTF8String);
    int cPropNameLen = strlen(cPropName);
    for (unsigned int i = 0; i < cPropNameLen; ++i)
        if ((cPropName[i] < 'A' || cPropName[i] > 'Z') && (cPropName[i] < 'a' || cPropName[i] > 'z') && (cPropName[i] < '0' || cPropName[i] > '9') && cPropName[i] != '_')
            cPropName[i] = '_';
    
    objc_property_t property = class_getProperty(obj.class, cPropName);
    if (!property) {
        char *newCPropName = malloc(sizeof(*newCPropName) * cPropNameLen + 2);
        newCPropName[0] = '_';
        newCPropName[1] = '\0';
        strcat(newCPropName, cPropName);
        
        property = class_getProperty(obj.class, newCPropName);
        free(newCPropName);
    }
    
    if (property)
        property_setInstanceTypedVariable(obj, property, value);
    else {
        while ([value isKindOfClass:NSArray.class] && ((NSArray*)value).count > 0)
            value = [(NSArray*)value objectAtIndex:0];
        if ([value isKindOfClass:NSDictionary.class])
            for (NSString *subKey in (NSDictionary*)value)
                [(NSDictionary*)value FillObject:obj FromKey:subKey InProperty:[propertyName stringByAppendingFormat:@"_%@", subKey]];
    }
    
    free(cPropName);
}

- (id<NSObject>) FillObject:(id<NSObject>)obj
{
    for (NSString *key in self)
        [self FillObject:obj FromKey:key InProperty:key];
    return obj;
}

@end

@implementation NSArray (CollectionBind)

- (void)FillArray:(CollectionBindArray *)array WithType:(Class)typeClass AndValue:(id<NSObject>)value
{
    if ([value isKindOfClass:NSDictionary.class]) {
        if ([typeClass isSubclassOfClass:NSMutableDictionary.class] || typeClass == NSDictionary.class) {
            NSMutableDictionary *subDict = [[[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)value] autorelease];
            [array.array addObject:subDict];
        }
        else {
            id<NSObject> subObj = [[[typeClass alloc] init] autorelease];
            if (subObj) {
                [((NSDictionary*)value) FillObject:subObj];
                [array.array addObject:subObj];
            }
        }
    }
    
    else if ([value isKindOfClass:NSArray.class]) {
        if ([typeClass isSubclassOfClass:CollectionBindArray.class]) {
            CollectionBindArray *subArray = [[[typeClass alloc] init] autorelease];
            if (subArray) {
                [((NSArray*)value) FillArray:subArray];
                [array.array addObject:subArray];
            }
        }
        else if ([typeClass isSubclassOfClass:NSMutableArray.class] || typeClass == NSArray.class) {
            NSArray *subArray = [[[NSMutableArray alloc] initWithArray:(NSArray*)value] autorelease];
            if (subArray)
                [array.array addObject:subArray];
        }
        else if (((NSArray*)value).count > 0) {
            id<NSObject> first = [(NSArray*)value objectAtIndex:0];
            [self FillArray:array WithType:typeClass AndValue:first];
        }
    }
    
    else if ([value isKindOfClass:NSNumber.class] && [typeClass isSubclassOfClass:NSDecimalNumber.class]) {
        if ([value isKindOfClass:NSDecimalNumber.class])
            [array.array addObject:value];
        else
            [array.array addObject:[[NSDecimalNumber decimalNumberWithDecimal:((NSNumber*)value).decimalValue] autorelease]];
    }
    
    else if ([value.class isSubclassOfClass:typeClass])
        [array.array addObject:value];
}

- (NSArray*)FillArray:(CollectionBindArray*)array
{
    array.array = [[[NSMutableArray alloc] init] autorelease];

    for (unsigned int i = 0; i < self.count; ++i) {
        id<NSObject> value = [self objectAtIndex:i];

        NSMutableArray *path = [NSMutableArray arrayWithArray:[array getBypassPathForIndex:i]];
        if (path)
            while (path.count > 0) {
                NSString *key = [path objectAtIndex:0];

                if ([value isKindOfClass:NSArray.class]) {
                    if ([key characterAtIndex:0] == '[' && [key characterAtIndex:(key.length - 1)] == ']') {
                        key = [[key substringToIndex:(key.length - 1)] substringFromIndex:1];
                        int intKey = [key intValue];
                        if (intKey < ((NSArray*)value).count)
                            value = [(NSArray*)value objectAtIndex:intKey];
                        else {
                            NSLog(@"!!! Bypass path node array index is out of bounds : %d", intKey);
                            value = nil;
                            break ;
                        }
                    }
                    else {
                        NSLog(@"!!! Bypass path node should be an array index: [index]");
                        value = nil;
                        break ;
                    }
                }
                else if ([value isKindOfClass:NSDictionary.class]) {
                    value = [(NSDictionary*)value objectForKey:key];
                    if (!value) {
                        NSLog(@"!!! Dictionary does not contains key given by the bypass path: %@", key);
                        value = nil;
                        break ;
                    }
                }
                else {
                    NSLog(@"!!! Value should be an array or a dictionnary as bypass path is not empty or nil and gives: %@", key);
                    value = nil;
                    break ;
                }

                [path removeObjectAtIndex:0];
            }
        
        if (value) {
            Class typeClass = [array getTypeClassForIndex:i];
            [self FillArray:array WithType:typeClass AndValue:value];
        }
    }
    
    return array.array;
}

@end
