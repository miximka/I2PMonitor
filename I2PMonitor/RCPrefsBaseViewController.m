//
//  CPPrefsBaseViewController.m
//  I2PRemoteControl
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCPrefsBaseViewController.h"


//=========================================================================
@implementation RCPrefsBaseViewController
//=========================================================================

- (id)init
{
	self = [super initWithNibName:[self defaultViewNibName] bundle:nil];
	if (self != nil)
	{
		_edited = NO;
	}
	
	//Load view
	[self loadView];
	
	return self;
}

//=========================================================================

- (NSString *)defaultViewNibName
{
	NSAssert(0, @"Override me");
	return nil;
}

//=========================================================================

- (void)setEdited:(BOOL)flag
{
	_edited = flag;
	
	//Notify delegate
	[self.delegate prefsEditedStatusDidChange];
}

//=========================================================================

- (void)didSelectTab
{
}

//=========================================================================

- (BOOL)tabWillClose:(void *)contextInfo
{
	return YES;
}

//=========================================================================

- (void)applyChanges
{
	[self setEdited:NO];
}

//=========================================================================

- (void)loadDefaultValues
{
}

//=========================================================================
#pragma mark Overriden methods
//=========================================================================

- (void)awakeFromNib
{
	[self loadDefaultValues];
}

//=========================================================================
@end
//=========================================================================
