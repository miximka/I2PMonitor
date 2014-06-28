//
//  RCStatusBarView.m
//  I2PMonitor
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCStatusBarView.h"

@interface RCStatusBarView ()
@property (nonatomic) BOOL privateHighlighted;
@end

//=========================================================================
@implementation RCStatusBarView
//=========================================================================

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		[self setImageAlignment:NSImageAlignCenter];
		[self setImageScaling:NSImageScaleProportionallyDown];
		[self setImageFrameStyle:NSImageFrameNone];

        [self setIconType:RCIconTypeInactive];
    }
    return self;
}

//=========================================================================

- (void)setHighlighted:(BOOL)highlighted
{
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9) {
        //We are on 10.9 or earlier
        _privateHighlighted = highlighted;
        [self setNeedsDisplay];
        return;
    }

    //10.10 or later
    [super setHighlighted:highlighted];
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

- (void)setIconType:(RCStatusBarIconType)iconType
{
    if (_iconType != iconType)
    {
        _iconType = iconType;
        [self setIconForIconType:iconType];
    }
}

//=========================================================================

- (void)setIconForIconType:(RCStatusBarIconType)iconType
{
    NSString *imageName = @"StatusBarIcon_Inactive";
    if (iconType == RCIconTypeActive)
    {
        imageName = @"StatusBarIcon";
    }
    
    NSImage *image = [NSImage imageNamed:imageName];
    [self setImage:image];
}

//=========================================================================

- (void)toggleMenu
{
    NSMenu *menu = self.statusItem.menu;
    [self.statusItem popUpStatusItemMenu:menu];
}

//=========================================================================

- (void)toggleHighlighted
{
    self.highlighted = !self.highlighted;
    [self.delegate statusBarViewDidChangeHighlighted:self];
}

//=========================================================================
#pragma mark Overriden methods
//=========================================================================

- (void)drawRect:(NSRect)dirtyRect
{
	//Draw background (probably highlighted)
	[self.statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:self.highlighted];
	
	//Draw image
	[super drawRect:dirtyRect];
}

//=========================================================================

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    [self toggleHighlighted];
}

//=========================================================================

- (void)rightMouseDown:(NSEvent *)theEvent
{
    [super rightMouseDown:theEvent];
    [self toggleMenu];
}

//=========================================================================
@end
//=========================================================================
