//
//  RCJsonRpcClient.m
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCJsonRpcClient.h"
#import "AFSecurityPolicy.h"

//=========================================================================
@implementation RCJsonRpcClient
//=========================================================================

- (instancetype)initWithEndpointURL:(NSURL *)url
{
    self = [super initWithEndpointURL:url];
    if (self)
    {
        //I2P Router has self-signed certificate but AFNetworking's certificate evaluation mechanism does not allow this per default.
        //TODO: Disable invalid certificates per default, but let user decide whether he wants to trust such certificates if one is found (like the all browser do).
        self.securityPolicy.allowInvalidCertificates = YES;

        //Don't wait too long for a response. We better retry.
        self.requestSerializer.timeoutInterval = 5;
        
        NSSet *acceptableContentTypes = self.responseSerializer.acceptableContentTypes;
        if (![acceptableContentTypes containsObject:@"application/json"])
        {
            //Current version of framework does not accept this mime, so manually add it here
            NSMutableSet *newTypes = [acceptableContentTypes mutableCopy];
            [newTypes addObject:@"application/json"];
            
            [self.responseSerializer setAcceptableContentTypes:newTypes];
        }
    }
    return self;
}

//=========================================================================
@end
//=========================================================================
