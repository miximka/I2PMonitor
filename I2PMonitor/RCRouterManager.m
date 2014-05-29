//
//  RCRouterManager.m
//  I2PMonitor
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterManager.h"
#import "RCPreferences.h"
#import "RCRouter.h"
#import "RCRouterConnectionSettings.h"
#import "RCRouterConnectionSettingsDatabase.h"

//=========================================================================

#define ROUTER_SETTING_UUID     @"UUID"

NSString * const RCManagerDidSetRouterNotification = @"RCManagerDidSetRouterNotification";

@interface RCRouter (Friend)
- (void)setParentManager:(RCRouterManager *)manager;
@end

@interface RCRouterManager ()
@property (nonatomic) RCRouter *activeRouter;
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

- (RCRouter *)activeRouter
{
    return _activeRouter;
}

//=========================================================================

- (void)startRouter:(RCRouter *)router
{
    //Stop current active router
    [self _stopActiveRouter];
    
    self.activeRouter = router;
    [router setParentManager:self];
    [router start];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RCManagerDidSetRouterNotification object:self];
}

//=========================================================================

- (void)_stopActiveRouter
{
    [self.activeRouter terminate];
    self.activeRouter = nil;
}

//=========================================================================

- (void)stopActiveRouter
{
    [self _stopActiveRouter];
    [[NSNotificationCenter defaultCenter] postNotificationName:RCManagerDidSetRouterNotification object:self];
}

//=========================================================================

- (void)startDefaultRouter
{
    //Stop current router, if any
    [self _stopActiveRouter];
    
    //Get connection settings from preferences
    RCRouterConnectionSettings *settings = [[RCRouterConnectionSettingsDatabase sharedDatabase] routerSettingsForHost:[RCPrefs routerHost] andPort:[RCPrefs routerPort]];
    
    if (settings == nil)
    {
        //There are no saved connection settings yet, so create them
        settings = [[RCRouterConnectionSettings alloc] init];
        settings.identifier = [[NSUUID UUID] UUIDString];
        settings.host = [RCPrefs routerHost];
        settings.port = [RCPrefs routerPort];
    }
    
    RCRouter *router = [[RCRouter alloc] initWithConnectionSettings:settings];
    [self startRouter:router];
}

//=========================================================================
#pragma mark RCPreferencesObserver
//=========================================================================

- (void)preferenceChangedForKey:(NSString *)aKey
{
    //Host or port have been changed
    [self startDefaultRouter];
}

//=========================================================================
#pragma mark Callback Notifications from Router
//=========================================================================

- (void)routerDidUpdateConnectionSettings:(RCRouter *)router
{
    //Write changed settings to database
    [[RCRouterConnectionSettingsDatabase sharedDatabase] rememberRouterSettings:router.connectionSettings];
    [[RCRouterConnectionSettingsDatabase sharedDatabase] writeSettings];
}

//=========================================================================
@end
//=========================================================================
