//
//  RCAttachedWindowController.m
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCAttachedWindowController.h"
#import "RCAttachedWindow.h"

//=========================================================================

@interface RCAttachedWindowController ()
@end

//=========================================================================
@implementation RCAttachedWindowController
//=========================================================================

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self)
    {
        assert([window isKindOfClass:[RCAttachedWindow class]]);
        [window setDelegate:self];

        [self setupViews];
    }
    
    return self;
}

//=========================================================================

- (NSView *)contentContainerView
{
    return [(RCAttachedWindow *)self.window contentContainerView];
}

//=========================================================================

- (void)showWindowAtPoint:(NSPoint)point
{
    NSPoint panelPoint = point;
    panelPoint.y -= self.window.frame.size.height;
    
    [self showWindow:self];
    [self.window setFrameOrigin:panelPoint];
}

//=========================================================================

- (void)setupViews
{
}

//=========================================================================
@end
//=========================================================================
