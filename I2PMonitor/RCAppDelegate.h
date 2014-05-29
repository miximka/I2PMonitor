//
//  RCAppDelegate.h
//  I2PMonitor
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================
@interface RCAppDelegate : NSObject <NSApplicationDelegate>
//=========================================================================

@property (assign, nonatomic) IBOutlet NSPanel *arrowPanel;
@property (assign, nonatomic) IBOutlet NSMenu *menu;

- (IBAction)openPreferences:(id)sender;

//=========================================================================
@end
//=========================================================================
