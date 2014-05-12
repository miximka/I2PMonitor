//
//  RCRouter.m
//  I2PRemoteControl
//
//  Created by Maksim Bauer on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouter.h"
#import "RCRouterProxy.h"

//=========================================================================

@interface RCRouter ()
@property (nonatomic) RCRouterProxy *proxy;
@end

//=========================================================================
@implementation RCRouter
//=========================================================================

- (instancetype)initWithSessionConfig:(RCSessionConfig *)sessionConfig
{
    self = [super init];
    if (self)
    {
        _sessionStatus = kIdle;
        _sessionConfig = sessionConfig;
    }
    return self;
}

//=========================================================================

- (void)startSessionWithCompletionHandler:(void(^)(BOOL success, NSError *error))completionHandler
{
    if (self.sessionStatus != kIdle)
        return;
}

//=========================================================================

- (void)stopSession
{
}

//=========================================================================
@end
//=========================================================================
