//
//  RCClickableTextField.h
//  I2PMonitor
//
//  Created by miximka on 28/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RCLinkTextField;

@protocol RCLinkTextFieldDelegate <NSTextFieldDelegate>
- (void)clickableTextFieldMouseDown:(RCLinkTextField *)textField;
@end

//=========================================================================
@interface RCLinkTextField : NSTextField
//=========================================================================

- (id<RCLinkTextFieldDelegate>)delegate;
- (void)setDelegate:(id<NSTextFieldDelegate>)anObject;

//=========================================================================
@end
//=========================================================================
