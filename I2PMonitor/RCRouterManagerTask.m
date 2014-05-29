//
//  RCRouterManagerTask.m
//  I2PMonitor
//
//  Created by miximka on 27/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterManagerTask.h"

//=========================================================================
@implementation RCRouterManagerTask
//=========================================================================

- (instancetype)initWithIdentifier:(NSString *)identifier action:(RCRouterManagerAction)action
{
    self = [super initWithIdentifier:identifier];
    if (self)
    {
        _action = action;
    }
    return self;
}

//=========================================================================

- (void)execute
{
    DDLogDebug(@"Send router manager request");
    
    __weak RCRouterManagerTask *blockSelf = self;
    [self.routerProxy routerManagerWithAction:self.action
                                      success:^(NSDictionary *routerInfoDict) {
                                          
                                          DDLogDebug(@"Received router info response: %@", routerInfoDict);
                                          [blockSelf didFinishExecutionWithError:nil];
                                          
                                      } failure:^(NSError *error) {
                                          
                                          [blockSelf didFinishExecutionWithError:error];
                                          
                                      }];
}

//=========================================================================
@end
//=========================================================================
