//
//  RCLogFormatter.h
//  I2PMonitor
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================
@interface RCLogFormatter : NSObject <DDLogFormatter>
{
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
    NSString *dateFormatString;
    NSString *appName;
    NSString *processID;
}

//=========================================================================
@end
//=========================================================================
