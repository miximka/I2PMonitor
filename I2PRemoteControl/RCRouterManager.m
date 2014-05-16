//
//  RCRouterManager.m
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterManager.h"
#import "RCPreferences.h"
#import "RCRouter.h"
#import "RCSessionConfig.h"

//=========================================================================

NSString * const RCManagerDidSetRouterNotification = @"RCManagerDidSetRouterNotification";

@interface RCRouterManager ()
@property (nonatomic) RCRouter *router;
@end

//=========================================================================
@implementation RCRouterManager
//=========================================================================

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self registerForNotifications];
    }
    return self;
}

//=========================================================================

- (void)dealloc
{
    [self unregisterFromNotifications];
}

//=========================================================================

- (void)registerForNotifications
{
    //Register for preferences change notifications
    [RCPrefs addObserver:self forPreferenceKey:PREFS_KEY_ROUTER_HOST];
    [RCPrefs addObserver:self forPreferenceKey:PREFS_KEY_ROUTER_PORT];
}

//=========================================================================

- (void)unregisterFromNotifications
{
    [RCPrefs removeObserver:self];
}

//=========================================================================

- (RCRouter *)initializedRouter
{
    RCSessionConfig *config = [[RCSessionConfig alloc] initWithHost:[RCPrefs routerHost]
                                                               port:[RCPrefs routerPort]];
    
    RCRouter *router = [[RCRouter alloc] initWithSessionConfig:config];
    return router;
}

//=========================================================================

- (void)restartRouter
{
    if (self.router != nil)
    {
        //Stop current router
        [self.router terminate];
    }

    //Create new router based on currect connection settings
    RCRouter *router = [self initializedRouter];
    
    //Remember router
    [self setRouter:router];
    
    //Start router
    [router start];

    [[NSNotificationCenter defaultCenter] postNotificationName:RCManagerDidSetRouterNotification object:self];
}

//=========================================================================
#pragma mark RCPreferencesObserver
//=========================================================================

- (void)preferenceChangedForKey:(NSString *)aKey
{
    //Host or port have been changed
    [self restartRouter];
}

//=========================================================================
@end
//=========================================================================
