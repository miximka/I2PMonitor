//
//  RCRouterInfo.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterInfoTask.h"

//=========================================================================
@implementation RCRouterInfoTask
//=========================================================================

- (void)execute
{
    DDLogDebug(@"Send router info request");
    
    CRRouterInfoOptions options = kRouterInfoStatus | kRouterInfoUptime | kRouterInfoVersion;
    
    __weak id blockSelf = self;
    [self.routerProxy routerInfoWithOptions:options
                                    success:^(RCRouterInfo *routerInfo) {
                                        
                                        DDLogDebug(@"Received router info response: %@", routerInfo);
                                        [blockSelf didFinishExecutionWithError:nil];
                                        
                                    } failure:^(NSError *error) {
                                        
                                        [blockSelf didFinishExecutionWithError:error];
                                        
                                    }];
}

//=========================================================================
@end
//=========================================================================
