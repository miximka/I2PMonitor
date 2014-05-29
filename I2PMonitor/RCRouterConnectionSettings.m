//
//  RCRouterConnectionSettings.m
//  I2PMonitor
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterConnectionSettings.h"
#import "NSMutableDictionary+Extensions.h"

//=========================================================================

#define DEFAULT_WEBUI_CONSOLE_PORT 7657

#define ROUTER_SETTING_IDENTIFIER_KEY   @"Identifier"
#define ROUTER_SETTING_HOST_KEY         @"Host"
#define ROUTER_SETTING_PORT_KEY         @"Port"
#define ROUTER_SETTING_AUTH_KEY         @"AuthKey"

//=========================================================================
@implementation RCRouterConnectionSettings
//=========================================================================

- (instancetype)initWithDictionary:(NSDictionary *)settings
{
    self = [super init];
    if (self)
    {
        _identifier = [settings objectForKey:ROUTER_SETTING_IDENTIFIER_KEY];
        _host = [settings objectForKey:ROUTER_SETTING_HOST_KEY];
        _port = [[settings objectForKey:ROUTER_SETTING_PORT_KEY] unsignedIntegerValue];
        _authToken = [settings objectForKey:ROUTER_SETTING_AUTH_KEY];
        _consolePort = DEFAULT_WEBUI_CONSOLE_PORT;
    }
    return self;
}

//=========================================================================

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary new];

    [dict setObjectIfNotNil:self.identifier forKey:ROUTER_SETTING_IDENTIFIER_KEY];
    [dict setObjectIfNotNil:self.host forKey:ROUTER_SETTING_HOST_KEY];
    [dict setObjectIfNotNil:[NSNumber numberWithUnsignedInteger:self.port] forKey:ROUTER_SETTING_PORT_KEY];
    [dict setObjectIfNotNil:self.authToken forKey:ROUTER_SETTING_AUTH_KEY];
    
    return dict;
}

//=========================================================================
@end
//=========================================================================
