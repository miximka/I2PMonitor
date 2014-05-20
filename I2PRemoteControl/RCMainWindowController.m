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

@interface RCMainWindowController () <RCMainViewControllerDelegate>
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
    [controller setDelegate:self];
    self.mainViewController = controller;
    
    NSView *controllerView = controller.view;

    //Resize window to match the initial size of the main controller view
    CGFloat widthDelta = controllerView.frame.size.width - contentHolderView.frame.size.width;
    CGFloat heightDelta = controllerView.frame.size.height - contentHolderView.frame.size.height;
    
    NSRect windowFrame = self.window.frame;
    windowFrame.size.width += widthDelta;
    windowFrame.size.height += heightDelta;
    windowFrame.origin.y -= heightDelta;
    [self.window setFrame:windowFrame display:NO];

    //Add controller view to view hierarchy
    [controllerView setFrame:NSMakeRect(0, 0, controllerView.frame.size.width, contentHolderView.frame.size.height)];
    
    [controllerView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [contentHolderView addSubview:controllerView];

    //Resize window again to match the possibly changed size of the main view
    [self resizeWindowIfNeededDisplay:NO];
}

//=========================================================================

- (void)resizeWindowIfNeededDisplay:(BOOL)display
{
    NSSize preferredViewSize = [self.mainViewController preferredViewSize];
    
    CGFloat widthDelta = preferredViewSize.width - self.contentHolderView.frame.size.width;
    CGFloat heightDelta = preferredViewSize.height - self.contentHolderView.frame.size.height;
    
    NSRect windowFrame = self.window.frame;
    windowFrame.size.width += widthDelta;
    windowFrame.size.height += heightDelta;
    windowFrame.origin.y -= heightDelta;
    
    [self.window setFrame:windowFrame display:display];
}

//=========================================================================

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    
    //Window is about to open, start updating UI
    [self.mainViewController startUpdating];
}

//=========================================================================
#pragma mark NSWindowDelegate
//=========================================================================

- (void)windowWillClose:(NSNotification *)notification
{
    //Window is about to close, stop updating UI
    [self.mainViewController stopUpdating];
}

//=========================================================================
#pragma mark RCMainViewControllerDelegate
//=========================================================================

- (void)mainViewControllerOpenPreferences:(RCMainViewController *)controller
{
}

//=========================================================================
@end
//=========================================================================
