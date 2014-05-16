//
//  RCMenuItem.h
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RCViewController;

//=========================================================================
@interface RCMenuItem : NSMenuItem
//=========================================================================

@property (nonatomic) RCViewController *controller;

//=========================================================================
@end
//=========================================================================
