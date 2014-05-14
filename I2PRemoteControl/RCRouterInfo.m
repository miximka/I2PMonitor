//
//  RCRouterInfo.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterInfo.h"
#import "RCRouterApi.h"

//=========================================================================
@implementation RCRouterInfo
//=========================================================================

- (void)updateWithResponseDictionary:(NSDictionary *)response
{
    self.routerStatus = [response objectForKey:PARAM_KEY_ROUTER_STATUS];
    self.routerUptime = [[response objectForKey:PARAM_KEY_ROUTER_UPTIME] longValue];
    self.routerVersion = [response objectForKey:PARAM_KEY_ROUTER_VERSION];
}

//=========================================================================

- (NSTimeInterval)estimatedRouterUptime
{
    NSTimeInterval uptimeInSec = self.routerUptime / 1000;
    NSDate *startupDate = [[NSDate date] dateByAddingTimeInterval:-uptimeInSec];
    NSTimeInterval estimatedUptime = [[NSDate date] timeIntervalSinceDate:startupDate];
    
    return estimatedUptime;
}

//=========================================================================

- (NSString *)description
{
    NSString *descr = [NSString stringWithFormat:@"Router status: %@, uptime: %lu, version: %@", self.routerStatus, self.routerUptime, self.routerVersion];
    return descr;
}

//=========================================================================
@end
//=========================================================================
