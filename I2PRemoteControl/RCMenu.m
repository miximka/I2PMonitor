//
//  RCMenu.m
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCMenu.h"
#import "RCMenuItem.h"
#import "RCViewController.h"

//=========================================================================
@implementation RCMenu
//=========================================================================

- (void)setEnableUpdates:(BOOL)enableUpdates
{
    if (_enableUpdates != enableUpdates)
    {
        _enableUpdates = enableUpdates;
        
        for (NSMenuItem *item in self.itemArray)
        {
            if (![item isKindOfClass:[RCMenuItem class]])
                continue;
            
            RCViewController *controller = ((RCMenuItem *)item).controller;
            
            if (enableUpdates)
            {
                [controller startUpdating];
            }
            else
            {
                [controller stopUpdating];
            }
        }
    }
}

//=========================================================================
@end
//=========================================================================
