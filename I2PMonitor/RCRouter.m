//
//  RCRouter.m
//  I2PMonitor
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouter.h"
#import "RCRouterProxy.h"
#import "RCRouterConnectionSettings.h"
#import "RCRouterEchoTask.h"
#import "RCRouterInfoTask.h"
#import "TKStateMachine.h"
#import "TKState.h"
#import "TKEvent.h"
#import "RCRouterInfo.h"
#import "RCBWMeasurement.h"
#import "RCBWMeasurementBuffer.h"
#import "RCRouterManagerTask.h"
#import "RCRouterManager.h"

//=========================================================================

#define RETRY_AUTH_DELAY                    2 //sec
#define RETRY_COUNT_INVALIDATE_ROUTER_INFO  3 //times
#define MEASUREMENTS_BUFFER_CAPACITY        500 //500 values * 3 sec bw task frequency / 60 sec = ~25 min

#define CLIENT_API_VERSION          1
#define DEFAULT_PASSWORD            @"itoopie"

#define STATE_ACTIVE                @"Active"
#define STATE_VALIDATING_TOKEN      @"ValidatingToken"
#define STATE_AUTHENTICATING        @"Authenticating"
#define STATE_WAITING_AUTH_RETRY    @"WaitingAuthRetry"

//State Machine Events
#define EVENT_AUTHENTICATE      @"EventAuthenticate"
#define EVENT_VALIDATE_TOKEN    @"EventValidateToken"
#define EVENT_TOKEN_VALID       @"EventTokenValid"
#define EVENT_AUTH_FAILED       @"EventAuthFailed"
#define EVENT_AUTH_SUCCEDED     @"EventAuthSucceeded"
#define EVENT_RETRY_AUTH        @"EventRetryAuth"
#define EVENT_CONNECTION_ERROR  @"EventConnectionError"

NSString * const RCRouterDidUpdateRouterInfoNotification = @"RCRouterDidUpdateRouterInfoNotification";
NSString * const RCRouterDidUpdateBandwidthNotification = @"RCRouterDidUpdateBandwidthNotification";

typedef NS_ENUM(NSUInteger, RCPeriodicTaskType)
{
    kUpdateRouterInfoType,
};

static CRRouterInfoOptions routerInfoTaskOptions = kRouterInfoStatus |
                                                    kRouterInfoUptime |
                                                    kRouterInfoVersion |
                                                    kRouterNetworkStatus |
                                                    kRouterNetDBActivePeers |
                                                    kRouterNetDBFastPeers |
                                                    kRouterNetDBHighCapacityPeers |
                                                    kRouterNetDBKnownPeers |
                                                    kRouterNetTunnelsParticipating;

//=========================================================================

@interface RCRouterManager (Friend)
- (void)routerDidUpdateConnectionSettings:(RCRouter *)router;
@end

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
@property (nonatomic) RCRouterLifecycleStatus lifecycleStatus;
@property (nonatomic) RCRouterManager *parentManager;
@end

//=========================================================================
@implementation RCRouter
//=========================================================================

