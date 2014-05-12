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

    DDLogInfo(@"Will start session with URL: %@", urlStr);

    //Create proxy object
    _proxy = [[RCRouterProxy alloc] initWithRouterURL:url];
    
    //Update session status
    self.sessionStatus = kAuthenticating;
    
    __weak id blockSelf = self;
    [self.proxy authenticate:CLIENT_API_VERSION
                    password:DEFAULT_PASSWORD
                     success:^(long serverAPI, NSString *token) {
                         
                         [blockSelf sessionDidStart];
                         completionHandler(YES, nil);
                         
                     } failure:^(NSError *error) {
                         
                         DDLogInfo(@"Failed to start session: %@", error);
                         completionHandler(NO, error);
                         
                     }];
}

//=========================================================================

- (void)stopSession
{
}

//=========================================================================

- (void)sessionDidStart
{
    DDLogInfo(@"Session did start");
    
    //Update session status
    self.sessionStatus = kAuthenticated;
    
    //Start polling router
    
}

//=========================================================================
@end
//=========================================================================
