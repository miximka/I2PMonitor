//
//  RCMenuItem.m
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCMenuItem.h"
#import "RCViewController.h"

//=========================================================================
@implementation RCMenuItem
//=========================================================================

- (id)representedObject
{
    return [self.controller representedObject];
}

//=========================================================================

- (void)setRepresentedObject:(id)anObject
{
    [self.controller setRepresentedObject:anObject];
}

//=========================================================================
@end
//=========================================================================
