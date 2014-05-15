//
//  RCRouter.m
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouter.h"
#import "RCRouterProxy.h"
#import "RCSessionConfig.h"
#import "RCRouterEchoTask.h"
#import "RCRouterInfoTask.h"
#import "TKStateMachine.h"
#import "TKState.h"
#import "TKEvent.h"

//=========================================================================

#define RETRY_AUTH_DELAY 2 //Sec

#define CLIENT_API_VERSION 1
#define DEFAULT_PASSWORD @"itoopie"

#define STATE_ACTIVE            @"Active"

//State Machine Events
#define EVENT_START             @"EventStart"
#define EVENT_AUTH_FAILED       @"EventAuthFailed"
#define EVENT_AUTH_SUCCEDED     @"EventAuthSucceeded"
#define EVENT_RETRY_AUTH        @"EventRetryAuth"
#define EVENT_ERROR             @"EventError"

NSString * const RCRouterDidUpdateRouterInfoNotification = @"RCRouterDidUpdateRouterInfoNotification";

typedef NS_ENUM(NSUInteger, RCPeriodicTaskType)
{
    kUpdateRouterInfoType,
};

//=========================================================================

@interface RCRouter ()
@property (nonatomic) RCRouterProxy *proxy;
@property (nonatomic) RCRouterTaskManager *taskManager;
@property (nonatomic) RCRouterInfoTask *routerInfoTask;
@property (nonatomic) TKStateMachine *stateMachine;
@property (nonatomic) NSTimer *authRetryTimer;
@end

//=========================================================================
@implementation RCRouter
//=========================================================================

- (instancetype)initWithSessionConfig:(RCSessionConfig *)sessionConfig
{
    self = [super init];
    if (self)
    {
        _sessionConfig = sessionConfig;
    }
    return self;
}

//=========================================================================

- (void)prepareStateMachine:(TKStateMachine *)stateMachine
{
    //**********************
    //Initialize States
    
    TKState *idleState = [TKState stateWithName:@"Idle"];
    TKState *authenticatingState = [TKState stateWithName:@"Authenticating"];
    [authenticatingState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self startAuthentication];
        
    }];

    TKState *waitingAuthRetryState = [TKState stateWithName:@"WaitingAuthRetry"];
    [waitingAuthRetryState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self waitForAuthRetry];
        
    }];
    [waitingAuthRetryState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {

        //Invalidate timer, if not yet
        RCInvalidateTimer(self.authRetryTimer);
        
    }];

    TKState *activeState = [TKState stateWithName:STATE_ACTIVE];
    [activeState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self startActivity];
        
    }];
    [activeState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self stopActivity];
        
    }];

    [stateMachine addStates:@[idleState,
                              authenticatingState,
                              waitingAuthRetryState,
                              activeState]];
    
    //**********************
    //Initialize Events
    
    TKEvent *startEvent = [TKEvent eventWithName:EVENT_START transitioningFromStates:@[idleState] toState:authenticatingState];
    TKEvent *authErrorEvent = [TKEvent eventWithName:EVENT_AUTH_FAILED transitioningFromStates:@[authenticatingState] toState:waitingAuthRetryState];
    TKEvent *authSucceessEvent = [TKEvent eventWithName:EVENT_AUTH_SUCCEDED transitioningFromStates:@[authenticatingState] toState:activeState];
    TKEvent *retryAuthEvent = [TKEvent eventWithName:EVENT_RETRY_AUTH transitioningFromStates:@[waitingAuthRetryState] toState:authenticatingState];
    TKEvent *errorEvent = [TKEvent eventWithName:EVENT_ERROR transitioningFromStates:@[activeState] toState:waitingAuthRetryState];
    
    [stateMachine addEvents:@[startEvent,
                              authErrorEvent,
                              authSucceessEvent,
                              retryAuthEvent,
                              errorEvent]];
    
    //Idle state is the initial state
    [stateMachine setInitialState:[stateMachine stateNamed:@"Idle"]];
}

//=========================================================================

- (void)initializeStateMachine
{
    TKStateMachine *stateMachine = [[TKStateMachine alloc] init];
    
    [self prepareStateMachine:stateMachine];
    
    //Activate state machine
    [stateMachine activate];
    
    _stateMachine = stateMachine;
}

//=========================================================================

- (BOOL)fireEvent:(NSString *)event
{
    BOOL success = [self.stateMachine fireEvent:event userInfo:nil error:nil];

    if (!success)
    {
        DDLogWarn(@"Event has been ignored: %@. Current state: %@", event, self.stateMachine.currentState);
    }
    
    return success;
}

//=========================================================================

- (BOOL)eventStart
{
    DDLogInfo(@"Connect to router...");
    BOOL success = [self fireEvent:EVENT_START];

    return success;
}

//=========================================================================

- (BOOL)eventAuthenticationFailedWithError:(NSError *)error
{
    DDLogError(@"Authentication failed with error: %@", error);
    
    BOOL success = [self fireEvent:EVENT_AUTH_FAILED];
    return success;
}

//=========================================================================

- (BOOL)eventAuthenticationSucceeded
{
    DDLogInfo(@"Authentication succeeded");

    BOOL success = [self fireEvent:EVENT_AUTH_SUCCEDED];
    return success;
}

