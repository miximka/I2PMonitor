//
//  RCNotificationView.m
//  I2PRemoteControl
//
//  Created by miximka on 24/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCNotificationView.h"


//=========================================================================

@interface RCNotificationView ()
@property (nonatomic) NSAlertStyle style;
@property (nonatomic) NSString *stringValue;
@end

//=========================================================================
@implementation RCNotificationView
//=========================================================================

- (void)setNotificationStyle:(NSAlertStyle)style
{
    _style = style;

    NSString *imageName = @"NSInfo";
    if (style != NSInformationalAlertStyle)
    {
        imageName = @"NSCaution";
    }
    
    [self.imageView setImage:[NSImage imageNamed:imageName]];
}

//=========================================================================

- (NSAlertStyle)notificationStyle
{
    return _style;
}

//=========================================================================

- (NSString *)message
{
    return _stringValue;
}

//=========================================================================

- (void)setMessage:(NSString *)message
{
    _stringValue = message;
    
    if (message == nil)
        message = @"";
    
    //Check whether the string fits into one line
    NSDictionary *attributes = @{ NSFontAttributeName : self.singleLineTextField.font };
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:message attributes:attributes];
    
    NSSize textFieldSize = self.singleLineTextField.frame.size;
    NSRect boundingRect = [attributedStr boundingRectWithSize:textFieldSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine];
    
    //Decide to use single or multiline text field
    BOOL fitsIntoOneLine = textFieldSize.height >= boundingRect.size.height;
    
    [self.singleLineTextField setHidden:!fitsIntoOneLine];
    [self.multiLineTextField setHidden:fitsIntoOneLine];
    
    [self.singleLineTextField setStringValue:message];
    [self.multiLineTextField setStringValue:message];
}

//=========================================================================
@end
//=========================================================================
