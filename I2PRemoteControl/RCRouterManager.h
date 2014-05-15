//
//  RCRouterManager.h
//  I2PRemoteControl
//
//  Created by miximka on 12/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCPreferences.h"

@class RCRouter;
@class RCRouterManager;

@protocol RCRouterManagerDelegate <NSObject>
- (void)managerDidChangeRouter:(RCRouterManager *)manager;
@end

//=========================================================================
@interface RCRouterManager : NSObject <RCPreferencesObserver>
//=========================================================================

@property (nonatomic, weak) id<RCRouterManagerDelegate> delegate;
@property (nonatomic, readonly) RCRouter *router;

//=========================================================================
@end
//=========================================================================
