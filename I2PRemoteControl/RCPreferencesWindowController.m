//
//  RCPreferencesWindowController.m
//  I2PRemoteControl
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCPreferencesWindowController.h"
#import "RCPrefsGeneralViewController.h"

//=========================================================================

#define PREFS_TAB_OP_CONTEXT_OP_CODE	@"OperationCode"
#define PREFS_TAB_OP_CONTEXT_OP_PARAM	@"OperationParam"

enum
{
	kPrefsTabOpCodeClose	= 0,
	kPrefsTabOpCodeSwitch,
};

//=========================================================================
@implementation RCPreferencesWindowController
//=========================================================================

- (RCPrefsGeneralViewController *) allocGeneralPrefsController
{
	RCPrefsGeneralViewController *ctrl = [[RCPrefsGeneralViewController alloc] init];
	return ctrl;
}

//=========================================================================

- (RCPrefsGeneralViewController *) generalPrefsCtrl
{
	if (_generalPrefsCtrl == nil)
	{
		//Initialize general prefs controller
		_generalPrefsCtrl = [self allocGeneralPrefsController];
		[_generalPrefsCtrl setDelegate:self];
	}

	return _generalPrefsCtrl;
}

//=========================================================================

- (RCPrefsBaseViewController *)prefsControllerWithTag:(NSInteger)aTag
{
	RCPrefsBaseViewController *ctrl = nil;
	
	switch (aTag)
	{
		case 0:
			ctrl = [self generalPrefsCtrl];
			break;
		default:
			break;
	}
	
	return ctrl;
}

//=========================================================================

- (RCPrefsBaseViewController *)controllerForItemWithIdentifier:(NSString *)itemIdentifier
{
	NSInteger tag = 0;
	
	for (NSToolbarItem *eachItem in [_toolbar items])
	{
		if ([[eachItem itemIdentifier] isEqualToString:itemIdentifier])
		{
			tag = [eachItem tag];
		}
	}
	
	return [self prefsControllerWithTag:tag];
}

//=========================================================================

- (RCPrefsBaseViewController *)currentSelectedController
{
	return [self controllerForItemWithIdentifier:[_toolbar selectedItemIdentifier]];
}

//=========================================================================
#pragma mark Overriden methods
//=========================================================================

- (void)showWindow:(id)sender
{
	//Load nib if not yet
    if (![self.window isVisible] && ![self.window isMiniaturized])
    {
        //Open window in the center of the screen
        [self.window center];
    }
	
	NSString *currSelectedItemIdent = [_toolbar selectedItemIdentifier];
	
	if (!currSelectedItemIdent)
	{
		//No item currently selected, select default (General) one
		NSToolbarItem *firstItem = [[_toolbar items] objectAtIndex:0];
		[_toolbar setSelectedItemIdentifier:[firstItem itemIdentifier]];
	}
	
	[super showWindow:sender];

    //Prevent any of the editable fields from being auto-edited when window opens
    [self.window makeFirstResponder:nil];

	if (![NSApp isActive])
	{
		//Application is not active. We need to activate application because otherwize the preferences window
		//will not become key if it was already open but hided by other application's window
		[NSApp activateIgnoringOtherApps:YES];
	}
}

//=========================================================================
#pragma mark Toolbar target validation
//=========================================================================

-(BOOL)validateToolbarItem:(NSToolbarItem *)toolbarItem
{
	return YES;
}

//=========================================================================
#pragma mark -
//=========================================================================

- (void)updateMainWindowSizeWithCtrlView:(NSRect)newCtrlViewRect animate:(BOOL)shouldAnimate
{
	//Compute relative size change
	NSRect containerViewFrame = [_prefContainerView frame];
	CGFloat dx = newCtrlViewRect.size.width - containerViewFrame.size.width;
	CGFloat dy = newCtrlViewRect.size.height - containerViewFrame.size.height;
	
	//Adapt size of main view accordingly (container view size would be changed automaticly)
	NSRect newWindowFrame = [[self window] frame];
	newWindowFrame.size.height += dy;
	newWindowFrame.size.width += dx;
	newWindowFrame.origin.y -= dy;
	
	[[self window] setFrame:newWindowFrame display:YES animate:shouldAnimate];
}

//=========================================================================

- (void)switchToPrefsWithController:(RCPrefsBaseViewController *)aCtrl
{
	//Load default values before switching to new view
	[aCtrl loadDefaultValues];

	NSView *currentView = [[_prefContainerView subviews] firstObject];
	NSView *newView = [aCtrl view];
	
	//Now time to replace old view with new one
	//But before we will reset autosizing view options to prevent view from distortion when user switches back to this view (consider app filter autoresizing animation when on/off app filter)
	NSUInteger newMask = NSViewMaxXMargin | NSViewMaxYMargin;
	
	[currentView setAutoresizingMask:newMask];
	[currentView removeFromSuperview];
	
	[_prefContainerView addSubview:newView];
	
	//Animated size update
	[self updateMainWindowSizeWithCtrlView:[newView frame] animate:YES];	
}

