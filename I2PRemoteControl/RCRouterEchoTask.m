//
//  RCRouterEchoTask.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterEchoTask.h"
#import "RCRouterProxy.h"

//=========================================================================
@implementation RCRouterEchoTask
//=========================================================================

- (void)execute
{
    NSString *echoStr = @"fnord";
    
    DDLogInfo(@"Send echo: %@", echoStr);
    
    __weak id blockSelf = self;
    [self.routerProxy echoWithString:echoStr
                             success:^(NSString *result) {
                                 
                                 DDLogInfo(@"Echo response: %@", result);
                                 [blockSelf didFinishExecutionWithError:nil];
                                 
                             } failure:^(NSError *error) {

                                 [blockSelf didFinishExecutionWithError:error];

                             }];
}

//=========================================================================
@end
//=========================================================================
