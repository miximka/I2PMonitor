//
//  RCContentView.h
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCBackgroundView.h"

typedef NS_ENUM(NSUInteger, RCContentViewColorType)
{
    RCContentViewNoColor = 0,
    RCContentViewColorGreen = 1,
    RCContentViewColorRed = 2,
};

//=========================================================================
@interface RCContentView : NSView
//=========================================================================

//Top line style type (RCContentViewColorType)
@property (nonatomic) NSNumber *type;

//=========================================================================
@end
//=========================================================================
