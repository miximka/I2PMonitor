//
//  RCTabButton.m
//  I2PRemoteControl
//
//  Created by miximka on 21/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCTabButton.h"
#import "RCTabButtonCell.h"

//=========================================================================
@implementation RCTabButton
//=========================================================================

- (RCContentViewColorType)colorType
{
    return [(RCTabButtonCell *)self.cell colorType];
}

//=========================================================================

- (void)setColorType:(RCContentViewColorType)colorType
{
    [(RCTabButtonCell *)self.cell setColorType:colorType];
}

//=========================================================================
@end
//=========================================================================
