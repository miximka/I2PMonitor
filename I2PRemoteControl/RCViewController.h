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

- (void)willMoveToParentViewController:(NSViewController *)controller;
- (void)didMoveToParentViewController:(NSViewController *)controller;

- (void)updateGUI;

//=========================================================================
@end
//=========================================================================
