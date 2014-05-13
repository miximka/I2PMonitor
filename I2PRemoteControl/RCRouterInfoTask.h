//
//  RCRouterInfo.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCPeriodicTask.h"

//=========================================================================
@interface RCRouterInfoTask : RCPeriodicTask
//=========================================================================

@property (nonatomic) NSString *routerStatus;
@property (nonatomic) long routerUptime;
@property (nonatomic) NSString *routerVersion;

//=========================================================================
@end
//=========================================================================
