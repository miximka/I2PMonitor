//
//  NSFileManager+SupportDirectory.m
//  I2PRemoteControl
//
//  Created by miximka on 28/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "NSFileManager+SupportDirectory.h"

//=========================================================================
@implementation NSFileManager (SupportDirectory)
//=========================================================================

- (NSURL *)applicationSupportDir
{
    NSURL *appSupportURL = [[self URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSURL *appFilesDirectory = [appSupportURL URLByAppendingPathComponent:bundleIdentifier];
    
    return appFilesDirectory;
}

//=========================================================================

- (BOOL)createDirectoryAtURLIfNotExists:(NSURL *)dirURL error:(NSError **)error
{
    NSError *err = nil;
    NSDictionary *properties = [dirURL resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&err];
    
    if (properties == nil)
    {
        //Could not read properties of the file URL
        BOOL success = NO;
        
        if (err.code == NSFileReadNoSuchFileError)
        {
            err = nil;
            
            //Directory does not exist, so create it now
            success = [[NSFileManager defaultManager] createDirectoryAtPath:[dirURL path]
                                                withIntermediateDirectories:YES
                                                                 attributes:nil
                                                                      error:&err];
        }
    }
    if (error != nil)
    {
        *error = err;
    }
    
    return err == nil;
}

//=========================================================================
@end
//=========================================================================
