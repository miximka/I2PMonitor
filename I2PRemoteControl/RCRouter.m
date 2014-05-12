//
//  RCRouter.m
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouter.h"
#import "RCRouterProxy.h"
#import "RCSessionConfig.h"

#define CLIENT_API_VERSION 1
#define DEFAULT_PASSWORD @"itoopie"

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
    
    NSString *urlStr = [NSString stringWithFormat:@"https://%@:%lu", self.sessionConfig.host, self.sessionConfig.port];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //Create proxy object
    _proxy = [[RCRouterProxy alloc] initWithRouterURL:url];
    
    [self.proxy authenticate:CLIENT_API_VERSION
                    password:DEFAULT_PASSWORD
           completionHandler:^(long serverAPI, NSString *token, NSError *error) {
               
               BOOL success = error == nil;
               completionHandler(success, error);
               
           }];
}

//=========================================================================

- (void)stopSession
{
}

//=========================================================================
@end
//=========================================================================
