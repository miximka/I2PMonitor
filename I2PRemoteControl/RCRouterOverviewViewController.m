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
#import "FBKVOController.h"

//=========================================================================

#define TIME_INTERVAL_MINUTE    60
#define TIME_INTERVAL_HOUR      (TIME_INTERVAL_MINUTE * 60)
#define TIME_INTERVAL_DAY       (TIME_INTERVAL_HOUR * 24)
#define TIME_INTERVAL_HALF_YEAR (TIME_INTERVAL_DAY * 182)
#define TIME_INTERVAL_YEAR      (TIME_INTERVAL_DAY * 365)

#define GetValueOrDefaulIfNil(x) ( (x != nil) ? x : @"-" )

//=========================================================================

@interface RCRouterOverviewViewController ()
@property (nonatomic) FBKVOController *kvoController;
@end

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

- (void)updateVersion
{
    RCRouter *router = (RCRouter *)self.representedObject;

    NSString *str = router.routerInfo.routerVersion;
    [self.versionTextField setStringValue:GetValueOrDefaulIfNil(str)];
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

- (void)updateStatus
{
    RCRouter *router = (RCRouter *)self.representedObject;
    
    NSString *str = router.routerInfo.routerStatus;
    [self.statusTextField setStringValue:GetValueOrDefaulIfNil(str)];
}

//=========================================================================

- (void)updateGUI
{
    [self updateVersion];
    [self updateUptime];
    [self updateStatus];
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
    [super setRepresentedObject:object];

    NSAssert([object isKindOfClass:[RCRouter class]], @"Invalid object");
    RCRouter *router = (RCRouter *)object;
    
    //Register for KVO notifications
    FBKVOController *kvoController = [[FBKVOController alloc] initWithObserver:self];
    self.kvoController = kvoController;
    
    __weak RCRouterOverviewViewController *blockSelf = self;
    [self.kvoController observe:router.routerInfo
                        keyPath:NSStringFromSelector(@selector(routerVersion))
                        options:0
                          block:^(id observer, id object, NSDictionary *change) {
                              
                              [blockSelf updateVersion];
                              
                          }];

    [self.kvoController observe:router.routerInfo
                        keyPath:NSStringFromSelector(@selector(routerUptime))
                        options:0
                          block:^(id observer, id object, NSDictionary *change) {
                              
                              [blockSelf updateUptime];
                              
                          }];

    [self.kvoController observe:router.routerInfo
                        keyPath:NSStringFromSelector(@selector(routerStatus))
                        options:0
                          block:^(id observer, id object, NSDictionary *change) {
                              
                              [blockSelf updateStatus];
                              
                          }];

    [self updateGUI];
}

//=========================================================================
@end
//=========================================================================
