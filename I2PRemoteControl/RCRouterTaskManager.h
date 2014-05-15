//
//  RCRouterTaskManager.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCTask;
@class RCRouterProxy;

//=========================================================================
@interface RCRouterTaskManager : NSObject
//=========================================================================

- (instancetype)initWithRouterProxy:(RCRouterProxy *)routerProxy;

@property (nonatomic, readonly) RCRouterProxy *routerProxy;
@property (nonatomic, readonly) NSArray *tasks;

- (void)addTask:(RCTask *)task;
- (void)removeTask:(RCTask *)task;
- (void)removeAllTasks;

//=========================================================================
@end
//=========================================================================
