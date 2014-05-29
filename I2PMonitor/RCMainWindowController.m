//
//  RCMainWindowController.m
//  I2PMonitor
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
    NSView *containerView = self.contentContainerView;
    
    RCMainViewController *controller = [[RCMainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    [controller setDelegate:self];
    self.mainViewController = controller;
    
    NSView *controllerView = controller.view;
    
    //Turn off translation of autoresiting mask as we will use constraints
    [controllerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [containerView addSubview:controllerView];
    
    //Add constraints to let controller view match the size of the superview
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[controllerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(controllerView)]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[controllerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(controllerView)]];
}

//=========================================================================

- (void)showWindow:(id)sender
{
    //Window is about to open, notify main view controller to update UI
    [self.mainViewController windowWillShow];

    //Open window
    [super showWindow:sender];
    
    //Start periodically updating UI
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

- (void)mainViewControllerShouldDismissWindow:(RCMainViewController *)controller
{
    [self.delegate mainWindowControllerShouldDismissWindow:self];
}

//=========================================================================
@end
//=========================================================================
