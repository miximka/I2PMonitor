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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Initialization code here.
    }
    return self;
}

//=========================================================================

- (void)updateButtons
{
    RCRouter *router = (RCRouter *)self.representedObject;

    BOOL enableButtons = YES;
    if (router.lifecycleStatus == kRouterLifecycleUnknownStatus)
    {
        enableButtons = NO;
    }
    else
    {
        //TODO: Check other states
    }

    [self.restartButton setEnabled:enableButtons];
    [self.shutdownButton setEnabled:enableButtons];
}

//=========================================================================

- (void)updateGUI
{
    [super updateGUI];
    [self updateButtons];
}

//=========================================================================

- (IBAction)restart:(id)sender
{
    RCRouter *router = (RCRouter *)self.representedObject;
    [router restartRouterGracefully:YES];
}

//=========================================================================

- (IBAction)shutdown:(id)sender
{
    RCRouter *router = (RCRouter *)self.representedObject;
    [router shutdownRouterGracefully:YES];
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)loadView
{
    [super loadView];
    
    [(RCContentView *)self.view setColorType:RCContentViewColorViolet];

    NSColor *textColor = [NSColor whiteColor];
    [self.restartButton customSetTitle:MyLocalStr(@"Restart") color:textColor];
    [self.shutdownButton customSetTitle:MyLocalStr(@"Shutdown") color:textColor];

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
