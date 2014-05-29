//
//  RCStatusBarView.h
//  I2PMonitor
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

@class RCStatusBarView;

@protocol RCStatusBarViewDelegate <NSObject>
- (void)statusBarViewDidChangeHighlighted:(RCStatusBarView *)view;
@end

//=========================================================================
@interface RCStatusBarView : NSImageView
//=========================================================================

@property (nonatomic, weak) id<RCStatusBarViewDelegate> delegate;
@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic, getter = isHighlighted) BOOL highlighted;
@property (nonatomic) RCStatusBarIconType iconType;

//=========================================================================
@end
//=========================================================================
