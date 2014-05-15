//
//  RCPreferences.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCPreferences.h"

//=========================================================================
@implementation RCPreferences
//=========================================================================

static RCPreferences* _sharedPrefs;
+ (RCPreferences *)sharedPreferences
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                      _sharedPrefs = [[[self class] alloc] init];
                  });
    
	return _sharedPrefs;
}

//=========================================================================

+ (void)initialize
{
	//Register defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"127.0.0.1", PREFS_KEY_ROUTER_HOST,
                                 [NSNumber numberWithUnsignedInteger:7650], PREFS_KEY_ROUTER_PORT,
								 nil];
	
    [defaults registerDefaults:appDefaults];
}

//=========================================================================

- (NSString *)routerHost
{
    return [self objectForKey:PREFS_KEY_ROUTER_HOST];
}

//=========================================================================

- (void)setRouterHost:(NSString *)host
{
    [self setObject:host forKey:PREFS_KEY_ROUTER_HOST];
}

//=========================================================================

- (NSUInteger)routerPort
{
    return [[self objectForKey:PREFS_KEY_ROUTER_PORT] unsignedIntegerValue];
}

//=========================================================================

- (void)setRouterPort:(NSUInteger)port
{
    [self setObject:[NSNumber numberWithUnsignedInteger:port] forKey:PREFS_KEY_ROUTER_PORT];
}

//=========================================================================
@end
//=========================================================================
