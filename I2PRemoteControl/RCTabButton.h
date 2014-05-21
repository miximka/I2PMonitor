//
//  RCTabButton.h
//  I2PRemoteControl
//
//  Created by miximka on 21/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RCContentView.h"

//=========================================================================
@interface RCTabButton : NSButton
//=========================================================================

- (RCContentViewColorType)colorType;
- (void)setColorType:(RCContentViewColorType)colorType;

//=========================================================================
@end
//=========================================================================
