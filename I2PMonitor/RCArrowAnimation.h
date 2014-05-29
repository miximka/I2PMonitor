//
//  RCArrowAnimation.h
//  I2PMonitor
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================
@interface RCArrowAnimation : NSAnimation
{
    NSPanel     *_panel;
    NSPoint     _startPosition;
    BOOL        _moveDirectionUp;
}

@property (nonatomic) BOOL moveDirectionUp;
@property (nonatomic) NSPanel *panel;

//=========================================================================
@end
//=========================================================================
