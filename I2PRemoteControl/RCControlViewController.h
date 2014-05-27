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

@property (nonatomic, weak) IBOutlet RCControlButton *restartButton;
@property (nonatomic, weak) IBOutlet RCControlButton *shutdownButton;

- (IBAction)restart:(id)sender;
- (IBAction)shutdown:(id)sender;

//=========================================================================
@end
//=========================================================================
