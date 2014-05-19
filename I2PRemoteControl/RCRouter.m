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
#import "RCRouterInfo.h"
#import "RCBWMeasurement.h"
#import "RCBWMeasurementBuffer.h"

//=========================================================================

#define RETRY_AUTH_DELAY                    2 //sec
#define RETRY_COUNT_INVALIDATE_ROUTER_INFO  3 //times
#define MEASUREMENTS_BUFFER_CAPACITY        500 //500 values * 3 sec bw task frequency / 60 sec = ~25 min

#define CLIENT_API_VERSION      1
#define DEFAULT_PASSWORD        @"itoopie"

#define STATE_ACTIVE            @"Active"
#define STATE_AUTHENTICATING    @"Authenticating"

//State Machine Events
#define EVENT_START             @"EventStart"
#define EVENT_AUTH_FAILED       @"EventAuthFailed"
#define EVENT_AUTH_SUCCEDED     @"EventAuthSucceeded"
#define EVENT_RETRY_AUTH        @"EventRetryAuth"
#define EVENT_CONNECTION_ERROR  @"EventConnectionError"

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
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL authenticating;
@property (nonatomic) NSUInteger authRetryCounter;
@property (nonatomic) RCRouterInfo *routerInfo;
@property (nonatomic) RCBWMeasurementBuffer *measurementsBuffer;
@end

//=========================================================================
@implementation RCRouter
//=========================================================================

- (instancetype)initWithSessionConfig:(RCSessionConfig *)sessionConfig
{
    self = [super init];
    if (self)
    {
        _measurementsBuffer = [[RCBWMeasurementBuffer alloc] initWithCapacity:MEASUREMENTS_BUFFER_CAPACITY];
        _sessionConfig = sessionConfig;
        _authRetryCounter = 0;
    }
    return self;
}

//=========================================================================

- (void)prepareStateMachine:(TKStateMachine *)stateMachine
{
    //**********************
    //Initialize States
    
    TKState *idleState = [TKState stateWithName:@"Idle"];
    TKState *authenticatingState = [TKState stateWithName:STATE_AUTHENTICATING];
    [authenticatingState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self setAuthenticating:YES];
        [self startAuthentication];
        
    }];
    [authenticatingState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self setAuthenticating:NO];
        
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
        
        [self setActive:YES];
        [self startActivity];
        
    }];
    [activeState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self setActive:NO];
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
    TKEvent *connectionErrorEvent = [TKEvent eventWithName:EVENT_CONNECTION_ERROR transitioningFromStates:@[activeState] toState:waitingAuthRetryState];
    
    [stateMachine addEvents:@[startEvent,
                              authErrorEvent,
                              authSucceessEvent,
                              retryAuthEvent,
                              connectionErrorEvent]];
    
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
    
    BOOL success = [self fireEvent:EVENT_AUTH_FAILED];    return success;
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

- (BOOL)eventConnectionError:(NSError *)error
{
    DDLogInfo(@"Connection error occurred: %@", error);
    
    BOOL success = [self fireEvent:EVENT_CONNECTION_ERROR];
    return success;
}

//=========================================================================

- (void)didFinishAuthenticationWithServerApi:(long)serverAPI sessionToken:(NSString *)token error:(NSError *)error
{
    if (error)
    {
        //Authentication failed
        if (self.authRetryCounter < RETRY_COUNT_INVALIDATE_ROUTER_INFO)
        {
            //Increase retry counter
            self.authRetryCounter++;
        }
        else
        {
            //We are trying too long, invalidate current router info
            [self invalidateRouterInfo];
        }
        
        [self eventAuthenticationFailedWithError:error];
        return;
    }
    
    //Reset retry counter
    self.authRetryCounter = 0;
    
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

    //Send notification to let UI know the router info has been changed
    [self notifyDidUpdateRouterInfo];
}

//=========================================================================

- (BOOL)isAuthenticating
{
    return [self.stateMachine isInState:STATE_AUTHENTICATING];
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

- (void)didUpdateRouterInfo:(NSDictionary *)responseDict
{
    //Update local router info with one from the task
    if (self.routerInfo == nil)
    {
        self.routerInfo = [[RCRouterInfo alloc] initWithResponseDictionary:responseDict];
    }
    else
    {
        [self.routerInfo updateWithResponseDictionary:responseDict];
    }
    
    [self notifyDidUpdateRouterInfo];
}

//=========================================================================

- (void)updateRouterInfo
{
    //Only fetch status, uptime and version values
    CRRouterInfoOptions options = kRouterInfoStatus | kRouterInfoUptime | kRouterInfoVersion | kRouterNetworkStatus;
    RCRouterInfoTask *task = [[RCRouterInfoTask alloc] initWithIdentifier:@"RouterInfo" options:options];

    __weak RCRouter *blockSelf = self;
    [task setCompletionHandler:^(NSDictionary *responseDict, NSError *error){
        
        if (!error)
        {
            [blockSelf didUpdateRouterInfo:responseDict];
        }
        
    }];

    [self.taskManager addTask:task];
}

//=========================================================================

- (void)didUpdateBandwidth:(NSDictionary *)responseDict
{
    CGFloat inbound = [[responseDict objectForKey:PARAM_KEY_ROUTER_NET_BW_INBOUND_15S] floatValue];
    CGFloat outbound = [[responseDict objectForKey:PARAM_KEY_ROUTER_NET_BW_OUTBOUND_15S] floatValue];
    
    RCBWMeasurement *measurement = [RCBWMeasurement measurementWithDate:[NSDate date]
                                                                inbound:inbound
                                                               outbound:outbound];
    
    //Append new entry
    [self.measurementsBuffer addObject:measurement];
}

//=========================================================================

- (void)addBandwidthUpdateTask
{
    //Only fetch status, uptime and version values
    CRRouterInfoOptions options = kRouterNetworkBW15s;
    RCRouterInfoTask *task = [[RCRouterInfoTask alloc] initWithIdentifier:@"Bandwidth" options:options];
    task.frequency = 3;
    task.recurring = YES;

    __weak RCRouter *blockSelf = self;
    [task setCompletionHandler:^(NSDictionary *responseDict, NSError *error){
        
        if (!error)
        {
            [blockSelf didUpdateBandwidth:responseDict];
        }
        
    }];
    
    [self.taskManager addTask:task];
}

//=========================================================================

- (void)invalidateRouterInfo
{
    DDLogInfo(@"Invalidating router info");
    
    _routerInfo = nil;
    [self notifyDidUpdateRouterInfo];
}

//=========================================================================

- (void)addPeriodicTasks
{
//    RCRouterEchoTask *task = [[RCRouterEchoTask alloc] initWithIdentifier:@"Echo"];
//    task.frequency = 1;
//    [self.taskManager addTask:task];
    
    //Update bandwidth in/out
    [self addBandwidthUpdateTask];
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
    //Analyse error
    if ([error.domain isEqualToString:NSURLErrorDomain])
    {
        //Connection error event
        [self eventConnectionError:error];
    }
    else
    {
        DDLogDebug(@"Ignore error: %@", error);
    }
}

//=========================================================================
@end
//=========================================================================
