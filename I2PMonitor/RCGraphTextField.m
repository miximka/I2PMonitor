//
//  RCTextField.m
//  I2PMonitor
//
//  Created by miximka on 17/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCGraphTextField.h"

//=========================================================================
@implementation RCGraphTextField
//=========================================================================

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code here.
        [self setWantsLayer:YES];
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
    [self setWantsLayer:YES];
    
    self.backgroundColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.4];
    self.drawsBackground = YES;
    self.layer.cornerRadius = 5.0;
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
