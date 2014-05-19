//
//  RCRouterInfo.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RCRouterNetStatus)
{
    kNetStatusUnknown                       = - 1,
    kNetStatusOK                            = 0,
    kNetStatusTesting                       = 1,
    kNetStatusFirewalled                    = 2,
    kNetStatusHidden                        = 3,
    kNetStatusWarnFirewalledAndFast         = 4,
    kNetStatusWarnFirewalledAndFloodfill    = 5,
    kNetStatusWarnFirewalledWithInboundTCP  = 6,
    kNetStatusWarnFirewalledWithUDPDisabled = 7,
    kNetStatusErrorI2CP                     = 8,
    kNetStatusErrorClockSkew                = 9,
    kNetStatusErrorPrivateTCPAddress        = 10,
    kNetStatusErrorSymmetricNat             = 11,
    kNetStatusErrorUDPPortInUse             = 12,
    kNetStatusErrorNoActivePeersCheckConnectionAndFirewall  = 13,
    kNetStatusErrorUDPDisabledAndTCPUnset   = 14,
};

//=========================================================================
@interface RCRouterInfo : NSObject
//=========================================================================

- (instancetype)initWithResponseDictionary:(NSDictionary *)response;

- (void)updateWithResponseDictionary:(NSDictionary *)response;

@property (nonatomic) NSString *routerStatus;

/**
    Last known value from router
 */
@property (nonatomic) long routerUptime;

/**
    Calculated from -routerUptime and current date
 */
- (NSTimeInterval)estimatedRouterUptime;

@property (nonatomic) NSString *routerVersion;
@property (nonatomic) RCRouterNetStatus routerNetStatus;

//=========================================================================
@end
//=========================================================================
