//
//  RCRouterOverviewViewController.h
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCViewController.h"

//=========================================================================
@interface RCRouterOverviewViewController : RCViewController
//=========================================================================

@property (nonatomic) IBOutlet NSTextField *hostTextField;
@property (nonatomic) IBOutlet NSTextField *versionTextField;
@property (nonatomic) IBOutlet NSTextField *uptimeTextField;
@property (nonatomic) IBOutlet NSTextField *statusTextField;

//=========================================================================
#pragma mark Unit Tests
//=========================================================================

- (NSString *)uptimeStringForInterval:(NSTimeInterval)interval;

//=========================================================================
@end
//=========================================================================
