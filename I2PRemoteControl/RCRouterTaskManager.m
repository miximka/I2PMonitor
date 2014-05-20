//
//  RCRouterTaskManager.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterTaskManager.h"
#import "RCTask.h"
#import "RCTaskPrivate.h"

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

- (RCTask *)taskWithIdentifier:(NSString *)identifier
{
    for (RCTask *each in self.allTasks)
    {
        if ([each.identifier isEqualToString:identifier])
            return each;
    }
    
    return nil;
}

//=========================================================================

- (void)addTask:(RCTask *)task
{
    NSAssert([self.tasks containsObject:task] == NO, @"Task already added");
    
    [task setRouterProxy:self.routerProxy];
    [task setParentManager:self];
    
    [self.allTasks addObject:task];
    [self startTasks];
}

//=========================================================================

- (void)removeTask:(RCTask *)task
{
    DDLogDebug(@"Remove task from pool: %@", task.identifier);
    
    [task setParentManager:nil];
    [self.allTasks removeObject:task];
}

//=========================================================================

- (void)removeTaskWithIdentifier:(NSString *)identifier
{
    RCTask *task = [self taskWithIdentifier:identifier];
    [self removeTask:task];
}

//=========================================================================

- (void)removeAllTasks
{
    NSArray *tasks = [self.allTasks copy];
    for (RCTask *task in tasks)
    {
        [self removeTask:task];
    }
}

//=========================================================================

- (void)startTasks:(NSArray *)tasks
{
    for (RCTask *each in tasks)
    {
        [each start];
    }
}

//=========================================================================

- (void)startTasks
{
    NSMutableArray *tasksToStart = [NSMutableArray new];
    
    //Find out tasks to execute
    for (RCTask *each in self.tasks)
    {
        BOOL isDue = each.lastStartDate == nil || [[NSDate date] timeIntervalSinceDate:each.lastStartDate] >= each.frequency;
        BOOL isOneShotTask = each.isRecurring == NO;
        BOOL shouldStart = [each isExecuting] == NO && (isOneShotTask || isDue);
        
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

- (void)taskDidFinishExecution:(RCTask *)task withError:(NSError *)error
{
    if (!task.isRecurring)
    {
        //Remove task automatically
        [self removeTask:task];
    }
    
    if (error != nil)
    {
        [self.delegate routerTaskManager:self taskDidFail:task withError:error];
    }
}

//=========================================================================
@end
//=========================================================================
