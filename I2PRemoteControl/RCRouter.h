//
//  RCRouter.h
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCRouterTaskManager.h"

@class RCSessionConfig;
@class RCRouterInfo;
@class RCBWMeasurementBuffer;

//Sent when router info is updated
extern NSString * const RCRouterDidUpdateRouterInfoNotification;
extern NSString * const RCRouterDidUpdateBandwidthNotification;

//=========================================================================
@interface RCRouter : NSObject <RCRouterTaskManagerDelegate>
//=========================================================================

- (instancetype)initWithSessionConfig:(RCSessionConfig *)sessionConfig;

@property (nonatomic, readonly) RCSessionConfig *sessionConfig;

/**
    Returns YES if session to the router is active
 */
@property (nonatomic, readonly) BOOL active;
@property (nonatomic, readonly) BOOL authenticating;

/**
    Constains last error occurred during communication with router
 */
@property (nonatomic, readonly) NSError *lastError;

/**
    Entry point. Authenticates with router and starts updating data.
 */
- (void)start;
- (void)terminate;

/**
    Contains basic infos (router version, uptime, status)
 */
@property (nonatomic, readonly) RCRouterInfo *routerInfo;

/**
    Schedule recurring "router info update" task
 */
- (void)postPeriodicRouterInfoUpdateTask;
- (void)cancelPeriodicRouterInfoTask;

/**
    Schedule non-recurring "router info update" task (i.e. one-shot)
 */
- (void)postRouterInfoUpdateTask;

/**
    Returns buffer containing bandwidth measurements
 */
@property (nonatomic, readonly) RCBWMeasurementBuffer *measurementsBuffer;

//=========================================================================
@end
//=========================================================================
