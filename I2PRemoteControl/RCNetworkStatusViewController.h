//
//  RCNetworkStatusViewController.h
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCViewController.h"

@class CPTGraphHostingView;
@class RCGraphTextField;

//=========================================================================
@interface RCNetworkStatusViewController : RCViewController
//=========================================================================

@property (nonatomic, assign) IBOutlet CPTGraphHostingView *graphHostView;
@property (nonatomic) IBOutlet RCGraphTextField *downloadTextField;
@property (nonatomic) IBOutlet RCGraphTextField *uploadTextField;
@property (nonatomic) IBOutlet NSImageView *statusImageView;
@property (nonatomic) IBOutlet NSTextField *singleLineStatusTextField;
@property (nonatomic) IBOutlet NSTextField *multiLineStatusTextField;

//=========================================================================
@end
//=========================================================================
