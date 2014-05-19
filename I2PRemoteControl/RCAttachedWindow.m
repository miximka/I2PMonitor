//
//  RCAttachedWindow.m
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCAttachedWindow.h"
#import "RCAttachedPanelBackgroundView.h"

//=========================================================================

@interface RCAttachedWindow ()
@property (nonatomic) NSView *contentHolderView;
@property (nonatomic) BOOL fadeAnimationCompleted;
@end

//=========================================================================
@implementation RCAttachedWindow
//=========================================================================

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask | NSNonactivatingPanelMask backing:bufferingType defer:flag];
    if (self)
    {
        //Add view to draw window background
        RCAttachedPanelBackgroundView *bgView = [[RCAttachedPanelBackgroundView alloc] initWithFrame:contentRect];
        [self setContentView:bgView];
        
        //Add view which will work as a content view
        NSView *contentHolderView = [[NSView alloc] initWithFrame:[self.contentView bounds]];
        [contentHolderView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [bgView addSubview:contentHolderView];
        
        self.contentHolderView = contentHolderView;
    }
    
    return self;
}

//=========================================================================

- (void)fadeOut
{
    self.fadeAnimationCompleted = NO;

    [[NSAnimationContext currentContext] setDuration:0.1];
    __weak RCAttachedWindow *blockSelf = self;
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        blockSelf.fadeAnimationCompleted = YES;
    }];
    [self.animator setAlphaValue:0];
    
    while (!self.fadeAnimationCompleted)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
    }
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (BOOL)canBecomeKeyWindow
{
    //Allow to become key window to be able to receive windowDidResignKey: notification
    //and dismiss the panel automatically
    return YES;
}

//=========================================================================

- (void)orderOut:(id)sender
{
	//This is a blocking call
    [self fadeOut];
	
	//Order out window. Param is already gone so we dont it here any more...
	[super orderOut:sender];
    
    //Restore alpha value after window has been moved from screen
    [self setAlphaValue:1.0];
}

//=========================================================================
@end
//=========================================================================
