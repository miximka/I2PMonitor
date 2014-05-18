//
//  RCButtonCell.m
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCContextSwitchButtonCell.h"

#define TITLE_OFFSET_FROM_BOTTOM    5
#define IMAGE_OFFSET_FROM_CENTER    15

//=========================================================================
@implementation RCContextSwitchButtonCell
//=========================================================================

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    //Draw nothing, we don't have border
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
