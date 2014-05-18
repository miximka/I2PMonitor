//
//  RCMenuItem.m
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterOverviewMenuItem.h"
#import "RCNetworkStatusViewController.h"

//=========================================================================

@interface RCRouterOverviewMenuItem ()
@end

//=========================================================================
@implementation RCRouterOverviewMenuItem
//=========================================================================

- (void)awakeFromNib
{
    //Initialize view controller
    RCNetworkStatusViewController *controller = [[RCNetworkStatusViewController alloc] initWithNibName:@"RouterOverview" bundle:nil];
    self.controller = controller;
    
    NSView *view = controller.view;
    [self setView:view];
}

//=========================================================================
@end
//=========================================================================
