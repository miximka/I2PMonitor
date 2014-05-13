//
//  RCTaskPrivate.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCTask.h"

@class RCRouterTaskManager;

//=========================================================================
@interface RCTask (Private)
//=========================================================================

@property (nonatomic) RCRouterTaskManager *parentManager;

- (void)setRouterProxy:(RCRouterProxy *)routerProxy;
- (void)start;

//=========================================================================
@end
//=========================================================================
