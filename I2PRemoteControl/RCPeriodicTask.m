//
//  RCPeriodicTask.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCPeriodicTask.h"
#import "RCPeriodicTaskPrivate.h"
#import "RCRouterTaskManagerPrivate.h"

//=========================================================================

@interface RCPeriodicTask ()
@property (nonatomic) RCRouterTaskManager *manager;
@property (nonatomic) NSError *lastError;
@property (nonatomic) BOOL isExecuting;
@property (nonatomic) NSDate *lastStartDate;
@end

//=========================================================================
@implementation RCPeriodicTask
//=========================================================================

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self)
    {
        _identifier = identifier;
        _frequency = 60; //Sec
    }
    return self;
}

//=========================================================================

- (instancetype)init
{
    return [self initWithIdentifier:nil];
}

//=========================================================================

- (RCRouterTaskManager *)parentManager
{
    return _manager;
}

//=========================================================================

- (void)setParentManager:(RCRouterTaskManager *)manager
{
    _manager = manager;
}

//=========================================================================

- (void)setRouterProxy:(RCRouterProxy *)routerProxy
{
    _routerProxy = routerProxy;
}

//=========================================================================

- (void)start
{
    NSAssert(self.isExecuting == NO, @"Tried to execute already executing task");
 
    DDLogDebug(@"Will start task: %@", self.identifier);
    
    self.isExecuting = YES;
    self.lastStartDate = [NSDate date];

    [self execute];
}

//=========================================================================

- (void)execute
{
}

//=========================================================================

- (void)didFinishExecutionWithError:(NSError *)error
{
    NSTimeInterval executionTime = [[NSDate date] timeIntervalSinceDate:self.lastStartDate];
    
    if (!error)
    {
        DDLogDebug(@"Did finish task %@. Execution time: %.3f", self.identifier, executionTime);
    }
    else
    {
        DDLogError(@"Task %@ failed with error: %@", self.identifier, error);
    }

    self.isExecuting = NO;
    self.lastError = error;
    
    [self.parentManager taskDidFinishExecution:self];
}

//=========================================================================
@end
//=========================================================================
