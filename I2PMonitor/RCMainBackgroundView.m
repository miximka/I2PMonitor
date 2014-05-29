//
//  RCBackgroundView.m
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCMainBackgroundView.h"

//=========================================================================

@interface RCMainBackgroundView ()
@property (nonatomic) NSColor *pattern;
@end

//=========================================================================
@implementation RCMainBackgroundView
//=========================================================================

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setWantsLayer:YES];
        self.pattern = [NSColor colorWithPatternImage:[NSImage imageNamed:@"micro_carbon"]];
    }
    return self;
}

//=========================================================================

- (void)drawRect:(NSRect)dirtyRect
{
    //Draw pattern
    [self.pattern setFill];
    NSRectFill(dirtyRect);
    
    //Draw white circle gradient on the top right corner
    NSColor *startColor = [NSColor colorWithCalibratedWhite:1.0 alpha:0.3];
    NSColor *endColor = [NSColor colorWithCalibratedWhite:1.0 alpha:0.0];
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
    [gradient drawInRect:self.bounds relativeCenterPosition:NSMakePoint(0.8, 0.8)];
}

//=========================================================================
@end
//=========================================================================
