//
//  RCMainViewController.m
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCMainViewController.h"
#import "RCNetworkStatusViewController.h"

//=========================================================================

@interface RCMainViewController ()
@property (nonatomic) RCNetworkStatusViewController *networkViewController;
@end

//=========================================================================
@implementation RCMainViewController
//=========================================================================

- (void)switchToControllerView:(RCViewController *)controller
{
    NSView *contentView = [self contentView];
    
    //Remove previous view
    for (NSView *each in contentView.subviews)
    {
        [each removeFromSuperview];
    }
    
    NSView *view = controller.view;
    [view setFrame:NSMakeRect(0, contentView.bounds.size.height - view.frame.size.height, view.frame.size.width, view.frame.size.height)];
    
    [contentView addSubview:view];
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)awakeFromNib
{
    RCNetworkStatusViewController *networkController = [[RCNetworkStatusViewController alloc] initWithNibName:@"NetworkStatus" bundle:nil];
    self.networkViewController = networkController;
    
    [self switchToControllerView:networkController];
}

//=========================================================================
@end
//=========================================================================
