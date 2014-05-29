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
@class RCValueTextField;

//=========================================================================
@interface RCNetworkViewController : RCViewController
//=========================================================================

@property (nonatomic, assign) IBOutlet CPTGraphHostingView *graphHostView;
@property (nonatomic) IBOutlet RCGraphTextField *inboundTextField;
@property (nonatomic) IBOutlet RCGraphTextField *outboundTextField;
@property (nonatomic) IBOutlet NSTextField *inOutTextField;
@property (nonatomic) IBOutlet RCValueTextField *inboundTotalTextField;
@property (nonatomic) IBOutlet RCValueTextField *outboundTotalTextField;

//=========================================================================
@end
//=========================================================================
