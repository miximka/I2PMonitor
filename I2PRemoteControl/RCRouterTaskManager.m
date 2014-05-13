//
//  RCRouterTaskManager.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterTaskManager.h"
#import "RCPeriodicTask.h"
#import "RCPeriodicTaskPrivate.h"

//=========================================================================

#define POLL_TIME_INTERVAL  0.5

@interface RCRouterTaskManager ()
@property (nonatomic) NSMutableArray *allTasks;
@property (nonatomic) NSTimer *pollTimer;
@end

//=========================================================================
@implementation RCRouterTaskManager
//=========================================================================

- (instancetype)initWithRouterProxy:(RCRouterProxy *)routerProxy
{
    self = [super init];
    if (self)
    {
        _routerProxy = routerProxy;
        _allTasks = [NSMutableArray new];
        
        _pollTimer = [NSTimer scheduledTimerWithTimeInterval:POLL_TIME_INTERVAL
                                                      target:self
                                                    selector:@selector(pollTimerFired:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    return self;
}

//=========================================================================

- (void)dealloc
{
    [_pollTimer invalidate];
}

//=========================================================================

-(NSArray *)tasks
{
    return self.allTasks;
}

//=========================================================================

- (void)addTask:(RCPeriodicTask *)task
{
    [task setRouterProxy:self.routerProxy];

    [self.allTasks addObject:task];
    [self startTasks];
}

//=========================================================================

- (void)removeTask:(RCPeriodicTask *)task
{
    [self.allTasks removeObject:task];
}

//=========================================================================

- (void)startTasks:(NSArray *)tasks
{
    for (RCPeriodicTask *each in tasks)
    {
        [each start];
    }
}

//=========================================================================

- (void)startTasks
{
    NSMutableArray *tasksToStart = [NSMutableArray new];
    
    //Find out tasks to execute
    for (RCPeriodicTask *each in self.tasks)
    {
        BOOL isDue = each.lastStartDate == nil || [[NSDate date] timeIntervalSinceDate:each.lastStartDate] >= each.frequency;
        BOOL shouldStart = [each isExecuting] == NO && isDue;
        
        if (shouldStart)
        {
            [tasksToStart addObject:each];
        }
    }
    
    [self startTasks:tasksToStart];
}

//=========================================================================

- (void)pollTimerFired:(NSTimer *)timer
{
    [self startTasks];
}

//=========================================================================
#pragma RCRouterTaskManager (Private)
//=========================================================================

- (void)taskDidFinishExecution:(RCPeriodicTask *)task
{
}

//=========================================================================
@end
//=========================================================================