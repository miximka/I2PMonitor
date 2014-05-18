//
//  RCButtonView.h
//  I2PRemoteControl
//
//  Created by miximka on 17/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RCContentView.h"

//=========================================================================
@interface RCButtonView : NSView
//=========================================================================

@property (nonatomic) IBOutlet NSImageView *imageView;

//Top line style type (RCContentViewColorType)
@property (nonatomic) NSNumber *type;

//=========================================================================
@end
//=========================================================================
