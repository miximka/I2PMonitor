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

@interface RCRouterInfo ()
@property (nonatomic) NSDate *estimatedStartupDate;
@end

//=========================================================================
@implementation RCRouterInfo
//=========================================================================

- (instancetype)initWithResponseDictionary:(NSDictionary *)response
{
    self = [super init];
    if (self)
    {
        _routerNetStatus = kNetStatusUnknown;
        [self updateWithResponseDictionary:response];
    }
    return self;
}

//=========================================================================

- (void)updateWithResponseDictionary:(NSDictionary *)response
{
    self.routerVersion = [response objectForKey:PARAM_KEY_ROUTER_VERSION];
    self.routerStatus = [response objectForKey:PARAM_KEY_ROUTER_STATUS];
    
    long uptime = [[response objectForKey:PARAM_KEY_ROUTER_UPTIME] longValue];

    //Calculate startup date
    NSTimeInterval uptimeInSec = uptime / 1000;
    self.estimatedStartupDate = [[NSDate date] dateByAddingTimeInterval:-uptimeInSec];
    
    self.routerUptime = uptime;
    
    self.routerNetStatus = [[response objectForKey:PARAM_KEY_ROUTER_NET_STATUS] longValue];
    self.activePeers = [[response objectForKey:PARAM_KEY_ROUTER_NETDB_ACTIVE_PEERS] longValue];
    self.fastPeers = [[response objectForKey:PARAM_KEY_ROUTER_NETDB_FAST_PEERS] longValue];
    self.highCapacityPeers = [[response objectForKey:PARAM_KEY_ROUTER_NETDB_HIGH_CAPACITY_PEERS] longValue];
    self.knownPeers = [[response objectForKey:PARAM_KEY_ROUTER_NETDB_KNOWN_PEERS] longValue];
    self.participatingTunnels = [[response objectForKey:PARAM_KEY_ROUTER_NET_TUNNELS_PARTICIPATING] longValue];
}

//=========================================================================

- (NSTimeInterval)estimatedRouterUptime
{
    NSTimeInterval estimatedUptime = [[NSDate date] timeIntervalSinceDate:self.estimatedStartupDate];
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
