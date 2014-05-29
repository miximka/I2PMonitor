//
//  RCApplicationPreferences.m
//  I2PMonitor
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCApplicationPreferences.h"


//=========================================================================

@interface RCApplicationPreferences ()
@property (retain) NSMutableDictionary *observers;
@end

//=========================================================================
@implementation RCApplicationPreferences
//=========================================================================

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		[self setObservers:[[NSMutableDictionary alloc] init]];
	}
	return self;
}

//=========================================================================

- (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//=========================================================================

- (NSInteger)integerForKey:(NSString *)aKey
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:aKey];
}

//=========================================================================

- (void)setInteger:(NSInteger)aValue forKey:(NSString *)aKey
{
	[[NSUserDefaults standardUserDefaults] setInteger:aValue forKey:aKey];
	[self notifyObserversWithKey:aKey];
}

//=========================================================================

- (BOOL)boolForKey:(NSString *)aKey
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:aKey];
}

//=========================================================================

- (void)setBool:(BOOL)aFlag forKey:(NSString *)aKey
{
    BOOL changed = aFlag != [self boolForKey:aKey];
    
    if (changed)
    {
        [[NSUserDefaults standardUserDefaults] setBool:aFlag forKey:aKey];
        [self notifyObserversWithKey:aKey];
    }
}

//=========================================================================

- (void)setString:(NSString *)aStr forKey:(NSString *)aKey
{
	[self setObject:aStr forKey:aKey];
}

//=========================================================================

- (float)floatForKey:(NSString *)aKey
{
	return [[NSUserDefaults standardUserDefaults] floatForKey:aKey];
}

//=========================================================================

- (void)setFloat:(float)aNumber forKey:(NSString *)aKey
{
	[[NSUserDefaults standardUserDefaults] setFloat:aNumber forKey:aKey];
	[self notifyObserversWithKey:aKey];
}

//=========================================================================

- (NSDictionary *)dictionaryForKey:(NSString *)aKey
{
	return [[NSUserDefaults standardUserDefaults] dictionaryForKey:aKey];
}

//=========================================================================

- (NSArray *)arrayForKey:(NSString *)aKey
{
	return [[NSUserDefaults standardUserDefaults] arrayForKey:aKey];
}

//=========================================================================

- (id)objectForKey:(NSString *)aKey
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:aKey];
}

//=========================================================================

- (NSString *)stringForKey:(NSString *)aKey
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:aKey];
}

//=========================================================================

- (void)setObject:(id)anObj forKey:(NSString *)aKey
{
    id currentValue = [self objectForKey:aKey];
    if (![currentValue isEqual:anObj])
    {
        [[NSUserDefaults standardUserDefaults] setObject:anObj forKey:aKey];
        [self notifyObserversWithKey:aKey];
    }
}

//=========================================================================

- (void)removeObjectForKey:(NSString *)aKey
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:aKey];
	[self notifyObserversWithKey:aKey];
}

//=========================================================================

- (void)notifyObserversWithKey:(NSString *)aKey
{
	NSArray *allObservers = [_observers objectForKey:aKey];
	
	for (NSValue *each in allObservers)
	{
        id<RCPreferencesObserver> observer = [each nonretainedObjectValue];
        [observer preferenceChangedForKey:aKey];
	}
}

//=========================================================================
#pragma mark Preferences Observing
//=========================================================================

- (void)addObserver:(id<RCPreferencesObserver>)observer forPreferenceKey:(NSString *)key
{
    NSValue *entry = [NSValue valueWithNonretainedObject:observer];
    
	NSMutableArray *allEntries = [_observers objectForKey:key];
	
	if (!allEntries)
	{
		//No observers exist yet for given key
		allEntries = [NSMutableArray arrayWithObject:entry];
	}
	else
	{
		[allEntries addObject:entry];
	}
	
	[_observers setObject:allEntries forKey:key];
}

//=========================================================================

- (void)removeObserver:(NSObject *)observer
{
    NSValue *entry = [NSValue valueWithNonretainedObject:observer];

	for (NSString *eachKey in [_observers allKeys])
	{
		NSMutableArray *allEntries = [_observers objectForKey:eachKey];
        
		[allEntries removeObject:entry];
		[_observers setObject:allEntries forKey:eachKey];
	}
}

//=========================================================================
@end
//=========================================================================
