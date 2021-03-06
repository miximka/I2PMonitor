//
//  RCRouter.h
//  I2PMonitor
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCRouterTaskManager.h"

@class RCRouterConnectionSettings;
@class RCRouterInfo;
@class RCBWMeasurementBuffer;

//Sent when router info is updated
extern NSString * const RCRouterDidUpdateRouterInfoNotification;
extern NSString * const RCRouterDidUpdateBandwidthNotification;

typedef NS_ENUM(NSInteger, RCRouterLifecycleStatus)
{
    kRouterLifecycleUnknownStatus               = -1,
    kRouterLifecycleActive                      = 0,
    kRouterLifecycleRestartingGracefully        = 1,
    kRouterLifecycleRestartingHard              = 2,
    kRouterLifecycleShuttingDownGracefully      = 3,
    kRouterLifecycleShuttingDownHard            = 4,
};

//=========================================================================
@interface RCRouter : NSObject <RCRouterTaskManagerDelegate>
//=========================================================================

- (instancetype)initWithConnectionSettings:(RCRouterConnectionSettings *)connectionSettings;

@property (nonatomic, readonly) RCRouterConnectionSettings *connectionSettings;

//=========================================================================
#pragma mark Router Connection Handling
//=========================================================================

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
    Entry point. Opens connection to remote router and starts updating data.
 */
- (void)start;
- (void)terminate;

//=========================================================================
#pragma mark Router Info
//=========================================================================

/**
    Router basic infos (router version, uptime, status)
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
    Bandwidth measurements buffer
 */
@property (nonatomic, readonly) RCBWMeasurementBuffer *measurementsBuffer;

/**
    Current router lifecycle status
 */
@property (nonatomic, readonly) RCRouterLifecycleStatus lifecycleStatus;

/**
    Posts router restart task
 */
- (void)restartRouterGracefully:(BOOL)gracefully;
- (void)cancelRestart;

- (void)shutdownRouterGracefully:(BOOL)gracefully;
- (void)cancelShutdown;

//=========================================================================
@end
//=========================================================================
