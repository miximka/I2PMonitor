//
//  RCRouterConnectionSettingsDatabase.h
//  I2PMonitor
//
//  Created by miximka on 28/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCRouterConnectionSettings;

//=========================================================================
@interface RCRouterConnectionSettingsDatabase : NSObject
//=========================================================================

+ (instancetype)sharedDatabase;

/**
    Returns existing router connection settings for specified host and port
 */
- (RCRouterConnectionSettings *)routerSettingsForHost:(NSString *)host andPort:(NSUInteger)port;

/**
    Adds or updates new setting to the database
 */
- (void)rememberRouterSettings:(RCRouterConnectionSettings *)settings;

/**
    Writes settings to disk
 */
- (void)writeSettings;

//=========================================================================
@end
//=========================================================================
