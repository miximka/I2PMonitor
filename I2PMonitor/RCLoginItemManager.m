//
//  RCLoginItemManager.m
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCLoginItemManager.h"
#import <CoreServices/CoreServices.h>

#define BUNDLE_IDENTIFIER_KEY	@"BundleIdentifier"
#define HIDE_ON_LAUNCH_KEY		@"com.apple.loginitem.HideOnLaunch"

//=========================================================================
@implementation RCLoginItemManager
//=========================================================================
#pragma mark Lifecycle
//=========================================================================

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		_list = LSSharedFileListCreate(kCFAllocatorDefault, kLSSharedFileListSessionLoginItems, NULL);
	}
	return self;
}

//=========================================================================

- (void)dealloc
{
	if (_list)
		CFRelease(_list);
}

//=========================================================================
#pragma mark Accessors
//=========================================================================

- (CFURLRef)copyURLOfListItem:(LSSharedFileListItemRef)anItem
{
	if (anItem == NULL)
		return NULL;
	
	CFURLRef url;
	OSStatus status = LSSharedFileListItemResolve(anItem, 0, &url, NULL);
	
	if (status == noErr)
	{
		return url;
	}
	
	return NULL;
}

//=========================================================================

- (LSSharedFileListItemRef)copyItemWithIdentifier:(NSString *)anIdentStr
{
	LSSharedFileListItemRef resultItem = NULL;
	CFStringRef identStr = NULL;
	
	//All login items
	CFArrayRef arr = LSSharedFileListCopySnapshot(_list, NULL);
	
	for (int i = 0; i < CFArrayGetCount(arr); i++)
	{
		//Get next login item
		LSSharedFileListItemRef	item = (LSSharedFileListItemRef) CFArrayGetValueAtIndex(arr, i);
		
		if (identStr != NULL)
			CFRelease(identStr);
		
		//Get identifier of the item
		identStr = LSSharedFileListItemCopyProperty(item, (CFStringRef) BUNDLE_IDENTIFIER_KEY);
		
		if (identStr != NULL && [anIdentStr isEqualToString:(__bridge NSString *)identStr])
		{
			//Found equal identifiers
			resultItem = (LSSharedFileListItemRef)CFRetain(item);
			break;
		}
	}
	
	if (identStr != NULL)
		CFRelease(identStr);
	
	if (arr != NULL)
		CFRelease(arr);
	
	return resultItem;
}

//=========================================================================

- (BOOL)isInLoginItemList:(NSString *)bundleIdentifier
{
	LSSharedFileListItemRef item = [self copyItemWithIdentifier:bundleIdentifier];
	
	BOOL found = item != NULL;
	
	if (item != NULL)
		CFRelease(item);
	
	return found;
}

//=========================================================================

- (BOOL)isInLoginItemList
{
	NSString *ident = [[NSBundle mainBundle] bundleIdentifier];
    return [self isInLoginItemList:ident];
}

//=========================================================================

- (BOOL)itemPathIsValid:(LSSharedFileListItemRef)item
{
	BOOL isValid = NO;
	CFURLRef url = [self copyURLOfListItem:item];
	
	if (url != NULL)
	{
		CFStringRef loginItemPath = CFURLCopyFileSystemPath(url, kCFURLPOSIXPathStyle);
		if (loginItemPath != NULL)
		{
			NSString *currentAppPath = [[NSBundle mainBundle] bundlePath];
			isValid = [currentAppPath isEqualToString:(__bridge NSString *)loginItemPath];
			
			CFRelease(loginItemPath);
		}

		CFRelease(url);
	}
	
	return isValid;
}

//=========================================================================

- (BOOL)isLoginItemValid:(NSString *)bundleIdentifier
{
	LSSharedFileListItemRef item = [self copyItemWithIdentifier:bundleIdentifier];
	
	BOOL isInList = item != NULL;
	BOOL pathIsCorrect = [self itemPathIsValid:item];
						
	if (item != NULL)
		CFRelease(item);
	
	return isInList && pathIsCorrect;
}

