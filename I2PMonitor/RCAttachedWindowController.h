//
//  RCAttachedWindowController.h
//  I2PMonitor
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RCAttachedWindowController;

//=========================================================================
@interface RCAttachedWindowController : NSWindowController <NSWindowDelegate>
//=========================================================================

- (NSView *)contentContainerView;

/**
    Shows window with the top left corner positioned to the the specified coordinate
 */
- (void)showWindowAtPoint:(NSPoint)point;

/**
    Called during initialization
 */
- (void)setupViews;

//=========================================================================
@end
//=========================================================================
