//
//  RCToolbar.h
//  I2PMonitor
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol RCToolbarDelegate <NSToolbarDelegate>
- (BOOL)willSelectItemWithIdentifier:(NSString *)itemIdentifier;
@end

//=========================================================================
@interface RCToolbar : NSToolbar
//=========================================================================

//=========================================================================
@end
//=========================================================================
