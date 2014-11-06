//
//  RCClickableTextField.m
//  I2PMonitor
//
//  Created by miximka on 28/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCLinkTextField.h"

//=========================================================================

@interface RCLinkTextField ()
@property (nonatomic) NSTrackingRectTag trackingRect;
@property (nonatomic) BOOL privateHighlighted;
@end

//=========================================================================
@implementation RCLinkTextField
//=========================================================================

- (id<RCLinkTextFieldDelegate>)delegate
{
    return (id<RCLinkTextFieldDelegate>)[super delegate];
}

//=========================================================================

- (void)setDelegate:(id<NSTextFieldDelegate>)anObject
{
    [super setDelegate:anObject];
}

//=========================================================================

- (void)registerTrackingRect
{
    [self removeTrackingRect:self.trackingRect];
    self.trackingRect = [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:NO];
}

//=========================================================================

- (void)updateText
{
    NSMutableAttributedString *mutableAttrStr = [[self attributedStringValue] mutableCopy];
    
    NSRange range;
    NSMutableDictionary *attrs = [[mutableAttrStr attributesAtIndex:0 effectiveRange:&range] mutableCopy];

    if (self.isHighlighted)
    {
        [attrs setObject:[NSNumber numberWithInteger:NSUnderlineStyleSingle] forKey:NSUnderlineStyleAttributeName];
    }
    else
    {
        [attrs removeObjectForKey:NSUnderlineStyleAttributeName];
    }
    
    [mutableAttrStr setAttributes:attrs range:range];
    
    [self setAttributedStringValue:mutableAttrStr];
}

//=========================================================================

- (void)setHighlighted:(BOOL)highlighted
{
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9) {
        //We are on 10.9 or earlier
        _privateHighlighted = highlighted;
    } else {
        //10.10 or later
        [super setHighlighted:highlighted];
    }
    
    [self updateText];
}

//=========================================================================

- (BOOL)isHighlighted
{
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9) {
        //We are on 10.9 or earlier
        return _privateHighlighted;
    }
    
    //10.10 or later
    return [super isHighlighted];
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self registerTrackingRect];
}

//=========================================================================

- (void)setBounds:(NSRect)aRect
{
    [super setBounds:aRect];
    [self registerTrackingRect];
}

//=========================================================================

- (void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];
    
    //Register for mouse events
    [self registerTrackingRect];
}

//=========================================================================

- (void)mouseEntered:(NSEvent *)theEvent
{
    [super mouseEntered:theEvent];
    [self setHighlighted:YES];
}

//=========================================================================

- (void)mouseExited:(NSEvent *)theEvent
{
    [super mouseExited:theEvent];
    [self setHighlighted:NO];
}

//=========================================================================

- (void)mouseDown:(NSEvent *)theEvent
{
    [[self delegate] clickableTextFieldMouseDown:self];
}

//=========================================================================

-(void)resetCursorRects
{
    //Remove the existing cursor rects
    [self discardCursorRects];
}

//=========================================================================
@end
//=========================================================================
