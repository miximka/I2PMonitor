//
//  RCMainViewController.m
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCMainViewController.h"
#import "RCRouter.h"
#import "RCRouterInfo.h"
#import "RCSessionConfig.h"
#import "RCNetworkViewController.h"
#import "RCPeersViewController.h"
#import "RCTabsControl.h"
#import "RCTabsControlCell.h"
#import <QuartzCore/QuartzCore.h>
#import "RCNotificationView.h"
#import "RCPreferences.h"
#import "RCControlViewController.h"
#import "RCLinkTextField.h"

//=========================================================================

@interface RCMainViewController () <RCLinkTextFieldDelegate>
@property (nonatomic) NSTimer *uiUpdateTimer;
@property (nonatomic) RCViewController *currentController;
@property (nonatomic) RCNetworkViewController *networkViewController;
@property (nonatomic) RCPeersViewController *peersViewController;
@property (nonatomic) RCControlViewController *controlViewController;
@property (nonatomic) BOOL isNotificationViewVisible;
@end

//=========================================================================
@implementation RCMainViewController
//=========================================================================

- (void)dealloc
{
    [self unregisterFromNotifications];
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

- (void)unregisterFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//=========================================================================

- (void)switchToController:(RCViewController *)controller animate:(BOOL)animate
{
    if (self.currentController == controller)
        return;

    //Notify controller the view will be removed from its superview
    [self.currentController willMoveToParentViewController:nil];

    //Remove current view
    [self.currentController.view removeFromSuperview];

    [self.currentController didMoveToParentViewController:nil];

    //Notify new view controller it will be moved in
    [controller willMoveToParentViewController:self];

    //Calculate new window frame to match the new size of the content
    NSView *view = controller.view;

    //Add view to the view hierarchy
    [self.contentContainerView addSubview:view];
    [view setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
    
    //Update represented object of the controller
    [controller setRepresentedObject:self.representedObject];

    //Notify new view controller it has been moved
    [controller didMoveToParentViewController:self];

    self.currentController = controller;

    //Apply "content container view" size change
    if (animate)
    {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            
            CAMediaTimingFunction *func = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [context setTimingFunction:func];
            [context setDuration:0.2];
            
            self.contentContainerViewHeightConstraint.animator.constant = view.frame.size.height;
            self.contentContainerViewWidthConstraint.animator.constant = view.frame.size.width;
            
        } completionHandler:^{
        }];
    }
    else
    {
        self.contentContainerViewHeightConstraint.constant = view.frame.size.height;
        self.contentContainerViewWidthConstraint.constant = view.frame.size.width;
    }
}

//=========================================================================

- (void)updateHost
{
    RCRouter *router = (RCRouter *)self.representedObject;
    
    NSString *str = router.sessionConfig.host;
    [self.hostTextField setStringValue:str];
}

//=========================================================================

- (void)updateVersion
{
    RCRouter *router = (RCRouter *)self.representedObject;
    
    NSString *str = router.routerInfo.routerVersion;
    [self.versionTextField setStringValue:str];
}

//=========================================================================

- (void)restartUiUpdateTimer
{
    //Invalidate previous timer,
    RCInvalidateTimer(self.uiUpdateTimer);
    
    //Start periodically update menu entries
    self.uiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(uiUpdateTimerFired:)
                                                        userInfo:nil
                                                         repeats:YES];
}

//=========================================================================

- (NSString *)uptimeStringForInterval:(NSTimeInterval)interval
{
    NSString *str = @"";
    
	if (interval < TIME_INTERVAL_MINUTE)
	{
        int secs = interval;
        str = [NSString stringWithFormat:@"%i %@", secs, MyLocalStr(@"kSecondsShortAbbr")];
	}
	else if (interval >= TIME_INTERVAL_MINUTE && interval < TIME_INTERVAL_HOUR)
	{
        int mins = interval / TIME_INTERVAL_MINUTE;
        str = [NSString stringWithFormat:@"%i %@", mins, MyLocalStr(@"kMinutesShortAbbr")];
	}
	else if (interval >= TIME_INTERVAL_HOUR && interval < TIME_INTERVAL_DAY)
	{
        int hours = interval / TIME_INTERVAL_HOUR;
        str = [NSString stringWithFormat:@"%i %@", hours, MyLocalStr(@"kHoursShortAbbr")];
	}
	else
	{
        int days = interval / TIME_INTERVAL_DAY;
        str = [NSString stringWithFormat:@"%i %@", days, MyLocalStr(@"kDaysShortAbbr")];
	}
    
	return str;
}

