//
//  CPPrefsBaseViewController.h
//  I2PRemoteControl
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================

@class RCPrefsBaseViewController;

@protocol RCPrefsViewControllerDelegate
- (void) prefsEditedStatusDidChange;
- (void) responseTabWillClose:(BOOL)closeAllowed context:(void *)contextInfo;
- (void) controllerChangeViewSize:(RCPrefsBaseViewController *)ctrl toNewSize:(NSSize)aSize;
@end

//=========================================================================
@interface RCPrefsBaseViewController : NSViewController
//=========================================================================

@property (nonatomic) id<RCPrefsViewControllerDelegate> delegate;

/**
	Default window nib name used if init method was used for initialization
 */
- (NSString *)defaultViewNibName;

/**
	Return YES to indicate that some prefs need to be applied before closing preferences
 */
@property (nonatomic, getter = isEdited) BOOL edited;

/**
	Apply changes made by user
 */
- (void)applyChanges;

/**
	Updates GUI with default values. Mainly used in subclasses to update GUI with defaults
 */
- (void)loadDefaultValues;

//=========================================================================
#pragma mark -
//=========================================================================

- (void)didSelectTab;

/**
	Method will be called by window controller to notify that the tab with integrated view controller is going to be closed.
	@return YES if controller allow to close tab immediately.
 */
- (BOOL)tabWillClose:(void *)contextInfo;

//=========================================================================
@end
//=========================================================================
