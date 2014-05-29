//
//  RCPeersViewController.h
//  I2PMonitor
//
//  Created by miximka on 20/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCViewController.h"

//=========================================================================
@interface RCPeersViewController : RCViewController
//=========================================================================

@property (nonatomic) IBOutlet NSTextField *activePeersTextField;
@property (nonatomic) IBOutlet NSTextField *fastPeersTextField;
@property (nonatomic) IBOutlet NSTextField *highCapacityPeersTextField;
@property (nonatomic) IBOutlet NSTextField *knownPeersTextField;
@property (nonatomic) IBOutlet NSTextField *participatingTunnelsTextField;

//=========================================================================
@end
//=========================================================================
