//
//  RCRouterBasicInfoTask
//  I2PMonitor
//
//  Created by miximka on 13/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCTask.h"
#import "RCRouterInfo.h"

typedef void(^RCRouterInfoTaskCompletionHandler)(NSDictionary *responseDict, NSError *error);

//=========================================================================
@interface RCRouterInfoTask : RCTask
//=========================================================================

- (instancetype)initWithIdentifier:(NSString *)identifier options:(CRRouterInfoOptions)options;

@property (nonatomic) CRRouterInfoOptions options;
@property (nonatomic, copy) RCRouterInfoTaskCompletionHandler completionHandler;

//=========================================================================
@end
//=========================================================================
