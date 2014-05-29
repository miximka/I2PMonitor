//
//  RCLoginItemManager.h
//  I2PMonitor
//
//  Created by miximka on 13/05/14.
//  Copyright (c)2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

//=========================================================================
@interface RCLoginItemManager : NSObject
{
	LSSharedFileListRef _list;
}

/**
    Returns YES if login item for given bundleIdentifier exists in the login item list
 */
- (BOOL)isInLoginItemList:(NSString *)bundleIdentifier;

/**
    Returns YES if login item for main bundle identifier exists in the login item list
 */
- (BOOL)isInLoginItemList;

/**
    Returns YES if login item path is valid (i.e. item's path still points to existing file object)
 */
- (BOOL)isLoginItemValid:(NSString *)bundleIdentifier;
- (BOOL)isLoginItemValid;

/**
    Returns YES if login item of main application bundle is hidden on system launch or user login
 */
- (BOOL)isHiddenOnLaunch:(NSString *)bundleIdentifier;
- (BOOL)isHiddenOnLaunch;

//=========================================================================
#pragma mark -
//=========================================================================

/**
    Adds a login item for bundle at given path and bundle identifier
 */
- (void)addOrUpdateLoginItemWithPath:(NSString *)path identifier:(NSString *)bundleIdentifier shouldHideOnStart:(BOOL)hideOnStart;

/**
    Convenient method to add login item for main application bundle
 */
- (void)addOrUpdateLoginItem:(BOOL)hideOnStart;

/**
    Removes login item with given bundle itentifier
 */
- (OSStatus)removeLoginItemWithIdentifier:(NSString *)bundleIdentifier;

/**
    Convenient methods to remove login item for main application bundle identifier
 */
- (void)removeLoginItem;

//=========================================================================
@end
//=========================================================================
