//
//  NSImage+DarkenDraw.h
//  I2PRemoteControl
//
//  Created by miximka on 21/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//=========================================================================
@interface NSImage (DarkenDraw)
//=========================================================================

- (void)drawInRect:(NSRect)rect fromRect:(NSRect)fromRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta darken:(BOOL)darken;

//=========================================================================
@end
//=========================================================================
