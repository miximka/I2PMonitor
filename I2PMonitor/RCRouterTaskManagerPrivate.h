//
//  RCRouterTaskManagerPrivate.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterTaskManager.h"

@class RCTask;

//=========================================================================
@interface RCRouterTaskManager (Private)
//=========================================================================

- (void)taskDidFinishExecution:(RCTask *)task withError:(NSError *)error;

//=========================================================================
@end
//=========================================================================
