//
//  RCAppDelegate.m
//  I2PRemoteControl
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCAppDelegate.h"
#import "RCRouter.h"
#import "RCSessionConfig.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"
#import "RCLogFormatter.h"
#import "RCRouterInfoTask.h"
#import "RCRouterInfo.h"

//=========================================================================

//Should correspond to the statusBarMenu tags in MainMenu.xib
typedef NS_ENUM(NSUInteger, RCMenuItemTag)
{
    kRouterVersionMenuTag   = 0,
    kRouterUptimeMenuTag    = 1,
    kRouterStatusMenuTag    = 2,
};

@interface RCAppDelegate ()
@property (nonatomic) RCRouter *router;
@property (nonatomic) NSStatusItem *statusBarItem;
@end

//=========================================================================
@implementation RCAppDelegate
//=========================================================================

- (void)initializeLogging
{
    RCLogFormatter *logFormatter = [[RCLogFormatter alloc] init];
    
    [[DDASLLogger sharedInstance] setLogFormatter:logFormatter];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setLogFormatter:logFormatter];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; //24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [fileLogger setLogFormatter:logFormatter];
    [DDLog addLogger:fileLogger];
    
    //Log application version
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    DDLogInfo(@"===");
    DDLogInfo(@"App version: %@ (%@)", [infoDict objectForKey:@"CFBundleShortVersionString"], [infoDict objectForKey:@"CFBundleVersion"]);
}

//=========================================================================

- (void)addStatusBarItem
{
    //Create status bar item
	NSStatusItem *item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSImage *image = [NSImage imageNamed:@"StatusBarIcon"];
    [item setImage:image];
    [item setHighlightMode:YES];
    [item setMenu:self.statusBarMenu];
    
    self.statusBarItem = item;
}

//=========================================================================

- (void)menuItem:(NSMenuItem *)menuItem setTitleWithFormat:(NSString *)format value:(id)value
{
    if (value == nil)
        value = @"-";
    
    NSString *title = [NSString stringWithFormat:format, value];
    [menuItem setTitle:title];
}

//=========================================================================

- (NSString *)durationStringWithDurationInSec:(long)duration
{
    //TODO: Implement it
    return [NSString stringWithFormat:@"%li sec", duration];
}

//=========================================================================

- (void)updateGUI
{
    //Update router version
    NSMenuItem *item = [self.statusBarItem.menu itemWithTag:kRouterVersionMenuTag];
    NSString *strValue = self.router.routerInfoTask.routerInfo.routerVersion;
    [self menuItem:item setTitleWithFormat:MyLocalStr(@"VersionTitle") value:strValue];
    
    //Update router uptime
    item = [self.statusBarItem.menu itemWithTag:kRouterUptimeMenuTag];
    long uptime = self.router.routerInfoTask.routerInfo.routerUptime;
    strValue = nil;
    if (uptime > 0)
    {
        strValue = [self durationStringWithDurationInSec:uptime];
    }
    [self menuItem:item setTitleWithFormat:MyLocalStr(@"UptimeTitle") value:strValue];

    //Update router status
    item = [self.statusBarItem.menu itemWithTag:kRouterStatusMenuTag];
    strValue = self.router.routerInfoTask.routerInfo.routerStatus;
    [self menuItem:item setTitleWithFormat:MyLocalStr(@"StatusTitle") value:strValue];
}

//=========================================================================

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initializeLogging];
    [self addStatusBarItem];
    
    RCSessionConfig *config = [RCSessionConfig defaultConfig];
    
    _router = [[RCRouter alloc] initWithSessionConfig:config];
    [_router startSessionWithCompletionHandler:^(BOOL success, NSError *error) {
        
        if (!success)
        {
            DDLogError(@"Failed to start router: %@", error);
        }
        
    }];
    
    [self updateGUI];
}

//=========================================================================

- (IBAction)shutdown:(id)sender
{
    DDLogInfo(@"Shutdown");
}

//=========================================================================

- (IBAction)restart:(id)sender
{
    DDLogInfo(@"Restart");
}

//=========================================================================
@end
//=========================================================================
