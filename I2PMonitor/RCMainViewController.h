//
//  RCMainViewController.h
//  I2PMonitor
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================

@class RCMainViewController;
@class RCTabsControl;
@class RCNotificationView;
@class RCLinkTextField;

@protocol RCMainViewControllerDelegate <NSObject>
- (void)mainViewControllerShouldDismissWindow:(RCMainViewController *)controller;
@end

//=========================================================================
@interface RCMainViewController : NSViewController
//=========================================================================

//Outlets
@property (nonatomic) IBOutlet NSView *headerView;
@property (nonatomic) IBOutlet RCLinkTextField *headerTitleTextField;
@property (nonatomic) IBOutlet RCNotificationView *notificationView;
@property (nonatomic) IBOutlet NSTextField *hostTextField;
@property (nonatomic) IBOutlet NSTextField *versionTextField;
@property (nonatomic) IBOutlet NSTextField *uptimeTextField;
@property (nonatomic) IBOutlet NSView *contentContainerView;
@property (nonatomic) IBOutlet NSView *tabsControlPlaceholderView;
@property (nonatomic) IBOutlet RCTabsControl *tabsControl;
@property (nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *contentContainerViewHeightConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *contentContainerViewWidthConstraint;

//Delegate
@property (nonatomic, weak) id<RCMainViewControllerDelegate> delegate;

/**
    Called by window controller just before show the window
 */
- (void)windowWillShow;

/**
    Starts periodic UI updates
 */
- (void)startUpdating;
- (void)stopUpdating;

/**
    Called when tabs control is clicked
 */
- (IBAction)tabsControlAction:(id)sender;

//=========================================================================
#pragma mark Unit Tests
//=========================================================================

- (NSString *)uptimeStringForInterval:(NSTimeInterval)interval;

//=========================================================================
@end
//=========================================================================
