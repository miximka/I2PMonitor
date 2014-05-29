//
//  RCTabsControl.m
//  I2PMonitor
//
//  Created by miximka on 21/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCTabsControl.h"
#import "RCTabsControlCell.h"

//=========================================================================
@implementation RCTabsControl
//=========================================================================

- (id)initWithFrame:(NSRect)frame
{
    [RCTabsControl setCellClass:[RCTabsControlCell class]];
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code here.
        
    }
    return self;
}

//=========================================================================

- (void)setSegmentCount:(NSInteger)count
{
    [self.cell setSegmentCount:count];
}

//=========================================================================

- (NSInteger)segmentCount
{
    return [self.cell segmentCount];
}

//=========================================================================

- (void)setSelectedSegment:(NSInteger)selectedSegment
{
    [self.cell setSelectedSegment:selectedSegment];
}

//=========================================================================

- (NSInteger)selectedSegment
{
    return [self.cell selectedSegment];
}

//=========================================================================

- (void)setLabel:(NSString *)label forSegment:(NSInteger)segment
{
    [self.cell setLabel:label forSegment:segment];
}

//=========================================================================

- (NSString *)labelForSegment:(NSInteger)segment
{
    return [self.cell labelForSegment:segment];
}

//=========================================================================

- (void)setImage:(NSImage *)image forSegment:(NSInteger)segment
{
    [self.cell setImage:image forSegment:segment];
}

//=========================================================================

- (NSImage *)imageForSegment:(NSInteger)segment
{
    return [self.cell imageForSegment:segment];
}

//=========================================================================
@end
//=========================================================================
