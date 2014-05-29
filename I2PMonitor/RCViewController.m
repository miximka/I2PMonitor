//
//  RCViewController.m
//  I2PMonitor
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCViewController.h"

//=========================================================================
@implementation RCViewController
//=========================================================================

- (NSSize)preferredViewSize
{
    return self.view.frame.size;
}

//=========================================================================

- (void)willMoveToParentViewController:(NSViewController *)controller
{
}

//=========================================================================

- (void)didMoveToParentViewController:(NSViewController *)controller
{
    if (controller != nil && self.view.window != nil)
    {
        [self startUpdatingGUI];
    }
    else
    {
        [self stopUpdatingGUI];
    }
}

//=========================================================================

- (void)updateGUI
{
}

//=========================================================================

- (void)startUpdatingGUI
{
}

//=========================================================================

- (void)stopUpdatingGUI
{
}

//=========================================================================

- (void)setRepresentedObject:(id)object
{
    [super setRepresentedObject:object];
    [self updateGUI];
}

//=========================================================================
@end
//=========================================================================
