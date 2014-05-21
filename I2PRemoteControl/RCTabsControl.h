//
//  RCTabsControl.h
//  I2PRemoteControl
//
//  Created by miximka on 21/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================
@interface RCTabsControl : NSControl
//=========================================================================

- (void)setSegmentCount:(NSInteger)count;
- (NSInteger)segmentCount;

- (void)setSelectedSegment:(NSInteger)selectedSegment;
- (NSInteger)selectedSegment;

- (void)setLabel:(NSString *)label forSegment:(NSInteger)segment;
- (NSString *)labelForSegment:(NSInteger)segment;

- (void)setImage:(NSImage *)image forSegment:(NSInteger)segment;
- (NSImage *)imageForSegment:(NSInteger)segment;

//=========================================================================
@end
//=========================================================================
