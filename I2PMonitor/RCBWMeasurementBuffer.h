//
//  RCBWMeasurementBuffer.h
//  I2PMonitor
//
//  Created by miximka on 19/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCBWMeasurement;

//=========================================================================
@interface RCBWMeasurementBuffer : NSObject
//=========================================================================

- (instancetype)initWithCapacity:(NSUInteger)capacity;

@property (nonatomic, readonly) NSUInteger capacity;

- (NSUInteger)count;
- (RCBWMeasurement *)objectAtIndex:(NSUInteger)index;
- (RCBWMeasurement *)lastObject;

/**
    Adds next measurement to buffer.
    If the buffer is full, the oldest element (i.e. the one with index 0) will be thrown away.
 */
- (void)addObject:(RCBWMeasurement *)object;

@property (nonatomic, readonly) CGFloat maxInbound; //Bps
@property (nonatomic, readonly) CGFloat maxOutbound; //Bps

//=========================================================================
@end
//=========================================================================
