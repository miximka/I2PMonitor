//
//  RCPeersViewController.m
//  I2PRemoteControl
//
//  Created by miximka on 20/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCPeersViewController.h"
#import "RCRouter.h"
#import "RCRouterInfo.h"
#import "RCContentView.h"

//=========================================================================

@interface RCPeersViewController ()
@end

//=========================================================================
@implementation RCPeersViewController
//=========================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Initialization code here.
    }
    return self;
}
//=========================================================================

- (void)dealloc
{
    [self unregisterFromNotifications];
}

//=========================================================================

- (void)unregisterFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//=========================================================================

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(routerDidUpdateRouterInfo:)
                                                 name:RCRouterDidUpdateRouterInfoNotification
                                               object:nil];
}

//=========================================================================

- (void)updatePeerLabels
{
    RCRouterInfo *routerInfo = [(RCRouter *)self.representedObject routerInfo];
    
    NSString *str = [NSString stringWithFormat:@"%lu", routerInfo.activePeers];
    [self.activePeersTextField setStringValue:GetValueOrDefaulIfNil(str)];
    
    str = [NSString stringWithFormat:@"%lu", routerInfo.fastPeers];
    [self.fastPeersTextField setStringValue:GetValueOrDefaulIfNil(str)];
    
    str = [NSString stringWithFormat:@"%lu", routerInfo.highCapacityPeers];
    [self.highCapacityPeersTextField setStringValue:GetValueOrDefaulIfNil(str)];

    str = [NSString stringWithFormat:@"%lu", routerInfo.knownPeers];
    [self.knownPeersTextField setStringValue:GetValueOrDefaulIfNil(str)];
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)loadView
{
    [super loadView];
    
    [(RCContentView *)self.view setColorType:RCContentViewColorRed];
    [self updateGUI];
    [self registerForNotifications];
}

//=========================================================================

- (void)updateGUI
{
    [super updateGUI];
    [self updatePeerLabels];
}

//=========================================================================

- (void)startUpdatingGUI
{
    RCRouter *router = (RCRouter *)self.representedObject;
    [router postPeriodicRouterInfoUpdateTask];
}

//=========================================================================

- (void)stopUpdatingGUI
{
    RCRouter *router = (RCRouter *)self.representedObject;
    [router cancelPeriodicRouterInfoTask];
}

//=========================================================================
#pragma mark Notifications
//=========================================================================

- (void)routerDidUpdateRouterInfo:(NSNotification *)notification
{
    [self updateGUI];
}

//=========================================================================
#pragma mark NSTimer callback
//=========================================================================

- (void)uiUpdateTimerFired:(NSTimer *)timer
{
    [self updateGUI];
}

//=========================================================================
@end
//=========================================================================
