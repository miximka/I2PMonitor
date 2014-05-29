//
//  NSMutableDictionary+Extensions.h
//  I2PRemoteControl
//
//  Created by miximka on 28/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================
@interface NSMutableDictionary (Extensions)
//=========================================================================

- (void)setObjectIfNotNil:(id)anObject forKey:(id<NSCopying>)aKey;

//=========================================================================
@end
//=========================================================================
