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

- (BOOL)canBecomeKeyWindow
{
    //Allow to become key window to be able to receive windowDidResignKey: notification
    //and dismiss the panel automatically
    return YES;
}

//=========================================================================
@end
//=========================================================================
