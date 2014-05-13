//
//  RCRouterProxy.m
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterProxy.h"
#import "RCJsonRpcClient.h"

//=========================================================================

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

- (void)routerInfoWithOptions:(CRRouterInfoOptions)options success:(void(^)(NSDictionary *routerInfoDict))success failure:(void(^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.token forKey:PARAM_KEY_TOKEN];
    
    //Fill the optional parameters
    if (options & kRouterInfoStatus)
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_STATUS];

    if (options & kRouterInfoUptime)
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_UPTIME];

    if (options & kRouterInfoVersion)
        [params setObject:@"" forKey:PARAM_KEY_ROUTER_VERSION];

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
@end
//=========================================================================
