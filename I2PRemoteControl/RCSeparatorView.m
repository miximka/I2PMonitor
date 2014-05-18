//
//  RCSeparatorView.m
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCSeparatorView.h"

//=========================================================================
@implementation RCSeparatorView
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

//- (BOOL)isOpaque
//{
//    return NO;
//}

//=========================================================================

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    
    [[NSColor colorWithCalibratedWhite:0.5 alpha:0.3] setFill];
    NSRectFill(dirtyRect);
}

//=========================================================================
@end
//=========================================================================
