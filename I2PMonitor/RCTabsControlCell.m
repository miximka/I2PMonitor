//
//  RCTabsControlCell.m
//  I2PMonitor
//
//  Created by miximka on 21/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCTabsControlCell.h"
#import "RCTabsControlCell.h"
#import "RCContentView.h"

//=========================================================================

#define COLORED_LINE_BOTTOM_MARGIN  2
#define COLORED_LINE_WIDTH          2
#define TITLE_OFFSET_FROM_BOTTOM    8

@interface RCTabsControlCell ()
@property (nonatomic) NSInteger highlightedSegmentIndex;
@property (nonatomic) NSMutableDictionary *images;
@property (nonatomic) NSMutableDictionary *labels;
@end

//=========================================================================
@implementation RCTabsControlCell
{
    NSInteger _selectedSegment;
}

//=========================================================================

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _selectedSegment = -1;
        _images = [NSMutableDictionary new];
        _labels = [NSMutableDictionary new];
        self.highlightedSegmentIndex = -1;
    }
    return self;
}

//=========================================================================

- (void)setSelectedSegment:(NSInteger)selectedSegment
{
    _selectedSegment = selectedSegment;
}

//=========================================================================

- (NSInteger)selectedSegment
{
    return _selectedSegment;
}

//=========================================================================

- (NSRect)rectForSegment:(NSUInteger)segmentIndex inFrame:(NSRect)cellFrame
{
    NSUInteger segmentCount = self.segmentCount;
    
    //Calculate widths of the cells
    NSUInteger width = cellFrame.size.width / segmentCount;
    CGFloat x = width * segmentIndex;
    
    if (segmentIndex == segmentCount - 1)
    {
        //Last cell can be a bit longer to fill entire frame
        width = cellFrame.size.width - x;
    }
    
    NSRect cellRect = NSMakeRect(cellFrame.origin.x + x, cellFrame.origin.y, width, cellFrame.size.height);
    return cellRect;
}

//=========================================================================

- (void)drawSegmentBackground:(NSUInteger)segmentIndex withSegmentFrame:(NSRect)segmentFrame inView:(NSView *)controlView
{
    CGFloat lineWidth = COLORED_LINE_WIDTH;
    
    //Draw colored line
    NSRect coloredLineRect = NSMakeRect(segmentFrame.origin.x + segmentFrame.size.width * 1/10,
                                        segmentFrame.origin.y + COLORED_LINE_BOTTOM_MARGIN,
                                        segmentFrame.size.width - 2*(segmentFrame.size.width * 1/10),
                                        lineWidth);
    NSColor *startColor = nil;
    NSColor *endColor = nil;
    
    switch (segmentIndex)
    {
        case 0:
            startColor = GREEN_GRADIENT_START_COLOR;
            endColor = GREEN_GRADIENT_END_COLOR;
            break;
            
        case 1:
            startColor = RED_GRADIENT_START_COLOR;
            endColor = RED_GRADIENT_END_COLOR;
            break;
            
        case 2:
            startColor = VIOLETT_GRADIENT_START_COLOR;
            endColor = VIOLETT_GRADIENT_END_COLOR;
            break;
            
        default:
            break;
    }
    
    if (startColor != nil && endColor != nil)
    {
        BOOL isSegmentSelected = self.selectedSegment == segmentIndex;
        if (!isSegmentSelected)
        {
            startColor = [NSColor colorWithCalibratedRed:startColor.redComponent green:startColor.greenComponent blue:startColor.blueComponent alpha:0.4];
            endColor = [NSColor colorWithCalibratedRed:endColor.redComponent green:endColor.greenComponent blue:endColor.blueComponent alpha:0.4];
        }
        
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
        [gradient drawInRect:coloredLineRect angle:0.0];
    }
}

//=========================================================================

- (BOOL)isSegmentHighlighted:(NSUInteger)segmentIndex
{
    return segmentIndex == self.highlightedSegmentIndex;
}

//=========================================================================

