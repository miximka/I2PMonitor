//
//  RCPrefsGeneralViewController.m
//  I2PMonitor
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCPrefsGeneralViewController.h"
#import "RCPreferences.h"
#import "RCRouterManager.h"
#import "RCRouter.h"

//=========================================================================

@interface RCPrefsGeneralViewController ()
@property (nonatomic) BOOL registeredForNotifications;
@property (nonatomic) RCRouter *router;
@end

//=========================================================================
@implementation RCPrefsGeneralViewController
//=========================================================================

- (void)dealloc
{
    [self unregisterFromNotifications];
    [self setRouter:nil];
}

//=========================================================================

- (void)setRouter:(RCRouter *)router
{
    if (_router != router)
    {
        //Unregister from KVO notifications
        [_router removeObserver:self forKeyPath:NSStringFromSelector(@selector(active))];
        [_router removeObserver:self forKeyPath:NSStringFromSelector(@selector(authenticating))];
        _router = nil;
    }
    
    if (router != nil)
    {
        _router = router;
        [router addObserver:self forKeyPath:NSStringFromSelector(@selector(active)) options:0 context:nil];
        [router addObserver:self forKeyPath:NSStringFromSelector(@selector(authenticating)) options:0 context:nil];
    }
}

//=========================================================================

- (IBAction)startOnSystemStartup:(id)sender
{
    NSInteger state = [self.startOnSystemStartupButton state];
    [RCPrefs setStartOnSystemStartup:state];
}

//=========================================================================

- (IBAction)resetToDefaults:(id)sender
{
    [RCPrefs removeObjectForKey:PREFS_KEY_ROUTER_HOST];
    [RCPrefs removeObjectForKey:PREFS_KEY_ROUTER_PORT];
    
    [self loadDefaultValuesForHostAndPort];
}

//=========================================================================

- (IBAction)setShowRouterNotificationType:(id)sender
{
    [RCPrefs setShowNotificationsType:[(NSButtonCell *)self.notificationsMatrix.selectedCell tag]];
}

//=========================================================================

- (void)updateConnectionStatus
{
    RCRouter *router = self.router;
    
    NSString *statusImageName = @"StatusRed";
    if (router.active)
    {
        statusImageName = @"StatusGreen";
    }
    else if (router.authenticating)
    {
        statusImageName = @"StatusYellow";
    }
    
    [self.connectionStatusImageView setImage:[NSImage imageNamed:statusImageName]];
}

//=========================================================================

- (void)registerForNotifications
{
    if (self.registeredForNotifications)
        return;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managerDidSetRouter:)
                                                 name:RCManagerDidSetRouterNotification
                                               object:nil];
}

//=========================================================================

- (void)unregisterFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//=========================================================================
#pragma mark Overriden methods
//=========================================================================

- (void)didSelectTab
{
    [self registerForNotifications];

    [self setRouter:self.routerManager.activeRouter];
    [self updateConnectionStatus];
}

//=========================================================================

- (NSString *)defaultViewNibName
{
	return @"PreferencesGeneral";
}

//=========================================================================

- (void)loadDefaultValuesForHostAndPort
{
    [self.hostTextField setStringValue:[RCPrefs routerHost]];
    
    NSString *port = [NSString stringWithFormat:@"%li", [RCPrefs routerPort]];
    [self.portTextField setStringValue:port];
}

//=========================================================================

- (void)loadDefaultValues
{
	[super loadDefaultValues];
    
    [self.startOnSystemStartupButton setState:[RCPrefs startOnSystemStartup]];
    [self loadDefaultValuesForHostAndPort];
    [self.notificationsMatrix selectCellWithTag:[RCPrefs showNotificationsType]];
}

//=========================================================================
#pragma mark NSTextFieldDelegate
//=========================================================================

- (void)controlTextDidEndEditing:(NSNotification *)notification
{
    id object = notification.object;
    
    if (object == self.hostTextField)
    {
        //Apply changes immediately
        NSString *newHost = self.hostTextField.stringValue;
        [RCPrefs setRouterHost:newHost];
    }
    else if (object == self.portTextField)
    {
        //Apply changes immediately
        NSUInteger newPort = [self.portTextField intValue];
        [RCPrefs setRouterPort:newPort];
    }
}

//=========================================================================

- (void)managerDidSetRouter:(NSNotification *)notification
{
    [self setRouter:self.routerManager.activeRouter];
    [self updateConnectionStatus];
}

//=========================================================================
#pragma mark KVO notifications
//=========================================================================

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateConnectionStatus];
}

//=========================================================================
@end
//=========================================================================
