//
//  RCContentView.h
//  I2PMonitor
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCMainBackgroundView.h"

#define GREEN_GRADIENT_START_COLOR  [NSColor colorWithCalibratedRed:43.0/255.0 green:254.0/255.0 blue:166.0/255.0 alpha:1.0]
#define GREEN_GRADIENT_END_COLOR    [NSColor colorWithCalibratedRed:188.0/255.0 green:254.0/255.0 blue:83.0/255.0 alpha:1.0]

#define RED_GRADIENT_START_COLOR  [NSColor colorWithCalibratedRed:252.0/255.0 green:15.0/255.0 blue:26.0/255.0 alpha:1.0]
#define RED_GRADIENT_END_COLOR    [NSColor colorWithCalibratedRed:255.0/255.0 green:205.0/255.0 blue:56.0/255.0 alpha:1.0]

#define VIOLETT_GRADIENT_START_COLOR  [NSColor colorWithCalibratedRed:248.0/255.0 green:67.0/255.0 blue:245.0/255.0 alpha:1.0]
#define VIOLETT_GRADIENT_END_COLOR    [NSColor colorWithCalibratedRed:252.0/255.0 green:88.0/255.0 blue:81.0/255.0 alpha:1.0]

typedef NS_ENUM(NSUInteger, RCContentViewColorType)
{
    RCContentViewNoColor = 0,
    RCContentViewColorGreen = 1,
    RCContentViewColorRed = 2,
    RCContentViewColorViolet = 3,
};

//=========================================================================
@interface RCContentView : NSView
//=========================================================================

@property (nonatomic) RCContentViewColorType colorType;

//=========================================================================
@end
//=========================================================================
