//
//  RCRouterOverviewViewController.m
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterOverviewViewController.h"
#import "RCRouter.h"
#import "RCRouterInfo.h"

//=========================================================================

#define TIME_INTERVAL_MINUTE    60
#define TIME_INTERVAL_HOUR      (TIME_INTERVAL_MINUTE * 60)
#define TIME_INTERVAL_DAY       (TIME_INTERVAL_HOUR * 24)
#define TIME_INTERVAL_HALF_YEAR (TIME_INTERVAL_DAY * 182)
#define TIME_INTERVAL_YEAR      (TIME_INTERVAL_DAY * 365)

#define GetValueOrDefaulIfNil(x) ( (x != nil) ? x : @"-" )

//=========================================================================
@implementation RCRouterOverviewViewController
//=========================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
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

- (void)updateGUI
{
    RCRouter *router = (RCRouter *)self.representedObject;
    
    //Update router version
//    NSMenuItem *item = [self.statusBarItem.menu itemWithTag:kRouterVersionMenuTag];
//    NSString *strValue = self.currentRouter.routerInfo.routerVersion;
//    [self menuItem:item setTitleWithFormat:MyLocalStr(@"VersionTitle") value:strValue];
//    [self.versionTextField setStringValue:]
    
    //Router version
    NSString *str = router.routerInfo.routerVersion;
    [self.versionTextField setStringValue:GetValueOrDefaulIfNil(str)];

    //Router uptime
    NSTimeInterval uptime = router.routerInfo.estimatedRouterUptime;
    if (uptime > 0)
    {
        str = [self uptimeStringForInterval:uptime];
    }
    [self.uptimeTextField setStringValue:GetValueOrDefaulIfNil(str)];

    //Router status
    str = router.routerInfo.routerStatus;
    [self.statusTextField setStringValue:GetValueOrDefaulIfNil(str)];
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)startUpdating
{
    DDLogInfo(@"Start updating");
}

//=========================================================================

- (void)stopUpdating
{
    DDLogInfo(@"Stop updating");
}

//=========================================================================

- (void)loadView
{
    [super loadView];
    [self updateGUI];
}

//=========================================================================

- (void)setRepresentedObject:(id)object
{
    NSAssert([object isKindOfClass:[RCRouter class]], @"Invalid object");
    
    [super setRepresentedObject:object];
    [self updateGUI];
}

//=========================================================================
@end
//=========================================================================
