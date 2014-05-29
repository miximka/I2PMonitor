//
//  RCToolbar.m
//  I2PMonitor
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCToolbar.h"

//=========================================================================
@implementation RCToolbar
//=========================================================================

- (void) setSelectedItemIdentifier:(NSString *)itemIdentifier
{
	if ([(id<RCToolbarDelegate>)[self delegate] willSelectItemWithIdentifier:itemIdentifier])
	{
		[super setSelectedItemIdentifier:itemIdentifier];
	}
}

//=========================================================================
@end
//=========================================================================