//=========================================================================

- (IBAction) switchToGeneralPrefs:(id)sender
{
}

//=========================================================================

- (void)closeWindowImmediately
{
	[self close];
	
	//Revert changes on current controller, if any
	RCPrefsBaseViewController *currentCtrl = [self controllerForItemWithIdentifier:[_toolbar selectedItemIdentifier]];
	
	[currentCtrl setEdited:NO];
	[currentCtrl loadDefaultValues];
}

//=========================================================================

- (void) performOperationWithCode:(int)aCode param:(NSString *)aParam
{
	switch (aCode)
	{
		case kPrefsTabOpCodeClose:
			//Perform close
			[self closeWindowImmediately];
			break;

		case kPrefsTabOpCodeSwitch:
			//Perform switch
			[_toolbar setSelectedItemIdentifier:aParam];
			
			break;
			
		default:
			break;
	}
}

//=========================================================================
#pragma mark CPPrefsDelegate implementation
//=========================================================================

- (void)prefsEditedStatusDidChange
{
	RCPrefsBaseViewController *currentCtrl = [self currentSelectedController];
	
	BOOL edited = [currentCtrl isEdited];
	[[self window] setDocumentEdited:edited];
}

//=========================================================================

- (void)responseTabWillClose:(BOOL)closeAllowed context:(void *)contextInfo
{
	if (closeAllowed && _closingTabContextInfo == (__bridge NSDictionary *)(contextInfo))
	{
		//Operation is allowed to perform now
		int operationCode = [[_closingTabContextInfo objectForKey:PREFS_TAB_OP_CONTEXT_OP_CODE] intValue];
		NSString *param = [_closingTabContextInfo objectForKey:PREFS_TAB_OP_CONTEXT_OP_PARAM];
		
		[self performOperationWithCode:operationCode param:param];
	}
}

//=========================================================================

- (void)controllerChangeViewSize:(RCPrefsBaseViewController *)ctrl toNewSize:(NSSize)aSize
{
	NSView *view = [ctrl view];
	
	NSRect frame = [view frame];
	frame.size = aSize;
	
	//Pin down the view so it resizes automatically with its superview
	NSUInteger mask = NSViewMinXMargin | NSViewWidthSizable | NSViewMaxXMargin | NSViewMinYMargin | NSViewHeightSizable | NSViewMaxYMargin;
	[view setAutoresizingMask:mask];
	
	[self updateMainWindowSizeWithCtrlView:frame animate:YES];
}

//=========================================================================
#pragma mark NSWindowDelegate implementation
//=========================================================================

- (BOOL)windowShouldClose:(id)sender
{
    //Resign first responder of any view
    BOOL success = [self.window makeFirstResponder:nil];
    
    if (!success)
        return NO;
    
	RCPrefsBaseViewController *currentCtrl = [self currentSelectedController];
	
	NSDictionary *contextInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithInt:kPrefsTabOpCodeClose], PREFS_TAB_OP_CONTEXT_OP_CODE,
								 nil];
	
	BOOL closeImmediately = [currentCtrl tabWillClose:(__bridge void *)(contextInfo)];
	
	if (!closeImmediately)
	{
		//Remember for later use
		_closingTabContextInfo = contextInfo;
	}
	
	return closeImmediately;
}

//=========================================================================
#pragma mark CPToolbarDelegate implementation
//=========================================================================

- (BOOL)willSelectItemWithIdentifier:(NSString *)itemIdentifier
{
	RCPrefsBaseViewController *currentCtrl = [self currentSelectedController];
	
	NSDictionary *contextInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithInt:kPrefsTabOpCodeSwitch], PREFS_TAB_OP_CONTEXT_OP_CODE,
								 itemIdentifier, PREFS_TAB_OP_CONTEXT_OP_PARAM,
								 nil];
	
	BOOL switchImmediately = [currentCtrl tabWillClose:(__bridge void *)(contextInfo)];

	//Switch is currently not allowed (e.g. because user needs to accept it first)
	if (!switchImmediately)
	{
		//Remember for later use
		_closingTabContextInfo = contextInfo;
	}
	else
	{
		//Switch is allowed, get corresponded controller for desired tab identifier
		RCPrefsBaseViewController *newCtrl = [self controllerForItemWithIdentifier:itemIdentifier];
		
		//Perform switch
		[self switchToPrefsWithController:newCtrl];
	}
	
	return switchImmediately;
}

//=========================================================================
@end
//=========================================================================
