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

//=========================================================================

@interface RCAppDelegate ()
@property (nonatomic) RCRouter *router;
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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initializeLogging];
    
    RCSessionConfig *config = [RCSessionConfig defaultConfig];
    
    _router = [[RCRouter alloc] initWithSessionConfig:config];
    [_router startSessionWithCompletionHandler:^(BOOL success, NSError *error) {
        
        if (!success)
        {
            DDLogError(@"Failed to start router: %@", error);
        }
        
    }];
}

//=========================================================================
@end
//=========================================================================
