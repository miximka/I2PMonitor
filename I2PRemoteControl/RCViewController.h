//
//  RCViewController.h
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================
@interface RCViewController : NSViewController
//=========================================================================

- (NSSize)preferredViewSize;

/**
    Called when receiver is about to be added to parent view controller.
    Subclasses shoud call super implementation.
 */
- (void)willMoveToParentViewController:(NSViewController *)controller;
- (void)didMoveToParentViewController:(NSViewController *)controller;

- (void)updateGUI;

/**
    Called to let the receiver know that it can start periodic UI updates, if needed.
 */
- (void)startUpdatingGUI;
- (void)stopUpdatingGUI;

//=========================================================================
@end
//=========================================================================
