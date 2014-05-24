//
//  RCAlertView.h
//  I2PRemoteControl
//
//  Created by miximka on 24/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================
@interface RCAlertView : NSView
//=========================================================================

@property (nonatomic) IBOutlet NSImageView *imageView;
@property (nonatomic) IBOutlet NSTextField *singleLineTextField;
@property (nonatomic) IBOutlet NSTextField *multiLineTextField;

- (void)setAlertStyle:(NSAlertStyle)style;
- (NSAlertStyle)alertStyle;

- (void)setMessage:(NSString *)message;
- (NSString *)message;

//=========================================================================
@end
//=========================================================================
