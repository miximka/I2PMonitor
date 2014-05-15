//
//  RCApplicationPreferences.h
//  I2PRemoteControl
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCPreferencesObserver <NSObject>
- (void)preferenceChangedForKey:(NSString *)aKey;
@end

//=========================================================================
@interface RCApplicationPreferences : NSObject
//=========================================================================

- (void)synchronize;

- (BOOL)boolForKey:(NSString *)aKey;
- (NSInteger) integerForKey:(NSString *)aKey;
- (float) floatForKey:(NSString *)aKey;
- (NSString *)stringForKey:(NSString *)aKey;
- (NSDictionary *)dictionaryForKey:(NSString *)aKey;
- (NSArray *)arrayForKey:(NSString *)aKey;
- (id)objectForKey:(NSString *)aKey;

- (void)setBool:(BOOL)aFlag forKey:(NSString *)aKey;
- (void)setInteger:(NSInteger)aValue forKey:(NSString *)aKey;
- (void)setFloat:(float)aNumber forKey:(NSString *)aKey;
- (void)setString:(NSString *)aStr forKey:(NSString *)aKey;
- (void)setObject:(id)anObj forKey:(NSString *)aKey;

- (void)removeObjectForKey:(NSString *)aKey;

//=========================================================================
#pragma mark Preferences Observing
//=========================================================================

- (void)addObserver:(id<RCPreferencesObserver>)observer forPreferenceKey:(NSString *)key;
- (void)removeObserver:(NSObject *)observer;

//=========================================================================
@end
//=========================================================================
