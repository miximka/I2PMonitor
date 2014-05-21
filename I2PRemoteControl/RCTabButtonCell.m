//
//  RCTabButtonCell.m
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCTabButtonCell.h"
#import "RCContentView.h"

#define TITLE_OFFSET_FROM_BOTTOM    5
#define IMAGE_OFFSET_FROM_CENTER    15
#define COLORED_LINE_BOTTOM_MARGIN  2
#define COLORED_LINE_WIDTH          2

//=========================================================================
@implementation RCTabButtonCell
//=========================================================================

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    RCContentViewColorType colorType = self.colorType;
    CGFloat lineWidth = COLORED_LINE_WIDTH;
    
    if (colorType != RCContentViewNoColor)
    {
        //Draw white line on the top of the view
        NSRect lineRect = NSMakeRect(0, frame.size.height-lineWidth, frame.size.width, lineWidth);
        NSColor *color = [NSColor colorWithCalibratedWhite:0.5 alpha:0.1];
        [color setFill];
        NSRectFill(lineRect);
    }
    
    //Draw colored line
    NSRect coloredLineRect = NSMakeRect(frame.size.width * 1/10, frame.size.height-lineWidth - COLORED_LINE_BOTTOM_MARGIN, frame.size.width - 2*(frame.size.width * 1/10), lineWidth);
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
        if (!self.isEnabled)
        {
            startColor = [NSColor colorWithCalibratedRed:startColor.redComponent green:startColor.greenComponent blue:startColor.blueComponent alpha:0.5];
            endColor = [NSColor colorWithCalibratedRed:endColor.redComponent green:endColor.greenComponent blue:endColor.blueComponent alpha:0.5];
        }
        
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
        [gradient drawInRect:coloredLineRect angle:0.0];
    }
}

//=========================================================================

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSPoint center = NSMakePoint(cellFrame.origin.x + cellFrame.size.width/2, cellFrame.origin.x + cellFrame.size.height/2);

    //===================
    //Draw image in the middle of the button
    NSSize imageSize = self.image.size;
    NSPoint imagePoint = NSMakePoint(center.x - imageSize.width/2, center.y - imageSize.height/2);
    NSRect imageFrame = NSMakeRect(imagePoint.x, imagePoint.y, imageSize.width, imageSize.height);
    [self drawImage:self.image withFrame:imageFrame inView:controlView];

    //===================
    //Draw title
    NSColor *textColor = [NSColor whiteColor];
    if ([self isEnabled] == NO)
    {
        //Use disabled text color
        textColor = [NSColor lightGrayColor];
    }
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : textColor,
                                  NSFontAttributeName : [NSFont fontWithName:@"Helvetica Neue Bold" size:12] };
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.title attributes:attributes];
    [self setAttributedTitle:attributedString];
    NSRect titleBoundingRect = [attributedString boundingRectWithSize:cellFrame.size options:0];
    NSRect titleFrame = NSMakeRect(center.x - titleBoundingRect.size.width/2, cellFrame.size.height - titleBoundingRect.size.height - TITLE_OFFSET_FROM_BOTTOM, titleBoundingRect.size.width, titleBoundingRect.size.height);
    
    [self drawTitle:self.attributedTitle withFrame:titleFrame inView:controlView];
}

//=========================================================================
@end
//=========================================================================
