//
//  RCPrefsGeneralViewController.m
//  I2PRemoteControl
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCPrefsGeneralViewController.h"
#import "RCPreferences.h"


//=========================================================================
@implementation RCPrefsGeneralViewController
//=========================================================================

- (IBAction)startOnSystemStartup:(id)sender
{
    NSInteger state = [self.startOnSystemStartupButton state];
    [RCPrefs setStartOnSystemStartup:state];
}

//=========================================================================

- (IBAction)resetToDefaults:(id)sender
{
    [RCPrefs removeObjectForKey:PREFS_KEY_ROUTER_HOST];
    [RCPrefs removeObjectForKey:PREFS_KEY_ROUTER_PORT];
    
    [self loadDefaultValuesForHostAndPort];
}

//=========================================================================
#pragma mark Overriden methods
//=========================================================================

- (NSString *)defaultViewNibName
{
	return @"PreferencesGeneral";
}

//=========================================================================

- (void)loadDefaultValuesForHostAndPort
{
    [self.hostTextField setStringValue:[RCPrefs routerHost]];
    
    NSString *port = [NSString stringWithFormat:@"%li", [RCPrefs routerPort]];
    [self.portTextField setStringValue:port];
}

//=========================================================================

- (void)loadDefaultValues
{
	[super loadDefaultValues];
    
    [self.startOnSystemStartupButton setState:[RCPrefs startOnSystemStartup]];
    [self loadDefaultValuesForHostAndPort];
}

//=========================================================================
#pragma mark NSTextFieldDelegate
//=========================================================================

- (void)controlTextDidEndEditing:(NSNotification *)notification
{
    id object = notification.object;
    
    if (object == self.hostTextField)
    {
        //Apply changes immediately
        NSString *newHost = self.hostTextField.stringValue;
        [RCPrefs setRouterHost:newHost];
    }
    else if (object == self.portTextField)
    {
        //Apply changes immediately
        NSUInteger newPort = [self.portTextField intValue];
        [RCPrefs setRouterPort:newPort];
    }
}

//=========================================================================
@end
//=========================================================================
