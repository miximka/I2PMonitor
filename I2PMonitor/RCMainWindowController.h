//
//  RCMainWindowController.h
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCAttachedWindowController.h"

//=========================================================================

@class RCMainViewController;
@class RCMainWindowController;

@protocol RCMainWindowControllerDelegate <NSObject>
- (void)mainWindowControllerShouldDismissWindow:(RCMainWindowController *)controller;
@end

//=========================================================================
@interface RCMainWindowController : RCAttachedWindowController <NSWindowDelegate>
//=========================================================================

@property (nonatomic, weak) id<RCMainWindowControllerDelegate> delegate;
@property (nonatomic, readonly) RCMainViewController *mainViewController;

//=========================================================================
@end
//=========================================================================
