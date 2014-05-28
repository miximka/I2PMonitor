//
//  NSMutableDictionary+Extensions.m
//  I2PRemoteControl
//
//  Created by miximka on 28/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "NSMutableDictionary+Extensions.h"

//=========================================================================
@implementation NSMutableDictionary (Extensions)
//=========================================================================

- (void)setObjectIfNotNil:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject)
    {
        [self setObject:anObject forKey:aKey];
    }
}

//=========================================================================
@end
//=========================================================================
