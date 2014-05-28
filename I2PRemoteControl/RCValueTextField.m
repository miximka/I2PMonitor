//
//  RCValueTextField.m
//  I2PRemoteControl
//
//  Created by miximka on 28/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCValueTextField.h"

static NSString *const defaultNilPlaceholder = @"-";

//=========================================================================
@implementation RCValueTextField
//=========================================================================

- (NSString *)nilPlaceholder
{
    if (_nilPlaceholder == nil)
    {
        return defaultNilPlaceholder;
    }
    
    return _nilPlaceholder;
}

//=========================================================================

- (void)setStringValue:(NSString *)aString
{
    if (aString == nil)
    {
        aString = [self nilPlaceholder];
    }
    
    [super setStringValue:aString];
}

//=========================================================================
@end
//=========================================================================
