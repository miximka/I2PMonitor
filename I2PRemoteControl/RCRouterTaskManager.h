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
@class RCRouterTaskManager;

//=========================================================================

@protocol RCRouterTaskManagerDelegate <NSObject>
- (void)routerTaskManager:(RCRouterTaskManager *)manager taskDidFail:(RCTask *)task withError:(NSError *)error;
@end

//=========================================================================
@interface RCRouterTaskManager : NSObject
//=========================================================================

- (instancetype)initWithRouterProxy:(RCRouterProxy *)routerProxy;

@property (nonatomic, weak) id<RCRouterTaskManagerDelegate> delegate;

@property (nonatomic, readonly) RCRouterProxy *routerProxy;
@property (nonatomic, readonly) NSArray *tasks;

- (RCTask *)taskWithIdentifier:(NSString *)identifier;

- (void)addTask:(RCTask *)task;
- (void)removeTask:(RCTask *)task;
- (void)removeTaskWithIdentifier:(NSString *)identifier;
- (void)removeAllTasks;

//=========================================================================
@end
//=========================================================================
