//
//  RCPreferencesWindowController.h
//  I2PRemoteControl
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RCPrefsBaseViewController.h"

@class RCPrefsGeneralViewController;
@class RCRouterManager;

//=========================================================================
@interface RCPreferencesWindowController : NSWindowController <RCPrefsViewControllerDelegate>
{
	IBOutlet NSToolbar              *_toolbar;
	IBOutlet NSView                 *_prefContainerView;
	RCPrefsGeneralViewController    *_generalPrefsCtrl;
	NSDictionary                    *_closingTabContextInfo;
}

@property (nonatomic) RCRouterManager *routerManager;

//=========================================================================
@end
//=========================================================================
