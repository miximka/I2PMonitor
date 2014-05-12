//
//  RCAppDelegate.m
//  I2PRemoteControl
//
//  Created by Maksim Bauer on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCAppDelegate.h"
#import "RCRouter.h"
#import "RCSessionConfig.h"

//=========================================================================

@interface RCAppDelegate ()
@property (nonatomic) RCRouter *router;
@end

//=========================================================================
@implementation RCAppDelegate
//=========================================================================

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    RCSessionConfig *config = [RCSessionConfig defaultConfig];
    config.host = @"pi";
    
    _router = [[RCRouter alloc] initWithSessionConfig:config];
    [_router startSessionWithCompletionHandler:^(BOOL success, NSError *error) {
        
        if (!success)
        {
            DDLogError(@"Failed to start router: %@", @"test");
        }
        
    }];
}

//=========================================================================
@end
//=========================================================================
