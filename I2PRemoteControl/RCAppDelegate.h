//
//  RCAppDelegate.h
//  I2PRemoteControl
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================
@interface RCAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>
//=========================================================================

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusBarMenu;

- (IBAction)shutdown:(id)sender;
- (IBAction)restart:(id)sender;

//=========================================================================
#pragma mark Unit Tests
//=========================================================================

- (NSString *)uptimeStringForInterval:(NSTimeInterval)interval;

//=========================================================================
@end
//=========================================================================
