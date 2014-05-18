//
//  RCTextField.m
//  I2PRemoteControl
//
//  Created by miximka on 17/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCTextField.h"

//=========================================================================
@implementation RCTextField
//=========================================================================

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code here.
    }
    return self;
}

//=========================================================================

- (BOOL)isOpaque
{
    return NO;
}

//=========================================================================

- (void)awakeFromNib
{
    self.backgroundColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.8];
    self.drawsBackground = YES;
    self.layer.cornerRadius = 3.0;
}

//=========================================================================

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    // Drawing code here.
}

//=========================================================================
@end
//=========================================================================
