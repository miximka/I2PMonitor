//
//  RCControlButton.m
//  I2PRemoteControl
//
//  Created by miximka on 27/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCControlButton.h"
#import "RCControlButtonCell.h"

//=========================================================================
@implementation RCControlButton
//=========================================================================

- (void)customSetTitle:(NSString *)title color:(NSColor *)color
{
    NSAssert([self.cell isKindOfClass:[RCControlButtonCell class]], @"Invalid cell class");
    [self.cell customSetTitle:title color:color];
}

//=========================================================================

- (void)awakeFromNib
{
    //Do not highlight button image when it is pressed
    [self.cell setHighlightsBy:NSNoCellMask];
}

//=========================================================================
@end
//=========================================================================
