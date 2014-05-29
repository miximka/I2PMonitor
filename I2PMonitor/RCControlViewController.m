//
//  RCControlViewController.m
//  I2PRemoteControl
//
//  Created by miximka on 26/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCControlViewController.h"
#import "RCContentView.h"
#import "RCControlButton.h"
#import "RCRouter.h"
#import "FBKVOController.h"

//=========================================================================

@interface RCControlViewController ()
@property (nonatomic) FBKVOController *kvoController;
@end

//=========================================================================
@implementation RCControlViewController
//=========================================================================

- (void)updateButtons
{
    RCRouter *router = (RCRouter *)self.representedObject;

    BOOL enableButton1 = NO;
    NSString *button1Title = nil;
    NSString *button1ImageName = nil;

    BOOL enableButton2 = NO;
    NSString *button2Title = nil;
    NSString *button2ImageName = nil;
    
    SEL action1 = nil;
    SEL action2 = nil;
    
    switch (router.lifecycleStatus)
    {
        case kRouterLifecycleActive:
            enableButton1 = YES;
            button1Title = MyLocalStr(@"Restart");
            button1ImageName = @"Restart";
            action1 = @selector(restartGracefully:);
            enableButton2 = YES;
            button2Title = MyLocalStr(@"Shutdown");
            button2ImageName = @"Shutdown";
            action2 = @selector(shutdownGracefully:);
            break;
            
        case kRouterLifecycleRestartingGracefully:
            enableButton1 = YES;
            button1Title = MyLocalStr(@"RestartImmediately");
            button1ImageName = @"Restart";
            action1 = @selector(restartImmediately:);
            enableButton2 = NO; //I2PControl plugin does not support cancelation yet
            button2Title = MyLocalStr(@"CancelRestart");
            button2ImageName = @"Cancel";
            action2 = @selector(cancelRestart:);
            break;

        case kRouterLifecycleShuttingDownGracefully:
            enableButton1 = YES;
            button1Title = MyLocalStr(@"ShutdownImmediately");
            button1ImageName = @"Shutdown";
            action1 = @selector(shutdownImmediately:);
            enableButton2 = NO; //I2PControl plugin does not support cancelation yet
            button2Title = MyLocalStr(@"CancelShutdown");
            button2ImageName = @"Cancel";
            action2 = @selector(cancelShutdown:);
            break;

        case kRouterLifecycleRestartingHard:
        case kRouterLifecycleShuttingDownHard:
        case kRouterLifecycleUnknownStatus:
        default:
            button1ImageName = @"Restart";
            button1Title = MyLocalStr(@"Restart");
            button2ImageName = @"Shutdown";
            button2Title = MyLocalStr(@"Shutdown");
            break;
    }

    [self.actionButton1 setAction:action1];
    [self.actionButton2 setAction:action2];
    
    [self.actionButton1 setEnabled:enableButton1];
    [self.actionButton2 setEnabled:enableButton2];
    
    [self.actionButton1 setImage:[NSImage imageNamed:button1ImageName]];
    [self.actionButton2 setImage:[NSImage imageNamed:button2ImageName]];
    
    [self.view layoutSubtreeIfNeeded];

    //Animate buttons frame change
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setAllowsImplicitAnimation:YES];
        
        [self.actionButton1 customSetTitle:button1Title color:[NSColor whiteColor]];
        [self.actionButton2 customSetTitle:button2Title color:[NSColor whiteColor]];
        
        [self.view layoutSubtreeIfNeeded];
        
    } completionHandler:^{
    }];
}

//=========================================================================

- (void)updateGUI
{
    [super updateGUI];
    
    [self.actionButton1 setTarget:self];
    [self.actionButton2 setTarget:self];
    
    [self updateButtons];
}

//=========================================================================

- (IBAction)restartGracefully:(id)sender
{
    RCRouter *router = (RCRouter *)self.representedObject;
    [router restartRouterGracefully:YES];
}

//=========================================================================

- (IBAction)restartImmediately:(id)sender
{
    RCRouter *router = (RCRouter *)self.representedObject;
    [router restartRouterGracefully:NO];
}

//=========================================================================

- (IBAction)shutdownGracefully:(id)sender
{
    RCRouter *router = (RCRouter *)self.representedObject;
    [router shutdownRouterGracefully:YES];
}

//=========================================================================

- (IBAction)shutdownImmediately:(id)sender
{
    RCRouter *router = (RCRouter *)self.representedObject;
    [router shutdownRouterGracefully:NO];
}

//=========================================================================

- (IBAction)cancelRestart:(id)sender
{
    RCRouter *router = (RCRouter *)self.representedObject;
    [router cancelRestart];
}

//=========================================================================

- (IBAction)cancelShutdown:(id)sender
{
    RCRouter *router = (RCRouter *)self.representedObject;
    [router cancelShutdown];
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)loadView
{
    [super loadView];
    
    [(RCContentView *)self.view setColorType:RCContentViewColorViolet];

    [self updateGUI];
}

//=========================================================================

- (void)setRepresentedObject:(id)object
{
    [super setRepresentedObject:object];
    
    NSAssert(object == nil || [object isKindOfClass:[RCRouter class]], @"Invalid object");
    RCRouter *router = (RCRouter *)object;

    //Register for KVO notifications
    FBKVOController *kvoController = [[FBKVOController alloc] initWithObserver:self];
    self.kvoController = kvoController;

    if (router != nil)
    {
        __weak RCControlViewController *blockSelf = self;
        [self.kvoController observe:router
                            keyPath:NSStringFromSelector(@selector(active))
                            options:0
                              block:^(id observer, id object, NSDictionary *change) {
                                  
                                  [blockSelf updateButtons];
                                  
                              }];
        
        [self.kvoController observe:router
                            keyPath:NSStringFromSelector(@selector(lifecycleStatus))
                            options:0
                              block:^(id observer, id object, NSDictionary *change) {
                                  
                                  [blockSelf updateButtons];
                                  
                              }];
    }
}

//=========================================================================
@end
//=========================================================================