//=========================================================================

- (void)updateUptime
{
    RCRouter *router = (RCRouter *)self.representedObject;
    
    NSString *str = nil;
    NSTimeInterval uptime = router.routerInfo.estimatedRouterUptime;
    if (uptime > 0)
    {
        str = [self uptimeStringForInterval:uptime];
    }
    [self.uptimeTextField setStringValue:str];
}

//=========================================================================

- (NSString *)humanReadableStringForNetworkStatus:(RCRouterNetStatus)status
{
    NSDictionary *statusToStr = @{
                                  @(kNetStatusOK) : MyLocalStr(@"kNetStatusOK"),
                                  @(kNetStatusTesting) : MyLocalStr(@"kNetStatusTesting"),
                                  @(kNetStatusFirewalled) : MyLocalStr(@"kNetStatusFirewalled"),
                                  @(kNetStatusHidden) : MyLocalStr(@"kNetStatusHidden"),
                                  @(kNetStatusWarnFirewalledAndFast) : MyLocalStr(@"kNetStatusWarnFirewalledAndFast"),
                                  @(kNetStatusWarnFirewalledAndFloodfill) : MyLocalStr(@"kNetStatusWarnFirewalledAndFloodfill"),
                                  @(kNetStatusWarnFirewalledWithInboundTCP) : MyLocalStr(@"kNetStatusWarnFirewalledWithInboundTCP"),
                                  @(kNetStatusWarnFirewalledWithUDPDisabled) : MyLocalStr(@"kNetStatusWarnFirewalledWithUDPDisabled"),
                                  @(kNetStatusErrorI2CP) : MyLocalStr(@"kNetStatusErrorI2CP"),
                                  @(kNetStatusErrorClockSkew) : MyLocalStr(@"kNetStatusErrorClockSkew"),
                                  @(kNetStatusErrorPrivateTCPAddress) : MyLocalStr(@"kNetStatusErrorPrivateTCPAddress"),
                                  @(kNetStatusErrorSymmetricNat) : MyLocalStr(@"kNetStatusErrorSymmetricNat"),
                                  @(kNetStatusErrorUDPPortInUse) : MyLocalStr(@"kNetStatusErrorUDPPortInUse"),
                                  @(kNetStatusErrorNoActivePeersCheckConnectionAndFirewall) : MyLocalStr(@"kNetStatusErrorNoActivePeersCheckConnectionAndFirewall"),
                                  @(kNetStatusErrorUDPDisabledAndTCPUnset) : MyLocalStr(@"kNetStatusErrorUDPDisabledAndTCPUnset"),
                                  };
    
    NSString *str = [statusToStr objectForKey:@(status)];
    return str;
}

//=========================================================================

- (NSString *)routerStatusStringWithRouterInfo:(RCRouterInfo *)routerInfo statusStyle:(NSAlertStyle *)style
{
    NSString *str = nil;
    NSAlertStyle strStyle = NSInformationalAlertStyle;
    
    RCRouterNetStatus netStatus = routerInfo.routerNetStatus;
    if (netStatus != kNetStatusOK)
    {
        //Define message and style of the notification
        str = [self humanReadableStringForNetworkStatus:netStatus];
        strStyle = NSWarningAlertStyle;
    }
    
    if (str == nil)
    {
        //No notification message defined yet, so check router status and show it then
        NSString *routerStatusStr = routerInfo.routerStatus;
        
        //Use hardcoded string match. Its bad, but for the moment I don't have better solution.
        //Actually, the router should deliver some kind of ENUM instead of string values...
        BOOL isAcceptingTunnelsStatus = [routerStatusStr isEqualToString:@"Accepting tunnels"];
        
        if (isAcceptingTunnelsStatus == NO)
        {
            //Append router status string
            str = routerStatusStr;
        }
    }
    
    if (style != nil)
    {
        *style = strStyle;
    }
    
    return str;
}

//=========================================================================

