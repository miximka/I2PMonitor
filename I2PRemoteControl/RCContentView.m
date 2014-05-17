//
//  RCContentView.m
//  I2PRemoteControl
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
        self.type = [NSNumber numberWithInt:RCContentViewNoColor];
    }
    return self;
}

//=========================================================================

- (void)drawRect:(NSRect)dirtyRect
{
    RCContentViewColorType type = [self.type intValue];
    NSRect bounds = self.bounds;
    CGFloat lineWidth = 1.0;
    
    if (type != RCContentViewNoColor)
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
    
    if (type == RCContentViewColorGreen)
    {
        startColor = [NSColor colorWithCalibratedRed:43.0/255.0 green:254.0/255.0 blue:166.0/255.0 alpha:1.0];
        endColor = [NSColor colorWithCalibratedRed:188.0/255.0 green:254.0/255.0 blue:83.0/255.0 alpha:1.0];
    }
    else if (type == RCContentViewColorRed)
    {
        startColor = [NSColor colorWithCalibratedRed:252.0/255.0 green:15.0/255.0 blue:26.0/255.0 alpha:1.0];
        endColor = [NSColor colorWithCalibratedRed:255.0/255.0 green:205.0/255.0 blue:56.0/255.0 alpha:1.0];
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
