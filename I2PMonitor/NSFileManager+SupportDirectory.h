//
//  NSFileManager+SupportDirectory.h
//  I2PMonitor
//
//  Created by miximka on 28/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================
@interface NSFileManager (SupportDirectory)
//=========================================================================

- (NSURL *)applicationSupportDir;
- (BOOL)createDirectoryAtURLIfNotExists:(NSURL *)dirURL error:(NSError **)error;

//=========================================================================
@end
//=========================================================================
