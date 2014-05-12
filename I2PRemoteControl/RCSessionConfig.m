//
//  RCSessionConfig.m
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCSessionConfig.h"

#define DEFAULT_HOST @"localhost"
#define DEFAULT_PORT 7650

//=========================================================================
@implementation RCSessionConfig
//=========================================================================

- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port
{
    self = [super init];
    if (self)
    {
        _host = host;
        _port = port;
    }
    return self;
}

//=========================================================================

+ (instancetype)defaultConfig
{
    RCSessionConfig *config = [[RCSessionConfig alloc] init];

    config.host = DEFAULT_HOST;
    config.port = DEFAULT_PORT;
    
    return config;
}

//=========================================================================
@end
//=========================================================================
