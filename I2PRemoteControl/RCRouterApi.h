//
//  RCRouterApiVersion1.h
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================
@protocol RCRouterApi <NSObject>
//=========================================================================

/**
    Authenticate – Creates and returns an authentication token used for further communication.
    @param API - [long] The version of the I2PControl API used by the client.
    @param password – [String] The password used for authenticating against the remote server.
 */
- (void)authenticate:(long)clientAPI password:(NSString *)password success:(void(^)(long serverAPI, NSString *token))success failure:(void(^)(NSError *error))failure;

- (void)echoWithString:(NSString *)string success:(void(^)(NSString *result))success failure:(void(^)(NSError *error))failure;

//=========================================================================
@end
//=========================================================================
