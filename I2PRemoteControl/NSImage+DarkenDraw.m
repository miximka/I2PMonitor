//
//  NSImage+DarkenDraw.m
//  I2PRemoteControl
//
//  Created by miximka on 21/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "NSImage+DarkenDraw.h"

//=========================================================================
@implementation NSImage (DarkenDraw)
//=========================================================================

- (void)drawInRect:(NSRect)rect fromRect:(NSRect)fromRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta darken:(BOOL)darken
{
    if (darken)
    {
        [self lockFocus];
        [[NSColor colorWithCalibratedWhite:0.0 alpha:0.33] set];
        NSRectFillUsingOperation(rect, NSCompositeSourceAtop);
        [self unlockFocus];

        delta = fmin(0.75, delta);
    }
    
    [self drawInRect:rect fromRect:fromRect operation:op fraction:delta];
}

//=========================================================================
@end
//=========================================================================