//=========================================================================

- (BOOL)isLoginItemValid
{
	NSString *ident = [[NSBundle mainBundle] bundleIdentifier];
    return [self isLoginItemValid:ident];
}

//=========================================================================

- (BOOL)getHiddenOnLaunchFlag:(LSSharedFileListItemRef)item
{
	BOOL isHidden = NO;

	CFBooleanRef isHiddenRef = LSSharedFileListItemCopyProperty(item, (CFStringRef) HIDE_ON_LAUNCH_KEY);
	
	if (isHiddenRef)
	{
		isHidden = CFBooleanGetValue(isHiddenRef);
		CFRelease(isHiddenRef);
	}
	
	return isHidden;
}

//=========================================================================

- (BOOL)isHiddenOnLaunch:(NSString *)bundleIdentifier
{
	BOOL flag = NO;

	LSSharedFileListItemRef item = [self copyItemWithIdentifier:bundleIdentifier];
	
	if (item != NULL)
	{
		flag = [self getHiddenOnLaunchFlag:item];
	
		CFRelease(item);
	}
	
	return flag;
}

//=========================================================================

- (BOOL)isHiddenOnLaunch
{
	NSString *ident = [[NSBundle mainBundle] bundleIdentifier];
    return [self isHiddenOnLaunch:ident];
}

//=========================================================================
#pragma mark -
//=========================================================================

- (void)addLoginItemWithPath:(NSString *)path identifier:(NSString *)bundleIdentifier shouldHideOnStart:(BOOL)hideOnStart
{
	NSURL *url =  [NSURL fileURLWithPath:path];
	
	//Default properties: hide main window at startup per default
	NSDictionary *propertiesToSet = [NSDictionary dictionaryWithObjectsAndKeys:
									 [NSNumber numberWithBool:hideOnStart], HIDE_ON_LAUNCH_KEY,
									 bundleIdentifier, BUNDLE_IDENTIFIER_KEY,
									 nil];
	
	//Insert login item at the end of the list
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(_list,
																 kLSSharedFileListItemLast,
																 NULL,
																 NULL,
																 (__bridge CFURLRef)url,
																 (__bridge CFDictionaryRef) propertiesToSet,
																 NULL
                                                                 );
	
	if (item != NULL)
		CFRelease(item);
}

//=========================================================================

- (void)addOrUpdateLoginItemWithPath:(NSString *)path identifier:(NSString *)bundleIdentifier shouldHideOnStart:(BOOL)hideOnStart
{
    BOOL shouldUpdateItem = YES;
	
	if ([self isInLoginItemList:bundleIdentifier])
	{
		//Item already exists. Check its validity
		BOOL isValid = [self isLoginItemValid:bundleIdentifier];
		BOOL isHidden = [self isHiddenOnLaunch:bundleIdentifier];
		
		shouldUpdateItem = !isValid || hideOnStart != isHidden;
	}
    
	if (shouldUpdateItem)
	{
		//To update item remove it first and add once again with the updated parameters
		[self removeLoginItemWithIdentifier:bundleIdentifier];
		[self addLoginItemWithPath:path identifier:bundleIdentifier shouldHideOnStart:hideOnStart];
	}
}

//=========================================================================

- (void)addOrUpdateLoginItem:(BOOL)hideOnStart
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    [self addOrUpdateLoginItemWithPath:bundlePath identifier:bundleIdentifier shouldHideOnStart:hideOnStart];
}

//=========================================================================

- (OSStatus)removeLoginItemWithIdentifier:(NSString *)bundleIdentifier
{
	LSSharedFileListItemRef item = [self copyItemWithIdentifier:bundleIdentifier];
    OSStatus ret = kIOReturnBadArgument;

	if (item != NULL)
	{
		ret = LSSharedFileListItemRemove(_list, item);
		CFRelease(item);
	}
    
    return ret;
}

//=========================================================================

- (void)removeLoginItem
{
	[self removeLoginItemWithIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
}

//=========================================================================
@end
//=========================================================================
