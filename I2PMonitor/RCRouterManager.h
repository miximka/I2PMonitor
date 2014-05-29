//
//  RCRouterManager.h
//  I2PMonitor
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCPreferences.h"

@class RCRouter;
@class RCRouterManager;

//Sent when manager changes the router
extern NSString * const RCManagerDidSetRouterNotification;

//=========================================================================
@interface RCRouterManager : NSObject <RCPreferencesObserver>
//=========================================================================

/**
    Returns currently active router.
 */
- (RCRouter *)activeRouter;

/**
    Starts router configured with connection settings from application preferences
 */
- (void)startDefaultRouter;

/**
    Stops currently active router
 */
- (void)stopActiveRouter;

//=========================================================================
@end
//=========================================================================
