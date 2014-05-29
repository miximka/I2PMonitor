//
//  RCControlViewController.h
//  I2PRemoteControl
//
//  Created by miximka on 26/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCViewController.h"

@class RCControlButton;

//=========================================================================
@interface RCControlViewController : RCViewController
//=========================================================================

@property (nonatomic, weak) IBOutlet RCControlButton *actionButton1;
@property (nonatomic, weak) IBOutlet RCControlButton *actionButton2;

- (IBAction)restartGracefully:(id)sender;
- (IBAction)restartImmediately:(id)sender;
- (IBAction)shutdownGracefully:(id)sender;
- (IBAction)shutdownImmediately:(id)sender;
- (IBAction)cancelRestart:(id)sender;
- (IBAction)cancelShutdown:(id)sender;

//=========================================================================
@end
//=========================================================================
