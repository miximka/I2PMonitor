//
//  RCRouterConnectionSettings.h
//  I2PMonitor
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================
@interface RCRouterConnectionSettings : NSObject
//=========================================================================

- (instancetype)initWithDictionary:(NSDictionary *)settings;

@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *host;
@property (nonatomic) NSUInteger port;
@property (nonatomic) NSString *authToken;

- (NSDictionary *)dictionaryRepresentation;

/**
    Console (i.e. WebUI) port 7657
    Hardcoded at the moment, as I2PControl plugin does not provide this information
 */
@property (nonatomic, readonly) NSUInteger consolePort;

//=========================================================================
@end
//=========================================================================
