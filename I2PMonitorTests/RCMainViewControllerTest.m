//
//  RCRouterOverviewViewControllerTest.m
//  I2PMonitor
//
//  Created by miximka on 14/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RCMainViewController.h"

//=========================================================================

@interface RCMainViewControllerTest : XCTestCase
@property (nonatomic) RCMainViewController *testObject;
@end

//=========================================================================
@implementation RCMainViewControllerTest
//=========================================================================

- (void)setUp
{
    [super setUp];
    _testObject = [[RCMainViewController alloc] initWithNibName:nil bundle:nil];
}

//=========================================================================

- (void)tearDown
{
    _testObject = nil;
    [super tearDown];
}

//=========================================================================

- (void)testUptimeStringSeconds
{
    NSString *expectedString = [NSString stringWithFormat:@"%i %@", 5, MyLocalStr(@"kSecondsShortAbbr")];
    XCTAssertEqualObjects([_testObject uptimeStringForInterval:5], expectedString);
}

//=========================================================================

- (void)testUptimeStringMinutes
{
    NSString *expectedString = [NSString stringWithFormat:@"%i %@", 1, MyLocalStr(@"kMinutesShortAbbr")];
    XCTAssertEqualObjects([_testObject uptimeStringForInterval:65], expectedString);
}

//=========================================================================

- (void)testUptimeStringHours
{
    NSString *expectedString = [NSString stringWithFormat:@"%i %@", 22, MyLocalStr(@"kHoursShortAbbr")];
    XCTAssertEqualObjects([_testObject uptimeStringForInterval:60*60*22], expectedString);
}

//=========================================================================

- (void)testUptimeStringDays
{
    NSString *expectedString = [NSString stringWithFormat:@"%i %@", 6, MyLocalStr(@"kDaysShortAbbr")];
    XCTAssertEqualObjects([_testObject uptimeStringForInterval:60*60*24*6], expectedString);
}

//=========================================================================
@end
//=========================================================================
