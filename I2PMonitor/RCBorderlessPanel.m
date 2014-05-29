//
//  RCBorderlessPanel.m
//  I2PMonitor
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCBorderlessPanel.h"
#import "RCAttachedPanelBackgroundView.h"

//=========================================================================
@implementation RCBorderlessPanel
//=========================================================================

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask | NSNonactivatingPanelMask backing:bufferingType defer:flag];
    if (self)
    {
        //Let panel float above all normal windows
        [self setFloatingPanel:YES];

        //Turn off restoration
        [self setRestorable:NO];
        [self disableSnapshotRestoration];
        
        //Turn off default drawing of the window (this cause to appear panel completely transparent, so all drawing should be done in the content view)
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
    }
    
    return self;
}

//=========================================================================
@end
//=========================================================================
