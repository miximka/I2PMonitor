//
//  RCRouterConnectionSettingsDatabase.m
//  I2PMonitor
//
//  Created by miximka on 28/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterConnectionSettingsDatabase.h"
#import "NSFileManager+SupportDirectory.h"
#import "NSMutableDictionary+Extensions.h"
#import "RCRouterConnectionSettings.h"

//=========================================================================

#define KNOWN_ROUTER_SETTINGS_FILENAME @"KnownRouterSettings.plist"
#define KEY_KNOWN_ROUTERS               @"KnownRouters"

@interface RCRouterConnectionSettingsDatabase ()
@property (nonatomic) NSMutableDictionary *knownRouters;
@end

//=========================================================================
@implementation RCRouterConnectionSettingsDatabase
//=========================================================================

static RCRouterConnectionSettingsDatabase *_sharedInstance;
+ (instancetype)sharedDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RCRouterConnectionSettingsDatabase alloc] init];
        [_sharedInstance readSettings];
    });
    
    return _sharedInstance;
}

//=========================================================================

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _knownRouters = [NSMutableDictionary new];
    }
    return self;
}

//=========================================================================

- (void)readSettings
{
    NSURL *url = [[[NSFileManager defaultManager] applicationSupportDir] URLByAppendingPathComponent:KNOWN_ROUTER_SETTINGS_FILENAME];
    NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfURL:url];

    NSDictionary *routers = [settingsDict objectForKey:KEY_KNOWN_ROUTERS];
    if (routers != nil)
    {
        self.knownRouters = [routers mutableCopy];
    }
}

//=========================================================================

- (void)writeSettings
{
    NSMutableDictionary *settingsDict = [NSMutableDictionary new];
    
    [settingsDict setObjectIfNotNil:self.knownRouters forKey:KEY_KNOWN_ROUTERS];
    
    NSURL *url = [[[NSFileManager defaultManager] applicationSupportDir] URLByAppendingPathComponent:KNOWN_ROUTER_SETTINGS_FILENAME];
    BOOL success = [settingsDict writeToURL:url atomically:YES];
    
    if (!success)
    {
        DDLogError(@"Failed to write known router settings");
    }
}

//=========================================================================

- (RCRouterConnectionSettings *)routerSettingsForHost:(NSString *)host andPort:(NSUInteger)port
{
    __block RCRouterConnectionSettings *existingSettings = nil;

    [self.knownRouters enumerateKeysAndObjectsUsingBlock:^(NSString *identifier, NSDictionary *settingsDict, BOOL *stop)
    {
        RCRouterConnectionSettings *settings = [[RCRouterConnectionSettings alloc] initWithDictionary:settingsDict];
        
        if ([settings.host isEqualToString:host] && settings.port == port)
        {
            existingSettings = settings;
            *stop = YES;
        }
    }];
    
    return existingSettings;
}

//=========================================================================

- (void)rememberRouterSettings:(RCRouterConnectionSettings *)settings
{
    [_knownRouters setObject:[settings dictionaryRepresentation]
                      forKey:settings.identifier];
}

//=========================================================================
@end
//=========================================================================