- (void)drawSegmentImage:(NSUInteger)segmentIndex withSegmentFrame:(NSRect)segmentFrame inView:(NSView *)controlView
{
    NSImage *image = [self imageForSegment:segmentIndex];

    if (!image)
        return;
    
    //Center of the segment
    NSPoint center = NSMakePoint(segmentFrame.origin.x + segmentFrame.size.width/2, segmentFrame.origin.y + segmentFrame.size.height/2);

    //Calculate image frame
    NSSize imageSize = image.size;
    NSPoint imagePoint = NSMakePoint(round(center.x - imageSize.width/2), round(center.y - imageSize.height/2));
    NSRect imageFrame = NSMakeRect(imagePoint.x, imagePoint.y, imageSize.width, imageSize.height);
    
    //Should draw image darken (i.e. highlighted)?
    BOOL shouldDarken = [self isSegmentHighlighted:segmentIndex];

    CGFloat fraction = 1.0;
    if (shouldDarken)
    {
        //Draw darken image instead of the original
        NSImage *darkenImage = [image copy];
        
        //Draw transparent dark overlay over the image
        [darkenImage lockFocus];
        [[NSColor colorWithCalibratedWhite:0.0 alpha:0.33] setFill];
        NSRect imageRect = NSMakeRect(0, 0, darkenImage.size.width, darkenImage.size.height);
        NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
        [darkenImage unlockFocus];
        
        fraction = 0.75;
        image = darkenImage;
    }
    
    [image drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:fraction];
}

//=========================================================================

- (void)drawSegmentLabel:(NSUInteger)segmentIndex withSegmentFrame:(NSRect)segmentFrame inView:(NSView *)controlView
{
    NSString *label = [self labelForSegment:segmentIndex];

    if (!label)
    {
        return;
    }
    
    NSColor *textColor = [NSColor whiteColor];
    if ([self isEnabled] == NO)
    {
        //Use disabled text color
        textColor = [NSColor lightGrayColor];
    }
 
    NSPoint center = NSMakePoint(segmentFrame.origin.x + segmentFrame.size.width/2, segmentFrame.origin.y + segmentFrame.size.height/2);

    NSDictionary *attributes = @{ NSForegroundColorAttributeName : textColor,
                                  NSFontAttributeName : [NSFont fontWithName:@"Helvetica Neue Bold" size:12] };
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:label attributes:attributes];
    NSRect titleBoundingRect = [attributedString boundingRectWithSize:segmentFrame.size options:0];
    
    NSRect titleFrame = NSMakeRect(center.x - titleBoundingRect.size.width/2, TITLE_OFFSET_FROM_BOTTOM, titleBoundingRect.size.width, titleBoundingRect.size.height);
    
    [attributedString drawWithRect:titleFrame options:0];
}

//=========================================================================

- (void)drawSegment:(NSInteger)segmentIndex inFrame:(NSRect)segmentFrame withView:(NSView *)controlView
{
    [self drawSegmentBackground:segmentIndex withSegmentFrame:segmentFrame inView:controlView];
    
    //Draw image
    [self drawSegmentImage:segmentIndex withSegmentFrame:segmentFrame inView:controlView];
    
    //Draw label
    [self drawSegmentLabel:segmentIndex withSegmentFrame:segmentFrame inView:controlView];
}

//=========================================================================

- (NSInteger)segmentForPoint:(NSPoint)point inView:(NSView *)controlView
{
    NSRect cellFrame = controlView.bounds;
    
    for (int i = 0; i < self.segmentCount; i++)
    {
        NSRect frame = [self rectForSegment:i inFrame:cellFrame];
        BOOL found = NSPointInRect(point, frame);
        
        if (found)
            return i;
    }
    
    return -1;
}

//=========================================================================

- (void)setImage:(NSImage *)image forSegment:(NSInteger)segment
{
    [_images setObject:image forKey:[NSNumber numberWithInteger:segment]];
}

//=========================================================================

- (NSImage *)imageForSegment:(NSInteger)segment
{
    return [_images objectForKey:[NSNumber numberWithInteger:segment]];
}

//=========================================================================

- (void)setLabel:(NSString *)label forSegment:(NSInteger)segment
{
    [_labels setObject:label forKey:[NSNumber numberWithInteger:segment]];
}

//=========================================================================

- (NSString *)labelForSegment:(NSInteger)segment
{
    return [_labels objectForKey:[NSNumber numberWithInteger:segment]];
}

//=========================================================================

- (void)awakeFromNib
{
    self.highlightedSegmentIndex = -1;
}

//=========================================================================

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    for (int i = 0; i < self.segmentCount; i++)
    {
        NSRect frame = [self rectForSegment:i inFrame:cellFrame];
        [self drawSegment:i inFrame:frame withView:controlView];
    }
}

//=========================================================================

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView
{
    NSInteger segment = [self segmentForPoint:startPoint inView:controlView];
    
    if (segment >= 0)
    {
        self.highlightedSegmentIndex = segment;
        return YES;
    }
    
    return NO;
}

//=========================================================================

- (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView
{
    return YES;
}

//=========================================================================

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag
{
    if (flag)
    {
        self.selectedSegment = self.highlightedSegmentIndex;
    }
    
    self.highlightedSegmentIndex = -1;
}

//=========================================================================
@end
//=========================================================================
