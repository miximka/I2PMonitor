//
//  RCRouterProxy.m
//  I2PMonitor
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterProxy.h"
#import "RCJsonRpcClient.h"

//=========================================================================

@interface RCRouterProxy ()
@property (nonatomic) AFJSONRPCClient *client;
@property (nonatomic) NSString *authToken;
@end

//=========================================================================
@implementation RCRouterProxy
//=========================================================================

- (instancetype)initWithRouterURL:(NSURL *)routerURL authToken:(NSString *)authToken
{
    self = [super init];
    if (self)
    {
        RCJsonRpcClient *client = [[RCJsonRpcClient alloc] initWithEndpointURL:routerURL];
        _client = client;
        _authToken = authToken;
    }
    return self;
}

//=========================================================================

- (NSURL *)routerURL
{
    return self.client.endpointURL;
}

//=========================================================================

- (void)authenticate:(long)clientAPI password:(NSString *)password success:(void(^)(long serverAPI, NSString *token))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{PARAM_KEY_API : [NSNumber numberWithLong:clientAPI],
                             PARAM_KEY_PASSWORD : password};
    
    __weak RCRouterProxy *blockSelf = self;
    [self.client invokeMethod:METHOD_AUTHENTICATE
               withParameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSDictionary *responseDict = (NSDictionary *)responseObject;
                          long serverAPI = [[responseDict objectForKey:PARAM_KEY_API] longValue];
                          NSString *token = [responseDict objectForKey:PARAM_KEY_TOKEN];
                          
                          blockSelf.authToken = token;
                          success(serverAPI, token);
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                          failure(error);

                      }];
}

//=========================================================================

- (void)echoWithString:(NSString *)string success:(void(^)(NSString *result))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{PARAM_KEY_TOKEN : self.authToken,
                             PARAM_KEY_ECHO : string};
    
    [self.client invokeMethod:METHOD_ECHO
               withParameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSDictionary *responseDict = (NSDictionary *)responseObject;
                          NSString *result = [responseDict objectForKey:PARAM_KEY_ECHO_RESULT];
                          
                          success(result);
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          failure(error);
                          
                      }];
}

//=========================================================================

- (void)routerInfoWithOptions:(CRRouterInfoOptions)options success:(void(^)(NSDictionary *routerInfoDict))success failure:(void(^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.authToken forKey:PARAM_KEY_TOKEN];
    
    //Fill the optional parameters
    if (options & kRouterInfoStatus)
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_STATUS];

    if (options & kRouterInfoUptime)
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_UPTIME];

    if (options & kRouterInfoVersion)
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_VERSION];

    if (options & kRouterNetworkBW15s)
    {
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_NET_BW_INBOUND_15S];
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_NET_BW_OUTBOUND_15S];
    }

    if (options & kRouterNetworkStatus)
    {
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_NET_STATUS];
    }

    if (options & kRouterNetDBActivePeers)
    {
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_NETDB_ACTIVE_PEERS];
    }
    
    if (options & kRouterNetDBFastPeers)
    {
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_NETDB_FAST_PEERS];
    }
    
    if (options & kRouterNetDBHighCapacityPeers)
    {
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_NETDB_HIGH_CAPACITY_PEERS];
    }
    
    if (options & kRouterNetDBKnownPeers)
    {
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_NETDB_KNOWN_PEERS];
    }

    if (options & kRouterNetTunnelsParticipating)
    {
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_NET_TUNNELS_PARTICIPATING];
    }

    [self.client invokeMethod:METHOD_ROUTER_INFO
               withParameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          assert([responseObject isKindOfClass:[NSDictionary class]]);
                          success(responseObject);
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          failure(error);
                          
                      }];
}

//=========================================================================

- (void)routerManagerWithAction:(RCRouterManagerAction)action success:(void(^)(NSDictionary *routerInfoDict))success failure:(void(^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.authToken forKey:PARAM_KEY_TOKEN];
    NSString *actionKey = nil;
    
    switch (action)
    {
        case kRouterManagerRestartGraceful:
            actionKey = PARAM_KEY_RESTART_GRACEFUL;
            break;

        case kRouterManagerRestart:
            actionKey = PARAM_KEY_RESTART;
            break;

        case kRouterManagerShutdownGraceful:
            actionKey = PARAM_KEY_SHUTDOWN_GRACEFUL;
            break;

        case kRouterManagerShutdown:
            actionKey = PARAM_KEY_SHUTDOWN;
            break;

        default:
            break;
    }
    
    if (actionKey != nil)
    {
        [params setObject:@"" forKey:actionKey];
    }
    
    [self.client invokeMethod:METHOD_ROUTER_MANAGER
               withParameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          assert([responseObject isKindOfClass:[NSDictionary class]]);
                          success(responseObject);
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          failure(error);
                          
                      }];

}

//=========================================================================
@end
//=========================================================================
