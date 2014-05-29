//
//  RCPeersViewController.m
//  I2PMonitor
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
    
    if (routerInfo != nil)
    {
        NSString *str = [NSString stringWithFormat:@"%lu", routerInfo.activePeers];
        [self.activePeersTextField setStringValue:str];
        
        str = [NSString stringWithFormat:@"%lu", routerInfo.fastPeers];
        [self.fastPeersTextField setStringValue:str];
        
        str = [NSString stringWithFormat:@"%lu", routerInfo.highCapacityPeers];
        [self.highCapacityPeersTextField setStringValue:str];
        
        str = [NSString stringWithFormat:@"%lu", routerInfo.knownPeers];
        [self.knownPeersTextField setStringValue:str];

        str = [NSString stringWithFormat:@"%lu", routerInfo.participatingTunnels];
        [self.participatingTunnelsTextField setStringValue:nil];
    }
    else
    {
        [self.activePeersTextField setStringValue:nil];
        [self.fastPeersTextField setStringValue:nil];
        [self.highCapacityPeersTextField setStringValue:nil];
        [self.knownPeersTextField setStringValue:nil];
        [self.participatingTunnelsTextField setStringValue:nil];
    }
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
