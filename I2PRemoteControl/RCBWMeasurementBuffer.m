//
//  RCBWMeasurementBuffer.m
//  I2PRemoteControl
//
//  Created by miximka on 19/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCBWMeasurementBuffer.h"
#import "RCBWMeasurement.h"

//=========================================================================

@interface RCBWMeasurementBuffer ()
@property (nonatomic) NSMutableArray *buffer;
@property (nonatomic) NSUInteger maxInboundMeasurementIndex;
@property (nonatomic) NSUInteger maxOutboundMeasurementIndex;
@end

//=========================================================================
@implementation RCBWMeasurementBuffer
//=========================================================================

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    self = [super init];
    if (self)
    {
        _buffer = [NSMutableArray new];
        _capacity = capacity;
    }
    return self;
}

//=========================================================================

- (NSUInteger)count
{
    return self.buffer.count;
}

//=========================================================================

- (RCBWMeasurement *)objectAtIndex:(NSUInteger)index
{
    return [self.buffer objectAtIndex:index];
}

//=========================================================================

- (void)findMaxMeasurementIndexes:(NSUInteger *)inboundRef outbound:(NSUInteger *)outboundRef
{
    NSUInteger inboundIndex = NSNotFound;
    NSUInteger outboundIndex = NSNotFound;

    if (_buffer.count > 0)
    {
        CGFloat inboundMax = 0;
        CGFloat outboundMax = 0;
        
        for (NSUInteger i = 0; i < _buffer.count; i++)
        {
            RCBWMeasurement *measurement = [_buffer objectAtIndex:i];
            
            if (inboundMax <= measurement.inbound)
            {
                inboundIndex = i;
            }
            
            if (outboundMax <= measurement.outbound)
            {
                outboundIndex = i;
            }
        }
    }

    if (inboundRef != nil)
        *inboundRef = inboundIndex;
    
    if (outboundRef != nil)
        *outboundRef = outboundIndex;
}

//=========================================================================

- (void)removeFirstObject
{
    //Remove oldest element
    [_buffer removeObjectAtIndex:0];

    if (_maxInboundMeasurementIndex == 0 || _maxOutboundMeasurementIndex == 0)
    {
        //Max inboud/outbound element has been removed, we have to find new max elements
        [self findMaxMeasurementIndexes:&_maxInboundMeasurementIndex outbound:&_maxOutboundMeasurementIndex];
        
        _maxInbound = [[_buffer objectAtIndex:_maxInboundMeasurementIndex] inbound];
        _maxOutbound = [[_buffer objectAtIndex:_maxOutboundMeasurementIndex] inbound];
    }
}

//=========================================================================

- (void)addObject:(RCBWMeasurement *)object
{
    if (_buffer.count >= _capacity)
    {
        [self removeFirstObject];
    }
    
    [self.buffer addObject:object];
    
    //Update max inbound value
    CGFloat value = object.inbound;
    if (_maxInbound <= value)
    {
        _maxInboundMeasurementIndex = _buffer.count - 1;
        _maxInbound = value;
    }
    
    //Update max outbound value
    value = object.outbound;
    if (_maxOutbound <= value)
    {
        _maxOutboundMeasurementIndex = _buffer.count - 1;
        _maxOutbound = value;
    }
}

//=========================================================================
@end
//=========================================================================
