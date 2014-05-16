//
//  RCArrowAnimation.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCArrowAnimation.h"

#define SHIFT_VALUE 30 //Points

//=========================================================================

@interface RCArrowAnimation ()
@property (assign, nonatomic) NSPoint startPosition;
@end

//=========================================================================
@implementation RCArrowAnimation
//=========================================================================

- (void)dealloc
{
    [self setPanel:nil];
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)startAnimation
{
    [self setStartPosition:[_panel frame].origin];
    [super startAnimation];
}

//=========================================================================

- (void)setCurrentProgress:(NSAnimationProgress)progress
{
	[super setCurrentProgress:progress];
 
    //Calculate new position
    CGFloat yPositionAtZero = _startPosition.y;
    
    CGFloat delta = SHIFT_VALUE * self.currentValue;
    if (self.moveDirectionUp)
    {
        delta = -delta;
    }
    
    CGFloat currentY = yPositionAtZero - delta;
    
    //Move panel
	NSPoint newPosition = NSMakePoint(_startPosition.x, currentY);
	[self.panel setFrameOrigin:newPosition];
}

//=========================================================================
@end
//=========================================================================
