//
//  RCNotificationView.h
//  I2PMonitor
//
//  Created by miximka on 24/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================
@interface RCNotificationView : NSView
//=========================================================================

@property (nonatomic) IBOutlet NSImageView *imageView;
@property (nonatomic) IBOutlet NSTextField *singleLineTextField;
@property (nonatomic) IBOutlet NSTextField *multiLineTextField;

- (void)setNotificationStyle:(NSAlertStyle)style;
- (NSAlertStyle)notificationStyle;

- (void)setMessage:(NSString *)message;
- (NSString *)message;

//=========================================================================
@end
//=========================================================================
