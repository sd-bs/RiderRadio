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

#import <Foundation/Foundation.h>

/// @author Salomon BRYS <salomon@kickyourapp.com>0
/// Class used to bind NSArray into binded object array
@interface CollectionBindArray : NSObject {
    NSMutableArray *__array;
}

/// The array to use once it has been binded
@property (nonatomic, retain) NSMutableArray *array;

/// This callback is used by the binder to get the type class of the object to create for a specific index
- (Class) getTypeClassForIndex:(unsigned int)index;

/// This callback is used by the binder to bypass container objects, cf doc
- (NSArray*) getBypassPathForIndex:(unsigned int)index;

@end


@interface NSDictionary (CollectionBind)
/// This is where the magic happens : Just call this method giving it the object to fill
- (id<NSObject>) FillObject:(id<NSObject>)obj;
@end

@interface NSArray (CollectionBind)
/// This is where the magic happens : Just call this method giving it the array to fill
- (NSArray*) FillArray:(CollectionBindArray*)array;
@end
