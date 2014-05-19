//
//  RCRouterInfo.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================
@interface RCRouterInfo : NSObject
//=========================================================================

- (instancetype)initWithResponseDictionary:(NSDictionary *)response;

- (void)updateWithResponseDictionary:(NSDictionary *)response;

@property (nonatomic) NSString *routerStatus;

/**
    Last known value from router
 */
@property (nonatomic) long routerUptime;

/**
    Calculated from -routerUptime and current date
 */
- (NSTimeInterval)estimatedRouterUptime;

@property (nonatomic) NSString *routerVersion;

//=========================================================================
@end
//=========================================================================
