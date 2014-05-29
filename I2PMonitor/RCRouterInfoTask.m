//
//  RCRouterInfo.m
//  I2PMonitor
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterInfoTask.h"


//=========================================================================
@implementation RCRouterInfoTask
//=========================================================================

- (instancetype)initWithIdentifier:(NSString *)identifier options:(CRRouterInfoOptions)options
{
    self = [super initWithIdentifier:identifier];
    if (self)
    {
        _options = options;
    }
    return self;
}

//=========================================================================

- (void)didFinishExecutionWithResponseDict:(NSDictionary *)responseDict error:(NSError *)error
{
    [super didFinishExecutionWithError:error];
    
    if (self.completionHandler != nil)
    {
        self.completionHandler(responseDict, error);
    }
}

//=========================================================================

- (void)execute
{
    DDLogDebug(@"Send router info request");
    
    __weak RCRouterInfoTask *blockSelf = self;
    [self.routerProxy routerInfoWithOptions:self.options
                                    success:^(NSDictionary *routerInfoDict) {
                                        
                                        DDLogDebug(@"Received router info response: %@", routerInfoDict);
                                        [blockSelf didFinishExecutionWithResponseDict:routerInfoDict error:nil];
                                        
                                    } failure:^(NSError *error) {
                                        
                                        [blockSelf didFinishExecutionWithResponseDict:nil error:error];
                                        
                                    }];
}

//=========================================================================
@end
//=========================================================================
