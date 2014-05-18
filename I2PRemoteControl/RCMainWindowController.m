//
//  RCMainWindowController.m
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCMainWindowController.h"
#import "RCMainViewController.h"

//=========================================================================

@interface RCMainWindowController ()
@property (nonatomic) RCMainViewController *mainViewController;
@end

//=========================================================================
@implementation RCMainWindowController
//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)setupViews
{
    NSView *contentHolderView = self.contentHolderView;
    
    RCMainViewController *controller = [[RCMainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    self.mainViewController = controller;
    
    NSView *view = controller.view;
    [view setFrame:NSMakeRect(0, 0, contentHolderView.bounds.size.width, contentHolderView.bounds.size.height)];
    [view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    [contentHolderView addSubview:view];
}

//=========================================================================

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    
    [self.mainViewController windowWillShow];
}

//=========================================================================
#pragma mark NSWindowDelegate
//=========================================================================

- (void)windowWillClose:(NSNotification *)notification
{
    DDLogInfo(@"Close");
    [self.mainViewController windowWillClose];
}

//=========================================================================
@end
//=========================================================================
