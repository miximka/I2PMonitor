//
//  RCPrefsGeneralViewController.h
//  I2PMonitor
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCPrefsBaseViewController.h"

@class RCRouterManager;

//=========================================================================
@interface RCPrefsGeneralViewController : RCPrefsBaseViewController
//=========================================================================

@property (nonatomic, assign) IBOutlet NSButton *startOnSystemStartupButton;
@property (nonatomic, assign) IBOutlet NSTextField *hostTextField;
@property (nonatomic, assign) IBOutlet NSTextField *portTextField;
@property (nonatomic, assign) IBOutlet NSImageView *connectionStatusImageView;
@property (nonatomic, assign) IBOutlet NSMatrix *notificationsMatrix;

@property (nonatomic) RCRouterManager *routerManager;

- (IBAction)startOnSystemStartup:(id)sender;
- (IBAction)resetToDefaults:(id)sender;
- (IBAction)setShowRouterNotificationType:(id)sender;

//=========================================================================
@end
//=========================================================================
