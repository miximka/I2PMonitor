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
#import "RCNetworkStatusViewController.h"
#import "RCPeersViewController.h"
#import "RCTabsControl.h"
#import "RCTabsControlCell.h"
#import <QuartzCore/QuartzCore.h>

//=========================================================================

@interface RCMainViewController ()
@property (nonatomic) NSTimer *uiUpdateTimer;
@property (nonatomic) RCViewController *currentController;
@property (nonatomic) RCNetworkStatusViewController *networkViewController;
@property (nonatomic) RCPeersViewController *peersViewController;
@property (nonatomic) BOOL isWarningViewVisible;
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
    
//    NSView *contentView = self.contentView;
//    
//    //Notify controller the view will be removed from its superview
//    [self.currentController willMoveToParentViewController:nil];
//    
//    //Remove current content
//    for (NSView *each in contentView.subviews)
//    {
//        [each removeFromSuperview];
//    }
//    
//    [self.currentController didMoveToParentViewController:nil];
//    
//    //Notify new view controller it will be moved to us
//    [controller willMoveToParentViewController:self];
//    
//    //Calculate new window frame to match the new size of the content
//    NSView *newView = controller.view;
//    
//    //Add new view to view hierarchy
//    NSRect newViewFrame = NSMakeRect(0, 0, newView.frame.size.width, newView.frame.size.height);
//    [newView setFrame:newViewFrame];
//    [newView setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
//    [contentView addSubview:newView];
//
//    //Update represented object on the controller
//    [controller setRepresentedObject:self.representedObject];
//
//    //Notify new view controller it has been moved
//    [controller didMoveToParentViewController:self];
//    self.currentController = controller;
//
//    [self.delegate mainViewControllerDidResizeView:self];

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
    [self.hostTextField setStringValue:GetValueOrDefaulIfNil(str)];
}

//=========================================================================

- (void)updateVersion
{
    RCRouter *router = (RCRouter *)self.representedObject;
    
    NSString *str = router.routerInfo.routerVersion;
    [self.versionTextField setStringValue:GetValueOrDefaulIfNil(str)];
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
    [self.uptimeTextField setStringValue:GetValueOrDefaulIfNil(str)];
}

//=========================================================================

- (void)updateGUI
{
    [self updateHost];
    [self updateVersion];
    [self updateUptime];
}

//=========================================================================

- (void)startUpdating
{
    DDLogInfo(@"Start updating");
    [self restartUiUpdateTimer];
    
    //Also notify current content view controller
    [self.currentController startUpdatingGUI];
    
    //Immediately trigger router info update
    [(RCRouter *)self.representedObject postRouterInfoUpdateTask];
}

//=========================================================================

- (void)stopUpdating
{
    DDLogInfo(@"Stop updating");
    RCInvalidateTimer(self.uiUpdateTimer);
    
    //Also notify current content view controller
    [self.currentController stopUpdatingGUI];
}

//=========================================================================

- (RCNetworkStatusViewController *)networkViewController
{
    if (_networkViewController == nil)
    {
        RCNetworkStatusViewController *controller = [[RCNetworkStatusViewController alloc] initWithNibName:@"Network" bundle:nil];
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

- (IBAction)showNetworkInfoView:(id)sender
{
}

//=========================================================================

- (IBAction)showPeersView:(id)sender
{
}

//=========================================================================

- (void)toggleWarningView:(BOOL)animate
{
    //Toggle warning view visibility
    CGFloat heightDelta = self.warningView.frame.size.height;
    
    if (self.isWarningViewVisible)
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
    
    self.isWarningViewVisible = !self.isWarningViewVisible;
}

//=========================================================================

- (void)showWarningView:(BOOL)flag animate:(BOOL)animate
{
    if (flag == self.isWarningViewVisible)
        return;

    [self toggleWarningView:animate];
}

//=========================================================================

- (IBAction)tabsControlAction:(id)sender
{
    switch (self.tabsControl.selectedSegment)
    {
        case 0:
            [self switchToController:self.networkViewController animate:YES];
            break;

        case 1:
            [self switchToController:self.peersViewController animate:YES];
            break;

        case 2:
            break;

        default:
            break;
    }
}

//=========================================================================

- (void)addWarningView
{
    //Warning view is positioned within header view below the bottom edge so it does not get rendered and remains hidden until header view is resized
    NSView *warningView = self.warningView;
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
    assert([object isKindOfClass:[RCRouter class]]);

    //Also set represented object to network view controller
    [self.currentController setRepresentedObject:object];
    
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
@end
//=========================================================================
