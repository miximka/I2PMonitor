//
//  RCRouterProxy.m
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterProxy.h"
#import "RCJsonRpcClient.h"
#import "RCRouterInfo.h"

//=========================================================================

#define METHOD_AUTHENTICATE     @"Authenticate"
#define PARAM_KEY_API           @"API"
#define PARAM_KEY_PASSWORD      @"Password"
#define PARAM_KEY_TOKEN         @"Token"

#define METHOD_ECHO             @"Echo"
#define PARAM_KEY_ECHO          @"Echo"
#define PARAM_KEY_ECHO_RESULT   @"Result"

#define METHOD_ROUTER_INFO          @"RouterInfo"
#define PARAM_KEY_ROUTER_STATUS     @"i2p.router.status"
#define PARAM_KEY_ROUTER_UPTIME     @"i2p.router.uptime"
#define PARAM_KEY_ROUTER_VERSION    @"i2p.router.version"

@interface RCRouterProxy ()
@property (nonatomic) AFJSONRPCClient *client;
@property (nonatomic) NSString *token;
@end

//=========================================================================
@implementation RCRouterProxy
//=========================================================================

- (instancetype)initWithRouterURL:(NSURL *)routerURL
{
    self = [super init];
    if (self)
    {
        RCJsonRpcClient *client = [[RCJsonRpcClient alloc] initWithEndpointURL:routerURL];
        _client = client;
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
                          
                          blockSelf.token = token;
                          success(serverAPI, token);
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                          failure(error);

                      }];
}

//=========================================================================

- (void)echoWithString:(NSString *)string success:(void(^)(NSString *result))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{PARAM_KEY_TOKEN : self.token,
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

- (RCRouterInfo *)routerInfoWithResponseObject:(id)responseObject
{
    assert([responseObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *responseDict = responseObject;
    
    RCRouterInfo *info = [RCRouterInfo new];

    info.routerStatus = [responseDict objectForKey:PARAM_KEY_ROUTER_STATUS];
    info.routerUptime = [[responseDict objectForKey:PARAM_KEY_ROUTER_UPTIME] longValue];
    info.routerVersion = [responseDict objectForKey:PARAM_KEY_ROUTER_VERSION];
    
    return info;
}

//=========================================================================

- (void)routerInfoWithOptions:(CRRouterInfoOptions)options success:(void(^)(RCRouterInfo *routerInfo))success failure:(void(^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.token forKey:PARAM_KEY_TOKEN];
    
    //Fill the optional parameters
    if (options & kRouterInfoStatus)
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_STATUS];

    if (options & kRouterInfoUptime)
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_UPTIME];

    if (options & kRouterInfoVersion)
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_VERSION];

    __weak RCRouterProxy *blockSelf = self;
    [self.client invokeMethod:METHOD_ROUTER_INFO
               withParameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          RCRouterInfo *info = [blockSelf routerInfoWithResponseObject:responseObject];
                          success(info);
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          failure(error);
                          
                      }];
}

//=========================================================================
@end
//=========================================================================