- (NSString *)descriptionForRouterError:(NSError *)error
{
    NSString *str = nil;
    
    if ([error.domain isEqualToString:NSURLErrorDomain])
    {
        NSDictionary *errorMap = @{
                                   @(NSURLErrorCannotConnectToHost) : MyLocalStr(@"RCErrorCantConnectToRouter"),
                                   @(kCFURLErrorTimedOut) : MyLocalStr(@"RCErrorConnectionTimeout")
                                   };
        
        str = [errorMap objectForKey:[NSNumber numberWithInteger:error.code]];
    }
    
    if (str == nil)
    {
        //Fallback to default error message
        str = error.localizedDescription;
    }
    
    return str;
}

//=========================================================================

- (void)updateNotificationView
{
    RCRouter *router = (RCRouter *)self.representedObject;
    RCRouterInfo *routerInfo = router.routerInfo;

    NSAlertStyle style = NSInformationalAlertStyle;
    NSString *message = nil;
    
    if (routerInfo != nil)
    {
        message = [self routerStatusStringWithRouterInfo:routerInfo statusStyle:&style];
    }
    else
    {
        //There are no router info yet. Check if router is connected
        NSError *error = router.lastError;
        
        if (error != nil)
        {
            style = NSWarningAlertStyle;
            message = [self descriptionForRouterError:error];
        }
    }
    
    [self setNotificationMessage:message style:style];
}

//=========================================================================

- (void)setNotificationMessage:(NSString *)message style:(NSAlertStyle)style
{
    //Update message
    [self.notificationView setMessage:message];
    [self.notificationView setNotificationStyle:style];
    
    //Show or hide warning view
    BOOL isMsgOK = message != nil && message.length > 0;
    
    BOOL isStyleOK = YES;
    if ([RCPrefs showNotificationsType] == kRouterShowOnlyImportantNotificationsType)
    {
        //Only allow important notifications
        isStyleOK = style == NSWarningAlertStyle || style == NSCriticalAlertStyle;
    }
    
    BOOL shouldShow = isMsgOK && isStyleOK;
    [self showNotification:shouldShow animate:YES];
}

//=========================================================================

- (void)updateGUI
{
    [self updateHost];
    [self updateVersion];
    [self updateUptime];
    [self updateNotificationView];
}

//=========================================================================

- (void)startUpdating
{
    DDLogInfo(@"Start updating");
    [self restartUiUpdateTimer];
    
    //Also notify current content view controller
    [self.currentController startUpdatingGUI];
    
    //Start periodically update router info
    [(RCRouter *)self.representedObject postPeriodicRouterInfoUpdateTask];
}

//=========================================================================

- (void)stopUpdating
{
    DDLogInfo(@"Stop updating");
    RCInvalidateTimer(self.uiUpdateTimer);
    
    //Also notify current content view controller
    [self.currentController stopUpdatingGUI];

    //Stop periodically update router info
    [(RCRouter *)self.representedObject cancelPeriodicRouterInfoTask];
}

//=========================================================================

- (RCNetworkViewController *)networkViewController
{
    if (_networkViewController == nil)
    {
        RCNetworkViewController *controller = [[RCNetworkViewController alloc] initWithNibName:@"Network" bundle:nil];
        _networkViewController = controller;
    }
    
    return _networkViewController;
}

//=========================================================================

- (RCPeersViewController *)peersViewController
{
    if (_peersViewController == nil)
    {
        RCPeersViewController *controller = [[RCPeersViewController alloc] initWithNibName:@"Peers" bundle:nil];
        _peersViewController = controller;
    }
    
    return _peersViewController;
}

//=========================================================================

- (RCControlViewController *)controlViewController
{
    if (_controlViewController == nil)
    {
        RCControlViewController *controller = [[RCControlViewController alloc] initWithNibName:@"Control" bundle:nil];
        _controlViewController = controller;
    }
    
    return _controlViewController;
}

//=========================================================================

- (IBAction)showNetworkInfoView:(id)sender
{
}

//=========================================================================

- (IBAction)showPeersView:(id)sender
{
}

//=========================================================================

- (void)showNotification:(BOOL)flag animate:(BOOL)animate
{
    if (flag == self.isNotificationViewVisible)
        return;

    [self toggleNotificationView:animate];
}

//=========================================================================

