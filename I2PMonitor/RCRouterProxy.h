//
//  RCRouterProxy.h
//  I2PMonitor
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCRouterApi.h"

//=========================================================================
@interface RCRouterProxy : NSObject <RCRouterApi>
//=========================================================================

- (instancetype)initWithRouterURL:(NSURL *)routerURL authToken:(NSString *)authToken;

@property (nonatomic, readonly) NSURL *routerURL;
@property (nonatomic, readonly) NSString *authToken;

//=========================================================================
@end
//=========================================================================
