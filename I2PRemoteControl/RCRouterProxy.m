//
//  RCRouterProxy.m
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterProxy.h"
#import "RCJsonRpcClient.h"

#define METHOD_AUTHENTICATE @"Authenticate"

#define PARAM_KEY_API       @"API"
#define PARAM_KEY_PASSWORD  @"Password"
#define PARAM_KEY_TOKEN     @"Token"

@interface RCRouterProxy ()
@property (nonatomic) AFJSONRPCClient *client;
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
    
    [self.client invokeMethod:METHOD_AUTHENTICATE
               withParameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSDictionary *responseDict = (NSDictionary *)responseObject;
                          long serverAPI = [[responseDict objectForKey:PARAM_KEY_API] longValue];
                          NSString *token = [responseObject objectForKey:PARAM_KEY_TOKEN];
                          
                          success(serverAPI, token);
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                          failure(error);

                      }];
}

//=========================================================================
@end
//=========================================================================
