//
//  RCMainViewController.m
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCMainViewController.h"
#import "RCNetworkStatusViewController.h"
#import "RCRouter.h"
#import "RCRouterInfo.h"
#import "RCSessionConfig.h"

//=========================================================================

@interface RCMainViewController ()
@property (nonatomic) RCNetworkStatusViewController *networkViewController;
@property (nonatomic) NSTimer *uiUpdateTimer;
@property (nonatomic) RCViewController *currentWidgetController;
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

- (void)switchToControllerView:(RCViewController *)controller
{
    NSView *contentView = self.contentView;
    
    //Notify controller the view will be removed from its superview
    [self.currentWidgetController willMoveToParentViewController:nil];
    
    //Remove current content
    for (NSView *each in contentView.subviews)
    {
        [each removeFromSuperview];
    }

    [self.currentWidgetController didMoveToParentViewController:nil];

    //Notify new view controller it will be moved to us
    [controller willMoveToParentViewController:self];
    
    //Calculate new window frame to match the new size of the content
    NSView *newView = controller.view;
    
    //Add new view to view hierarchy
    NSRect newViewFrame = NSMakeRect(0, 0, newView.frame.size.width, newView.frame.size.height);
    [newView setFrame:newViewFrame];
    [newView setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
    [contentView addSubview:newView];

    //Notify new view controller it has been moved
    [controller didMoveToParentViewController:self];

    self.currentWidgetController = controller;
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
    self.uiUpdateTimer = [NSTimer timerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(uiUpdateTimerFired:)
                                               userInfo:nil
                                                repeats:YES];
    
    //Add timer manually with NSRunLoopCommonModes to update UI even when menu is opened
    [[NSRunLoop currentRunLoop] addTimer:self.uiUpdateTimer
                                 forMode:NSRunLoopCommonModes];
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
    
    //Immediately trigger router info update
    [(RCRouter *)self.representedObject updateRouterInfo];
}

//=========================================================================

- (void)stopUpdating
{
    DDLogInfo(@"Stop updating");
    RCInvalidateTimer(self.uiUpdateTimer);
}

//=========================================================================

- (IBAction)control:(id)sender
{
    
}

//=========================================================================

- (NSSize)preferredViewSize
{
    NSSize mainViewSize = self.view.frame.size;
    NSSize currentContentViewSize = self.contentView.frame.size;
    NSSize wishedContentViewSize = self.currentWidgetController.preferredViewSize;
    
    mainViewSize.height = mainViewSize.height - currentContentViewSize.height + wishedContentViewSize.height;
    mainViewSize.width = mainViewSize.width - currentContentViewSize.width + wishedContentViewSize.width;
    
    return mainViewSize;
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)awakeFromNib
{
    [self registerForNotifications];

    RCNetworkStatusViewController *networkController = [[RCNetworkStatusViewController alloc] initWithNibName:@"NetworkStatus" bundle:nil];
    self.networkViewController = networkController;
    
    [self switchToControllerView:networkController];
}

//=========================================================================

- (void)setRepresentedObject:(id)object
{
    [super setRepresentedObject:object];
    assert([object isKindOfClass:[RCRouter class]]);

    //Also set represented object to network view controller
    [self.networkViewController setRepresentedObject:object];

    //Update UI immediately
    [self updateGUI];
}

//=========================================================================
#pragma mark NSTimer callback
//=========================================================================

- (void)uiUpdateTimerFired:(NSTimer *)timer
{
    [self updateGUI];
    [self.currentWidgetController updateGUI];
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
