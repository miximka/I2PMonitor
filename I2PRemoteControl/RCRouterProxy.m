//
//  RCRouterProxy.m
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterProxy.h"
#import "RCJsonRpcClient.h"

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

- (void)authenticate:(long)clientAPI password:(NSString *)password completionHandler:(void(^)(long serverAPI, NSString *token, NSError *error))completionHandler
{
    NSDictionary *params = @{@"API" : [NSNumber numberWithLong:clientAPI],
                             @"Password" : password};
    
    [self.client invokeMethod:@"Authenticate"
               withParameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          DDLogInfo(@"Success");
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                          DDLogError(@"Error: %@", error);

                      }];
}

//=========================================================================
@end
//=========================================================================
