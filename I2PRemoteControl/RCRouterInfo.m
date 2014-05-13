//
//  RCRouterInfo.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterInfo.h"

//=========================================================================
@implementation RCRouterInfo
//=========================================================================

- (NSString *)description
{
    NSString *descr = [NSString stringWithFormat:@"Router status: %@, uptime: %lu, version: %@", self.routerStatus, self.routerUptime, self.routerVersion];
    return descr;
}

//=========================================================================
@end
//=========================================================================