- (void)toggleNotificationView:(BOOL)animate
{
    //Toggle warning view visibility
    CGFloat heightDelta = self.notificationView.frame.size.height;
    
    if (self.isNotificationViewVisible)
    {
        heightDelta = -heightDelta;
    }
    
    if (animate)
    {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            
            CAMediaTimingFunction *func = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [context setTimingFunction:func];
            [context setDuration:0.2];
            self.headerViewHeightConstraint.animator.constant += heightDelta;
            
        } completionHandler:^{
        }];
    }
    else
    {
        self.headerViewHeightConstraint.constant += heightDelta;
    }
    
    self.isNotificationViewVisible = !self.isNotificationViewVisible;
}

//=========================================================================

- (IBAction)tabsControlAction:(id)sender
{
    RCViewController *controller = nil;
    
    switch (self.tabsControl.selectedSegment)
    {
        case 0:
            controller = self.networkViewController;
            break;

        case 1:
            controller = self.peersViewController;
            break;

        case 2:
            controller = self.controlViewController;
            break;

        default:
            break;
    }

    if (controller != nil)
    {
        [self switchToController:controller animate:YES];
    }
}

//=========================================================================

- (void)addWarningView
{
    //Warning view is positioned within header view below the bottom edge so it does not get rendered and remains hidden until header view is resized
    NSView *warningView = self.notificationView;
    [warningView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.headerView addSubview:warningView];
    
    //Add constraints
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[warningView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(warningView)]];
    NSString *verticalConstraintFormat = [NSString stringWithFormat:@"V:|-%i-[warningView(%i)]", (int)self.headerView.frame.size.height, (int)warningView.frame.size.height];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintFormat options:0 metrics:nil views:NSDictionaryOfVariableBindings(warningView)]];
}

//=========================================================================

- (void)addTabsControlView
{
    //Add and configure tabs control
    RCTabsControl *tabsControl = [[RCTabsControl alloc] initWithFrame:self.tabsControlPlaceholderView.bounds];
    [tabsControl setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [self.tabsControlPlaceholderView addSubview:tabsControl];
    [tabsControl setSegmentCount:3];
    [tabsControl setLabel:@"Network" forSegment:0];
    [tabsControl setLabel:@"Peers" forSegment:1];
    [tabsControl setLabel:@"Control" forSegment:2];
    [tabsControl setImage:[NSImage imageNamed:@"Network"] forSegment:0];
    [tabsControl setImage:[NSImage imageNamed:@"Peers"] forSegment:1];
    [tabsControl setImage:[NSImage imageNamed:@"Preferences"] forSegment:2];
    [tabsControl setAction:@selector(tabsControlAction:)];
    [tabsControl setTarget:self];
    [tabsControl setSelectedSegment:0];
    self.tabsControl = tabsControl;
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)loadView
{
    [super loadView];

    //Configure GUI
    [self addWarningView];
    [self addTabsControlView];
    
    //Switch to default tab
    [self switchToController:self.networkViewController animate:NO];
    
    //Register for notifications
    [self registerForNotifications];
}

//=========================================================================

- (void)setRepresentedObject:(id)object
{
    [super setRepresentedObject:object];

    RCRouter *router = (RCRouter *)object;
    assert([router isKindOfClass:[RCRouter class]]);
    
    //Also set represented object to network view controller
    [self.currentController setRepresentedObject:router];
    
    //Update UI immediately
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
#pragma mark Notifications
//=========================================================================

- (void)routerDidUpdateRouterInfo:(NSNotification *)notification
{
    [self updateGUI];
}

//=========================================================================
#pragma mark RCLinkTextFieldDelegate
//=========================================================================

- (void)clickableTextFieldMouseDown:(RCLinkTextField *)textField
{
    RCRouter *router = (RCRouter *)self.representedObject;
    
    //Update WebUI url
    NSString *consoleUrlStr = [NSString stringWithFormat:@"http://%@:%lu", router.sessionConfig.host, router.sessionConfig.consolePort];
    NSURL *consoleURL = [NSURL URLWithString:consoleUrlStr];
    
    [[NSWorkspace sharedWorkspace] openURL:consoleURL];
    
    //Also dismiss window immediately
    [self.delegate mainViewControllerShouldDismissWindow:self];
}

//=========================================================================
@end
//=========================================================================
