//
//  RCRouterInfo.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterInfoTask.h"
#import "RCRouterInfo.h"

//=========================================================================
@implementation RCRouterInfoTask
//=========================================================================

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super initWithIdentifier:identifier];
    if (self)
    {
        _routerInfo = [RCRouterInfo new];
        self.recurring = NO;
    }
    return self;
}

//=========================================================================

- (void)execute
{
    DDLogDebug(@"Send router info request");
    
    CRRouterInfoOptions options = kRouterInfoStatus | kRouterInfoUptime | kRouterInfoVersion;
    
    __weak RCRouterInfoTask *blockSelf = self;
    [self.routerProxy routerInfoWithOptions:options
                                    success:^(NSDictionary *routerInfoDict) {
                                        
                                        DDLogDebug(@"Received router info response: %@", routerInfoDict);
                                        [blockSelf.routerInfo updateWithResponseDictionary:routerInfoDict];
                                        
                                        [blockSelf didFinishExecutionWithError:nil];
                                        
                                    } failure:^(NSError *error) {
                                        
                                        [blockSelf didFinishExecutionWithError:error];
                                        
                                    }];
}

//=========================================================================
@end
//=========================================================================
