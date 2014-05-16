//
//  RCAppDelegate.h
//  I2PRemoteControl
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RCMenu;

//=========================================================================
@interface RCAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>
//=========================================================================

@property (assign, nonatomic) IBOutlet NSWindow *window;
@property (assign, nonatomic) IBOutlet RCMenu *statusBarMenu;
@property (assign, nonatomic) IBOutlet NSPanel *arrowPanel;

- (IBAction)shutdown:(id)sender;
- (IBAction)restart:(id)sender;
- (IBAction)openPreferences:(id)sender;
- (IBAction)quit:(id)sender;

//=========================================================================
@end
//=========================================================================
