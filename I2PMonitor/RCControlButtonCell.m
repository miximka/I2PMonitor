//
//  RCControlButtonCell.m
//  I2PMonitor
//
//  Created by miximka on 26/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCControlButtonCell.h"

#define CUSTOM_TITLE_BOTTOM_PADDING 2

//=========================================================================
@implementation RCControlButtonCell
//=========================================================================

- (void)customSetTitle:(NSString *)title color:(NSColor *)color
{
    //Title font
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];

    //Title color
    [attributes setObject:color forKey:NSForegroundColorAttributeName];

    //title alignment
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:title attributes:attributes];
    [attributedStr setAlignment:self.alignment range:NSMakeRange(0, title.length)];
    
    [self setAttributedTitle:attributedStr];
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSColor *color = [NSColor colorWithCalibratedWhite:1.0 alpha:0.8];

    if (self.isHighlighted || !self.isEnabled)
    {
        color = [NSColor colorWithCalibratedWhite:1.0 alpha:0.5];
    }
    
    [color setStroke];
    
    CGFloat lineWidth = 1.0;
    NSRect strokeRect = NSInsetRect(frame, lineWidth/2, lineWidth/2);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:strokeRect];
    [path setLineWidth:lineWidth];
    [path stroke];
}

//=========================================================================

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSRect updatedFrame = frame;
    updatedFrame.origin.y -= CUSTOM_TITLE_BOTTOM_PADDING;
    
    return [super drawTitle:title withFrame:updatedFrame inView:controlView];
}

//=========================================================================
@end
//=========================================================================
