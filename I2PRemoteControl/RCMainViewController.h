//
//  RCMainViewController.h
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================
@interface RCMainViewController : NSViewController
//=========================================================================

@property (nonatomic) IBOutlet NSView *contentView;
@property (nonatomic) IBOutlet NSButton *networkButton;
@property (nonatomic) IBOutlet NSButton *congestionButton;

//=========================================================================
@end
//=========================================================================
