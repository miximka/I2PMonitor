//
//  RCRouterEchoTask.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterEchoTask.h"

//=========================================================================
@implementation RCRouterEchoTask
//=========================================================================

- (void)execute
{
    NSString *echoStr = @"fnord";
    
    DDLogDebug(@"Send echo request: %@", echoStr);
    
    __weak id blockSelf = self;
    [self.routerProxy echoWithString:echoStr
                             success:^(NSString *result) {
                                 
                                 DDLogDebug(@"Received echo response: %@", result);
                                 [blockSelf didFinishExecutionWithError:nil];
                                 
                             } failure:^(NSError *error) {

                                 [blockSelf didFinishExecutionWithError:error];

                             }];
}

//=========================================================================
@end
//=========================================================================
