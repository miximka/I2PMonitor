//
//  RCBWMeasurement.m
//  I2PRemoteControl
//
//  Created by miximka on 19/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCBWMeasurement.h"

//=========================================================================
@implementation RCBWMeasurement
//=========================================================================

- (instancetype)initWithDate:(NSDate *)date inbound:(CGFloat)inbound outbound:(CGFloat)outbound
{
    self = [super init];
    if (self)
    {
        _date = date;
        _inbound = inbound;
        _outbound = outbound;
    }
    return self;
}

//=========================================================================

+ (instancetype)measurementWithDate:(NSDate *)date inbound:(CGFloat)inbound outbound:(CGFloat)outbound
{
    return [[self alloc] initWithDate:date inbound:inbound outbound:outbound];
}

//=========================================================================
@end
//=========================================================================
