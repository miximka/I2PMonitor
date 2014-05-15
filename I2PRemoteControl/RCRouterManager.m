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
@implementation RCRouterManager
//=========================================================================

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        RCRouter *router = [self loadRouter];
        [router start];
    }
    return self;
}

//=========================================================================

- (RCRouter *)loadRouter
{
    RCSessionConfig *config = [[RCSessionConfig alloc] initWithHost:[RCPrefs routerHost]
                                                               port:[RCPrefs routerPort]];
    
    RCRouter *router = [[RCRouter alloc] initWithSessionConfig:config];
    return router;
}

//=========================================================================

- (void)saveRouter:(RCRouter *)router
{
}

//=========================================================================
@end
//=========================================================================
