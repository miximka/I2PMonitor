//
//  RCButtonView.m
//  I2PRemoteControl
//
//  Created by miximka on 17/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCButtonView.h"

//=========================================================================
@implementation RCButtonView
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

- (void)awakeFromNib
{
    RCContentViewColorType type = [self.type intValue];
    if (type == RCContentViewColorGreen)
    {
    }
    else if (type == RCContentViewColorRed)
    {
        self.imageView.alphaValue = 0.4;
    }
    else if (type == RCContentViewColorViolet)
    {
        self.imageView.alphaValue = 0.4;
    }
}

//=========================================================================

- (void)drawRect:(NSRect)dirtyRect
{
    RCContentViewColorType type = [self.type intValue];
    NSRect bounds = self.bounds;
    CGFloat lineWidth = 2.0;
    
    //Draw colored line
    NSRect coloredLineRect = NSMakeRect(5, 5, bounds.size.width - 5*2, lineWidth);
    NSColor *startColor = nil;
    NSColor *endColor = nil;
    
    if (type == RCContentViewColorGreen)
    {
        startColor = GREEN_GRADIENT_START_COLOR;
        endColor = GREEN_GRADIENT_END_COLOR;
    }
    else if (type == RCContentViewColorRed)
    {
        startColor = [NSColor colorWithCalibratedRed:252.0/255.0 green:15.0/255.0 blue:26.0/255.0 alpha:0.4];
        endColor = [NSColor colorWithCalibratedRed:255.0/255.0 green:205.0/255.0 blue:56.0/255.0 alpha:0.4];
    }
    else if (type == RCContentViewColorViolet)
    {
        startColor = [NSColor colorWithCalibratedRed:248.0/255.0 green:67.0/255.0 blue:245.0/255.0 alpha:0.4];
        endColor = [NSColor colorWithCalibratedRed:252.0/255.0 green:88.0/255.0 blue:81.0/255.0 alpha:0.4];
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
