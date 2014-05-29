//
//  RCRouterManagerTask.h
//  I2PMonitor
//
//  Created by miximka on 27/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCTask.h"

//=========================================================================
@interface RCRouterManagerTask : RCTask
//=========================================================================

- (instancetype)initWithIdentifier:(NSString *)identifier action:(RCRouterManagerAction)action;

@property (nonatomic) RCRouterManagerAction action;

//=========================================================================
@end
//=========================================================================
