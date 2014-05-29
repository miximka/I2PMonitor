//
//  RCArrowPanel.m
//  I2PMonitor
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCArrowPanel.h"
#import "RCArrowAnimation.h"


//=========================================================================

@interface RCArrowPanel ()
@property (strong, nonatomic) NSAnimation *animation;
@end

//=========================================================================
@implementation RCArrowPanel
//=========================================================================

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation
{
    //Make window borderless
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:deferCreation];
    if (self)
    {
        //Make window background transparent
        [self setOpaque:NO];
        [self setLevel:NSFloatingWindowLevel];
        [self setBackgroundColor:[NSColor clearColor]];
    }
    return self;
}

//=========================================================================

- (void)dealloc
{
    [self.animation stopAnimation];
    [self setAnimation:nil];
}

//=========================================================================

- (RCArrowAnimation *)animationForDirection:(BOOL)moveUp
{
    RCArrowAnimation *animation = [[RCArrowAnimation alloc] initWithDuration:0.5 animationCurve:NSAnimationEaseInOut];
    [animation setPanel:self];
    [animation setAnimationBlockingMode:NSAnimationNonblocking];
    [animation setDelegate:self];
    [animation setMoveDirectionUp:moveUp];
    
    return animation;
}

//=========================================================================

- (void)startAnimationForDirection:(BOOL)moveUp
{
    RCArrowAnimation *animation = [self animationForDirection:moveUp];
    
    [animation startAnimation];
    [self setAnimation:animation];
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)makeKeyAndOrderFront:(id)sender
{
    [super makeKeyAndOrderFront:sender];

    //Start two animations "fade in" and "swinging" animations
    [self startAnimationForDirection:NO];
}

//=========================================================================

- (void)orderOut:(id)sender
{
    [super orderOut:sender];
    
    //Stop animation if running
    [self.animation stopAnimation];
    [self setAnimation:nil];
}

//=========================================================================
#pragma mark NSAnimationDelegate
//=========================================================================

- (void)animationDidEnd:(RCArrowAnimation *)anAnimation
{
    [self startAnimationForDirection:!anAnimation.moveDirectionUp];
}

//=========================================================================
@end
//=========================================================================
