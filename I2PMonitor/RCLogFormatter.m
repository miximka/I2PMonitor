//
//  RCLogFormatter.m
//  I2PMonitor
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCLogFormatter.h"

//=========================================================================
@implementation RCLogFormatter
//=========================================================================

- (id)init
{
    self = [super init];
    if (self)
    {
        dateFormatString = @"yyyy/MM/dd HH:mm:ss:SSS";
        appName = [[NSProcessInfo processInfo] processName];
        processID = [NSString stringWithFormat:@"%i", (int)getpid()];
    }
    return self;
}

//=========================================================================

- (NSString *)stringFromDate:(NSDate *)date
{
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    
    if (loggerCount <= 1)
    {
        // Single-threaded mode.
        
        if (threadUnsafeDateFormatter == nil)
        {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [threadUnsafeDateFormatter setDateFormat:dateFormatString];
        }
        
        return [threadUnsafeDateFormatter stringFromDate:date];
    }
    else
    {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [dateFormatter setDateFormat:dateFormatString];
            
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}

//=========================================================================

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *logLevel = nil;
    
    switch (logMessage->logFlag)
    {
        case LOG_FLAG_ERROR : logLevel = @"Error"; break;
        case LOG_FLAG_WARN  : logLevel = @"Warning"; break;
        case LOG_FLAG_DEBUG : logLevel = @"Debug"; break;
        default             : break;
    }
    
    NSString *logLevelStr = @"";
    if (logLevel != nil)
    {
        logLevelStr = [NSString stringWithFormat:@"[%@] ", logLevel];
    }

    NSString *dateStr = [self stringFromDate:[NSDate date]];
    NSString *str = [NSString stringWithFormat:@"%@ %@[%@:%x] %@%@", dateStr, appName, processID, logMessage->machThreadID, logLevelStr, logMessage->logMsg];

    return str;
}

//=========================================================================

- (void)didAddToLogger:(id <DDLogger>)logger
{
    OSAtomicIncrement32(&atomicLoggerCount);
}

//=========================================================================

- (void)willRemoveFromLogger:(id <DDLogger>)logger
{
    OSAtomicDecrement32(&atomicLoggerCount);
}

//=========================================================================
@end
//=========================================================================
