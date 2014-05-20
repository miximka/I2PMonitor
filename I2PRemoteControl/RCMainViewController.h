//
//  RCMainViewController.h
//  I2PRemoteControl
//
//  Created by miximka on 18/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================

@class RCMainViewController;

@protocol RCMainViewControllerDelegate <NSObject>
- (void)mainViewControllerDidResizeView:(RCMainViewController *)controller;
@end

//=========================================================================
@interface RCMainViewController : NSViewController
//=========================================================================

@property (nonatomic, weak) id<RCMainViewControllerDelegate> delegate;

@property (nonatomic) IBOutlet NSTextField *hostTextField;
@property (nonatomic) IBOutlet NSTextField *versionTextField;
@property (nonatomic) IBOutlet NSTextField *uptimeTextField;
@property (nonatomic) IBOutlet NSView *contentView;
@property (nonatomic) IBOutlet NSButton *networkButton;
@property (nonatomic) IBOutlet NSButton *peersButton;
@property (nonatomic) IBOutlet NSButton *controlButton;

- (void)startUpdating;
- (void)stopUpdating;

- (IBAction)showNetworkInfoView:(id)sender;
- (IBAction)showPeersView:(id)sender;
- (IBAction)showControlView:(id)sender;

- (NSSize)preferredViewSize;

//=========================================================================
#pragma mark Unit Tests
//=========================================================================

- (NSString *)uptimeStringForInterval:(NSTimeInterval)interval;

//=========================================================================
@end
//=========================================================================
