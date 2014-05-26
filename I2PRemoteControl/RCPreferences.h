//
//  RCPreferences.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCApplicationPreferences.h"

#define RCPrefs [RCPreferences sharedPreferences]

#define PREFS_KEY_ROUTER_HOST               @"RouterHost"
#define PREFS_KEY_ROUTER_PORT               @"RouterPort"
#define PREFS_KEY_FIRST_START               @"FirstStart"
#define PREFS_KEY_START_ON_SYSTEM_STARTUP   @"StartOnSystemStartup"
#define PREFS_KEY_SHOW_NOTIFICATION_TYPE    @"ShowNotificationType"

typedef NS_ENUM(NSUInteger, RCRouterShowNotificationsType)
{
    kRouterShowAllNotificationsType             = 0,
    kRouterShowOnlyImportantNotificationsType   = 1,
};

//=========================================================================
@interface RCPreferences : RCApplicationPreferences
//=========================================================================

+ (RCPreferences *)sharedPreferences;

- (NSString *)routerHost;
- (void)setRouterHost:(NSString *)host;

- (NSUInteger)routerPort;
- (void)setRouterPort:(NSUInteger)port;

- (BOOL)isFirstStart;
- (void)setIsFirstStart:(BOOL)flag;

- (BOOL)startOnSystemStartup;
- (void)setStartOnSystemStartup:(BOOL)flag;

- (RCRouterShowNotificationsType)showNotificationsType;
- (void)setShowNotificationsType:(RCRouterShowNotificationsType)type;

//=========================================================================
@end
//=========================================================================