- (instancetype)initWithConnectionSettings:(RCRouterConnectionSettings *)connectionSettings
{
    self = [super init];
    if (self)
    {
        _connectionSettings = connectionSettings;
        _lifecycleStatus = kRouterLifecycleUnknownStatus;
        _measurementsBuffer = [[RCBWMeasurementBuffer alloc] initWithCapacity:MEASUREMENTS_BUFFER_CAPACITY];
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
    
    TKState *validatingTokenState = [TKState stateWithName:STATE_VALIDATING_TOKEN];
    [validatingTokenState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self validateAuthToken];
        
    }];
    
    TKState *authenticatingState = [TKState stateWithName:STATE_AUTHENTICATING];
    [authenticatingState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self setAuthenticating:YES];
        [self startAuthentication];
        
    }];
    [authenticatingState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self setAuthenticating:NO];
        
    }];

    TKState *waitingAuthRetryState = [TKState stateWithName:STATE_WAITING_AUTH_RETRY];
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
        self.lifecycleStatus = kRouterLifecycleActive;

        [self startActivity];
        
    }];
    [activeState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        
        [self setActive:NO];
        self.lifecycleStatus = kRouterLifecycleUnknownStatus;

        [self stopActivity];
        
    }];

    [stateMachine addStates:@[idleState,
                              validatingTokenState,
                              authenticatingState,
                              waitingAuthRetryState,
                              activeState]];
    
    //**********************
    //Initialize Events
    
    TKEvent *validateTokenEvent = [TKEvent eventWithName:EVENT_VALIDATE_TOKEN transitioningFromStates:@[idleState] toState:validatingTokenState];
    TKEvent *authenticateEvent = [TKEvent eventWithName:EVENT_AUTHENTICATE transitioningFromStates:@[idleState, validatingTokenState]
                                                toState:authenticatingState];
    TKEvent *tokenValidEvent = [TKEvent eventWithName:EVENT_TOKEN_VALID transitioningFromStates:@[validatingTokenState] toState:activeState];
    TKEvent *authErrorEvent = [TKEvent eventWithName:EVENT_AUTH_FAILED transitioningFromStates:@[authenticatingState] toState:waitingAuthRetryState];
    TKEvent *authSucceessEvent = [TKEvent eventWithName:EVENT_AUTH_SUCCEDED transitioningFromStates:@[authenticatingState] toState:activeState];
    TKEvent *retryAuthEvent = [TKEvent eventWithName:EVENT_RETRY_AUTH transitioningFromStates:@[waitingAuthRetryState] toState:authenticatingState];
    TKEvent *connectionErrorEvent = [TKEvent eventWithName:EVENT_CONNECTION_ERROR transitioningFromStates:@[activeState] toState:waitingAuthRetryState];
    
    [stateMachine addEvents:@[validateTokenEvent,
                              tokenValidEvent,
                              authenticateEvent,
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
    BOOL success = NO;
    
    //Decide which event to produce
    if (self.connectionSettings.authToken != nil)
    {
        //Validate token
        success = [self eventValidateToken];
    }
    else
    {
        //Simply start authentication process
        success = [self eventAuthenticate];
    }

    return success;
}

//=========================================================================

- (BOOL)eventValidateToken
{
    BOOL success = [self fireEvent:EVENT_VALIDATE_TOKEN];
    return success;
}

//=========================================================================

- (BOOL)eventAuthenticate
{
    BOOL success = [self fireEvent:EVENT_AUTHENTICATE];
    return success;
}

//=========================================================================

- (BOOL)isInvalidatingAuthTokenError:(NSError *)error
{
    //TODO: Implement me
    //    -32003 – Authentication token doesn't exist.
    //    -32004 – The provided authentication token was expired and will be removed.
    return YES;
}

//=========================================================================

- (BOOL)eventAuthenticationFailedWithError:(NSError *)error
{
    _lastError = error;
    DDLogError(@"Authentication failed with error: %@", error);
 
    //Check if authentication failed because of expired token
    if ([self isInvalidatingAuthTokenError:error])
    {
        DDLogInfo(@"Invalidate existing auth token");
        [self.connectionSettings setAuthToken:nil];
    }
    
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
    _lastError = error;
    DDLogInfo(@"Connection error occurred: %@", error);

    BOOL success = [self fireEvent:EVENT_CONNECTION_ERROR];
    return success;
}

//=========================================================================

- (BOOL)eventTokenValid
{
    BOOL success = [self fireEvent:EVENT_TOKEN_VALID];
    return success;
}

//=========================================================================

- (void)authTokenValidationSucceeded
{
    DDLogDebug(@"Authentication token is still valid");
    [self eventTokenValid];
}

//=========================================================================

- (void)authTokenValidationFailedWithError:(NSError *)error
{
    DDLogDebug(@"Authentication token validation failed: %@", error);
    [self eventAuthenticate];
}

//=========================================================================

- (void)validateAuthToken
{
    DDLogDebug(@"Validate authentication token");
    
    //To validate existing authentication token we simply send echo request to server and analyze the response
    __weak RCRouter *blockSelf = self;
    [self.proxy echoWithString:@"fnord" success:^(NSString *result) {
        
        //Auth token is still valid
        [self authTokenValidationSucceeded];
        
    } failure:^(NSError *error) {

        [blockSelf authTokenValidationFailedWithError:error];

    }];
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

    self.connectionSettings.authToken = token;

    //Notify parent manager
    [self.parentManager routerDidUpdateConnectionSettings:self];
    
    //Authentication succeeded
    [self eventAuthenticationSucceeded];
}

//=========================================================================

- (void)startAuthentication
{
    DDLogInfo(@"Starting authentication");
    
    //Send authentication request
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
    self.authRetryTimer = [NSTimer scheduledTimerWithTimeInterval:RETRY_AUTH_DELAY
                                                           target:self
                                                         selector:@selector(authRetryTimerFired:)
                                                         userInfo:nil
                                                          repeats:NO];
}

//=========================================================================

- (void)startActivity
{
    DDLogInfo(@"Start polling router");
    
    //Create task manager
    RCRouterTaskManager *taskManager = [[RCRouterTaskManager alloc] initWithRouterProxy:self.proxy];
    [taskManager setDelegate:self];
    self.taskManager = taskManager;
    
    [self postRouterInfoUpdateTask];

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
    
    if (self.proxy == nil)
    {
        //Create proxy object
        NSString *urlStr = [NSString stringWithFormat:@"https://%@:%lu", self.connectionSettings.host, self.connectionSettings.port];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSString *authToken = self.connectionSettings.authToken;
        
        //Create proxy object
        self.proxy = [[RCRouterProxy alloc] initWithRouterURL:url authToken:authToken];
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

- (void)postPeriodicRouterInfoUpdateTask
{
    RCRouterInfoTask *task = [[RCRouterInfoTask alloc] initWithIdentifier:@"PeriodicRouterInfo" options:routerInfoTaskOptions];
    task.recurring = YES;
    task.frequency = 2;
    
    __weak RCRouter *blockSelf = self;
    [task setCompletionHandler:^(NSDictionary *responseDict, NSError *error){
        
        if (!error)
        {
            [blockSelf didUpdateRouterInfo:responseDict];
        }
        
    }];
    
    [self postTask:task];
}

//=========================================================================

- (void)cancelPeriodicRouterInfoTask
{
    [self.taskManager removeTaskWithIdentifier:@"PeriodicRouterInfo"];
}

//=========================================================================

- (void)postRouterInfoUpdateTask
{
    RCRouterInfoTask *task = [[RCRouterInfoTask alloc] initWithIdentifier:@"SingleRouterInfo" options:routerInfoTaskOptions];

    __weak RCRouter *blockSelf = self;
    [task setCompletionHandler:^(NSDictionary *responseDict, NSError *error){
        
        if (!error)
        {
            [blockSelf didUpdateRouterInfo:responseDict];
        }
        
    }];

    [self postTask:task];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:RCRouterDidUpdateBandwidthNotification object:self];
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

    [self postTask:task];
}

//=========================================================================

- (void)invalidateRouterInfo
{
    if (self.routerInfo != nil)
    {
        DDLogInfo(@"Invalidating router info");
        self.routerInfo = nil;
    }

    [self notifyDidUpdateRouterInfo];
}

//=========================================================================

- (void)addPeriodicTasks
{
//    RCRouterEchoTask *task = [[RCRouterEchoTask alloc] initWithIdentifier:@"Echo"];
//    task.frequency = 1;
//    [self postTask:task];
    
    //Update bandwidth in/out
    [self addBandwidthUpdateTask];
}

//=========================================================================

- (void)postTask:(RCTask *)task
{
    [self.taskManager addTask:task];
}

//=========================================================================

- (void)restartRouterGracefully:(BOOL)gracefully
{
    RCRouterManagerAction action = kRouterManagerRestart;
    if (gracefully)
    {
        action = kRouterManagerRestartGraceful;
    }
    
    RCRouterManagerTask *task = [[RCRouterManagerTask alloc] initWithIdentifier:@"RestartRouter" action:action];
    [self postTask:task];
    
    if (gracefully)
    {
        self.lifecycleStatus = kRouterLifecycleRestartingGracefully;
    }
    else
    {
        self.lifecycleStatus = kRouterLifecycleRestartingHard;
    }
}

//=========================================================================

- (void)cancelRestart
{
    DDLogError(@"Cancel restart is not supported yet");
}

//=========================================================================

- (void)shutdownRouterGracefully:(BOOL)gracefully
{
    RCRouterManagerAction action = kRouterManagerShutdown;
    if (gracefully)
    {
        action = kRouterManagerShutdownGraceful;
    }
    
    RCRouterManagerTask *task = [[RCRouterManagerTask alloc] initWithIdentifier:@"ShutdownRouter" action:action];
    [self postTask:task];

    if (gracefully)
    {
        self.lifecycleStatus = kRouterLifecycleShuttingDownGracefully;
    }
    else
    {
        self.lifecycleStatus = kRouterLifecycleShuttingDownHard;
    }
}

//=========================================================================

- (void)cancelShutdown
{
    DDLogError(@"Cancel shutdown is not supported yet");
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
