//
//  RCPreferences.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCApplicationPreferences.h"

#define RCPrefs [RCPreferences sharedPreferences]

#define PREFS_KEY_ROUTER_HOST @"RouterHost"
#define PREFS_KEY_ROUTER_PORT @"RouterPort"

//=========================================================================
@interface RCPreferences : RCApplicationPreferences
//=========================================================================

+ (RCPreferences *)sharedPreferences;

- (NSString *)routerHost;
- (void)setRouterHost:(NSString *)host;

- (NSUInteger)routerPort;
- (void)setRouterPort:(NSUInteger)port;

//=========================================================================
@end
//=========================================================================
