//
//  RCContentView.m
//  I2PMonitor
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCContentView.h"

//=========================================================================
@implementation RCContentView
//=========================================================================

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.colorType = RCContentViewNoColor;
    }
    return self;
}

//=========================================================================

- (void)drawRect:(NSRect)dirtyRect
{
    RCContentViewColorType colorType = self.colorType;
    NSRect bounds = self.bounds;
    CGFloat lineWidth = 1.0;
    
    if (colorType != RCContentViewNoColor)
    {
        //Draw white line on the top of the view
        NSRect lineRect = NSMakeRect(0, bounds.size.height-lineWidth, bounds.size.width, lineWidth);
        NSColor *color = [NSColor colorWithCalibratedWhite:0.5 alpha:0.1];
        [color setFill];
        NSRectFill(lineRect);
    }
    
    //Draw colored line
    NSRect coloredLineRect = NSMakeRect(0, bounds.size.height-lineWidth, bounds.size.width * 1/3, lineWidth);
    NSColor *startColor = nil;
    NSColor *endColor = nil;
    
    switch (colorType)
    {
        case RCContentViewColorGreen:
            startColor = GREEN_GRADIENT_START_COLOR;
            endColor = GREEN_GRADIENT_END_COLOR;
            break;

        case RCContentViewColorRed:
            startColor = RED_GRADIENT_START_COLOR;
            endColor = RED_GRADIENT_END_COLOR;
            break;

        case RCContentViewColorViolet:
            startColor = VIOLETT_GRADIENT_START_COLOR;
            endColor = VIOLETT_GRADIENT_END_COLOR;
            break;

        default:
            break;
    }
    
    if (startColor != nil && endColor != nil)
    {
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
        [gradient drawInRect:coloredLineRect angle:0.0];
    }
}

//=========================================================================
@end
//=========================================================================
