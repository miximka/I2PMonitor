//
//  RCPeriodicTaskPrivate.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCPeriodicTask.h"

@class RCRouterTaskManager;

//=========================================================================
@interface RCPeriodicTask (Private)
//=========================================================================

- (RCRouterTaskManager *)parentManager;
- (void)setRouterProxy:(RCRouterProxy *)routerProxy;
- (void)start;

//=========================================================================
@end
//=========================================================================
