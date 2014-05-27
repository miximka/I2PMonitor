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
    [self showWindow:self];

    NSPoint panelPoint = point;
    CGFloat panelHeight = self.window.frame.size.height;
    
    panelPoint.y -= panelHeight;
    [self.window setFrameOrigin:panelPoint];
}

//=========================================================================

- (void)setupViews
{
}

//=========================================================================
@end
//=========================================================================
