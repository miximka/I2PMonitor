//
//  RCRouterApiVersion1.h
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================

#define METHOD_AUTHENTICATE     @"Authenticate"
#define PARAM_KEY_API           @"API"
#define PARAM_KEY_PASSWORD      @"Password"
#define PARAM_KEY_TOKEN         @"Token"

#define METHOD_ECHO             @"Echo"
#define PARAM_KEY_ECHO          @"Echo"
#define PARAM_KEY_ECHO_RESULT   @"Result"

#define METHOD_ROUTER_INFO                      @"RouterInfo"
#define PARAM_KEY_ROUTER_STATUS                 @"i2p.router.status"
#define PARAM_KEY_ROUTER_UPTIME                 @"i2p.router.uptime"
#define PARAM_KEY_ROUTER_VERSION                @"i2p.router.version"
#define PARAM_KEY_ROUTER_NET_BW_INBOUND_15S     @"i2p.router.net.bw.inbound.15s"
#define PARAM_KEY_ROUTER_NET_BW_OUTBOUND_15S    @"i2p.router.net.bw.outbound.15s"
#define PARAM_KEY_ROUTER_NET_STATUS             @"i2p.router.net.status"

@class RCRouterInfo;

typedef NS_OPTIONS(NSUInteger, CRRouterInfoOptions)
{
    kRouterInfoStatus       = 1 << 0,
    kRouterInfoUptime       = 1 << 1,
    kRouterInfoVersion      = 1 << 2,
    kRouterNetworkBW15s     = 1 << 3, //Inbound & Outbound
    kRouterNetworkStatus    = 1 << 4,
};

//=========================================================================
@protocol RCRouterApi <NSObject>
//=========================================================================

/**
    Authenticate – Creates and returns an authentication token used for further communication.
    @param API - [long] The version of the I2PControl API used by the client.
    @param password – [String] The password used for authenticating against the remote server.
 */
- (void)authenticate:(long)clientAPI password:(NSString *)password success:(void(^)(long serverAPI, NSString *token))success failure:(void(^)(NSError *error))failure;

/**
    Echo – Echoes the value of the echo key, used for debugging and testing.
    @param string Echo – [String] Value will be returned in response.
 */
- (void)echoWithString:(NSString *)string success:(void(^)(NSString *result))success failure:(void(^)(NSError *error))failure;

/**
    RouterInfo – Fetches basic information about the I2P router. Uptime, version etc.
 */
- (void)routerInfoWithOptions:(CRRouterInfoOptions)options success:(void(^)(NSDictionary *routerInfoDict))success failure:(void(^)(NSError *error))failure;

//=========================================================================
@end
//=========================================================================