//=========================================================================

- (BOOL)eventRetryAuthentication
{
    DDLogInfo(@"Retry authentication...");
    
    BOOL success = [self fireEvent:EVENT_RETRY_AUTH];
    return success;
}

//=========================================================================

- (BOOL)eventError:(NSError *)error
{
    DDLogInfo(@"Error occurred: %@", error);
    
    BOOL success = [self fireEvent:EVENT_ERROR];
    return success;
}

//=========================================================================

- (void)didFinishAuthenticationWithServerApi:(long)serverAPI sessionToken:(NSString *)token error:(NSError *)error
{
    if (error)
    {
        //Authentication failed
        [self eventAuthenticationFailedWithError:error];
        return;
    }
    
    //Authentication succeeded
    [self eventAuthenticationSucceeded];
}

//=========================================================================

- (void)startAuthentication
{
    NSString *urlStr = [NSString stringWithFormat:@"https://%@:%lu", self.sessionConfig.host, self.sessionConfig.port];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    DDLogInfo(@"Starting authentication with URL: %@", urlStr);
    
    //Create proxy object
    self.proxy = [[RCRouterProxy alloc] initWithRouterURL:url];
    
    __weak id blockSelf = self;
    [self.proxy authenticate:CLIENT_API_VERSION
                    password:DEFAULT_PASSWORD
                     success:^(long serverAPI, NSString *token) {
                         
                         [blockSelf didFinishAuthenticationWithServerApi:serverAPI sessionToken:token error:nil];
                         
                     } failure:^(NSError *error) {
                         
                         [blockSelf didFinishAuthenticationWithServerApi:0 sessionToken:nil error:error];
                         
                     }];
}

//=========================================================================

- (void)waitForAuthRetry
{
    self.authRetryTimer = [NSTimer timerWithTimeInterval:RETRY_AUTH_DELAY
                                                  target:self
                                                selector:@selector(authRetryTimerFired:)
                                                userInfo:nil
                                                 repeats:NO];
    
    //Add timer manually with NSRunLoopCommonModes to update UI even when menu is opened
    [[NSRunLoop currentRunLoop] addTimer:self.authRetryTimer
                                 forMode:NSRunLoopCommonModes];
}

//=========================================================================

- (void)startActivity
{
    DDLogInfo(@"Start polling router");
    
    //Create task manager
    RCRouterTaskManager *taskManager = [[RCRouterTaskManager alloc] initWithRouterProxy:self.proxy];
    [taskManager setDelegate:self];
    self.taskManager = taskManager;
    
    //Schedule router info update
    RCRouterInfoTask *infoTask = [[RCRouterInfoTask alloc] initWithIdentifier:@"RouterInfo"];

    __weak RCRouter *blockSelf = self;
    [infoTask setCompletionHandler:^(RCRouterInfo *routerInfo, NSError *error){

        if (!error)
        {
            [blockSelf notifyDidUpdateRouterInfo];
        }

    }];
    self.routerInfoTask = infoTask;

    [self updateRouterInfo];

    //Schedule periodic tasks
    [self addPeriodicTasks];
}

//=========================================================================

- (void)stopActivity
{
    DDLogInfo(@"Stop polling router");
    
    //Remove remaining tasks from manager
    [self.taskManager removeAllTasks];
    self.taskManager = nil;

    //Invalidate router info
    self.routerInfoTask = nil;

    //Send notification to let UI know the router info has been changed
    [self notifyDidUpdateRouterInfo];
}

//=========================================================================

- (RCRouterInfo *)routerInfo
{
    return self.routerInfoTask.routerInfo;
}

//=========================================================================

- (BOOL)isActive
{
    return [self.stateMachine isInState:STATE_ACTIVE];
}

//=========================================================================

- (void)start
{
    if (self.stateMachine == nil)
    {
        [self initializeStateMachine];
    }
    
    //Trigger start event
    [self eventStart];
}

//=========================================================================

- (void)terminate
{
    //Release state machine when finished (to prevent retain cycle)
    self.stateMachine = nil;

    //Stop all tasks
    [self stopActivity];
}

//=========================================================================

- (void)notifyDidUpdateRouterInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RCRouterDidUpdateRouterInfoNotification object:self];
}

//=========================================================================

- (void)updateRouterInfo
{
    [self.taskManager addTask:self.routerInfoTask];
}

//=========================================================================

- (void)addPeriodicTasks
{
    RCRouterEchoTask *echoTask = [[RCRouterEchoTask alloc] initWithIdentifier:@"Echo"];
    echoTask.frequency = 1;
    [self.taskManager addTask:echoTask];
}

//=========================================================================
#pragma mark Timer Callback
//=========================================================================

- (void)authRetryTimerFired:(NSTimer *)timer
{
    [self eventRetryAuthentication];
}

//=========================================================================
#pragma mark RCRouterTaskManagerDelegate
//=========================================================================

- (void)routerTaskManager:(RCRouterTaskManager *)manager taskDidFail:(RCTask *)task withError:(NSError *)error
{
    [self eventError:error];
}

//=========================================================================
@end
//=========================================================================
