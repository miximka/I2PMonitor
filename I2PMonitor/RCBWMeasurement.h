//
//  RCBWMeasurement.h
//  I2PMonitor
//
//  Created by miximka on 19/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================
@interface RCBWMeasurement : NSObject
//=========================================================================

+ (instancetype)measurementWithDate:(NSDate *)date inbound:(CGFloat)inbound outbound:(CGFloat)outbound;

@property (nonatomic) NSDate *date;
@property (nonatomic) CGFloat inbound; //Bps
@property (nonatomic) CGFloat outbound; //Bps

//=========================================================================
@end
//=========================================================================
