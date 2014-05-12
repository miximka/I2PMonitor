//
//  RCSessionConfig.h
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================
@interface RCSessionConfig : NSObject
//=========================================================================

@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) NSUInteger port;

/**
    Returns configuration with "localhost" host and port 7650
 */
+ (instancetype)defaultConfig;

//=========================================================================
@end
//=========================================================================
