//
//  RCRouterTaskManagerPrivate.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterTaskManager.h"

@class RCPeriodicTask;

//=========================================================================
@interface RCRouterTaskManager (Private)
//=========================================================================

- (void)taskDidFinishExecution:(RCPeriodicTask *)task;

//=========================================================================
@end
//=========================================================================
