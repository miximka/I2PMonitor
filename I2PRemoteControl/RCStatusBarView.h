//
//  RCStatusBarView.h
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, RCStatusBarIconType)
{
    RCIconTypeInactive  = 0,
    RCIconTypeActive,
    
};

//=========================================================================
@interface RCStatusBarView : NSImageView
//=========================================================================

@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic, getter = isHighlighted) BOOL highlighted;
@property (nonatomic) RCStatusBarIconType iconType;

//=========================================================================
@end
//=========================================================================
