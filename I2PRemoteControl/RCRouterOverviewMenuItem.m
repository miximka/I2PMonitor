//
//  RCMenuItem.m
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCRouterOverviewMenuItem.h"
#import "RCRouterOverviewViewController.h"

//=========================================================================

@interface RCRouterOverviewMenuItem ()
@end

//=========================================================================
@implementation RCRouterOverviewMenuItem
//=========================================================================

- (void)awakeFromNib
{
    //Initialize view controller
    RCRouterOverviewViewController *controller = [[RCRouterOverviewViewController alloc] initWithNibName:@"RouterOverview" bundle:nil];
    self.controller = controller;
    
    NSView *view = controller.view;
    [self setView:view];
}

//=========================================================================
@end
//=========================================================================
