//
//  RCPeriodicTask.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCRouterProxy.h"

//=========================================================================
@interface RCPeriodicTask : NSObject
//=========================================================================

- (instancetype)initWithIdentifier:(NSString *)identifier;

/**
    Task identifier
 */
@property (nonatomic) NSString *identifier;

/**
    How often the task should be executed.
 */
@property (nonatomic) NSTimeInterval frequency;

//Timestamp of the last execution
@property (nonatomic, readonly) NSDate *lastStartDate;

//Router proxy object to use for execution
@property (nonatomic, readonly) RCRouterProxy *routerProxy;

//Returns execution status
@property (nonatomic, readonly) BOOL isExecuting;

/**
    Starts task
 */
- (void)execute;

@property (nonatomic, readonly) NSError *lastError;

/**
    Subclasses should call this method when finished.
 */
- (void)didFinishExecutionWithError:(NSError *)error;

//=========================================================================
@end
//=========================================================================