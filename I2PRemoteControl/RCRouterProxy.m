//
//  RCRouterProxy.m
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterProxy.h"
#import "AFJSONRPCClient.h"

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
        AFJSONRPCClient *client = [[AFJSONRPCClient alloc] initWithEndpointURL:routerURL];
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

- (void)authenticate:(long)clientAPI password:(NSString *)password completionHandler:(void(^)(long serverAPI, NSString *token, NSError *error))completionHandler
{
    [self.client invokeMethod:@"Authenticate"
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
                          completionHandler(0, nil, nil);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                          completionHandler(0, nil, error);

                      }];
}

//=========================================================================
@end
//=========================================================================
