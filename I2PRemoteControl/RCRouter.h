//
//  RCRouter.h
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================

@class RCSessionConfig;
@class RCRouterInfo;

extern NSString * const RCRouterDidUpdateRouterInfoNotification;

//=========================================================================
@interface RCRouter : NSObject
//=========================================================================

- (instancetype)initWithSessionConfig:(RCSessionConfig *)sessionConfig;

@property (nonatomic, readonly) RCSessionConfig *sessionConfig;

/**
    Entry point. Authenticates with router and starts updating data.
 */
- (void)start;
- (void)stop;

@property (nonatomic, readonly) RCRouterInfo *routerInfo;

/**
    Manually schedule router info update task
 */
- (void)updateRouterInfo;

//=========================================================================
@end
//=========================================================================
