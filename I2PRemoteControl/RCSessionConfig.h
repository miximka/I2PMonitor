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

- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port;

@property (nonatomic) NSString *host;
@property (nonatomic) NSUInteger port;

/**
    Console (i.e. WebUI) port 7657
    Hardcoded at the moment, as I2PControl plugin does not provide this information
 */
@property (nonatomic, readonly) NSUInteger consolePort;

//=========================================================================
@end
//=========================================================================
