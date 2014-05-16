//
//  RCAppDelegate.m
//  I2PRemoteControl
//
//  Created by miximka on 11/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCAppDelegate.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"
#import "RCLogFormatter.h"
#import "RCRouter.h"
#import "RCRouterInfo.h"
#import "RCPreferencesWindowController.h"
#import "RCRouterManager.h"
#import "RCStatusBarView.h"
#import "RCRouterOverviewViewController.h"
#import "RCMenu.h"

//=========================================================================

//Should correspond to the statusBarMenu tags in MainMenu.xib
typedef NS_ENUM(NSUInteger, RCMenuItemTag)
{
    kRouterBasicInfoMenuTag   = 1,
};

@interface RCAppDelegate ()
@property (nonatomic) NSStatusItem *statusBarItem;
@property (nonatomic) RCRouterManager *routerManager;
@property (nonatomic) RCPreferencesWindowController *prefsWindowController;
@property (nonatomic) BOOL isFirstStart;
@end

//=========================================================================
@implementation RCAppDelegate
//=========================================================================

- (void)dealloc
{
    [self unregisterForNotifications];
}

//=========================================================================

- (BOOL)isRunningUnitTests
{
	return NSClassFromString(@"XCTestRun") != nil;
}

//=========================================================================

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(routerDidUpdateRouterInfo:)
                                                 name:RCRouterDidUpdateRouterInfoNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managerDidSetRouter:)
                                                 name:RCManagerDidSetRouterNotification
                                               object:nil];
}

//=========================================================================

- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//=========================================================================

- (void)initializeLogging
{
    RCLogFormatter *logFormatter = [[RCLogFormatter alloc] init];
    
    [[DDASLLogger sharedInstance] setLogFormatter:logFormatter];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setLogFormatter:logFormatter];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; //24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [fileLogger setLogFormatter:logFormatter];
    [DDLog addLogger:fileLogger];
    
    //Log application version
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    DDLogInfo(@"===");
    DDLogInfo(@"App version: %@ (%@)", [infoDict objectForKey:@"CFBundleShortVersionString"], [infoDict objectForKey:@"CFBundleVersion"]);
}

//=========================================================================

- (void)addStatusBarItem
{
    //Create status bar item
	NSStatusItem *item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    CGFloat thickness = [[NSStatusBar systemStatusBar] thickness];
    RCStatusBarView *statusBarView = [[RCStatusBarView alloc] initWithFrame:NSMakeRect(0, 1, thickness, thickness)];
    [statusBarView setStatusItem:item];
    [statusBarView setImage:[NSImage imageNamed:@"StatusBarIcon_Inactive"]];
    
    [item setView:statusBarView];
    [item setHighlightMode:YES];
    [item setMenu:self.statusBarMenu];
    
    self.statusBarItem = item;
}

//=========================================================================

- (RCStatusBarView *)statusBarItemView
{
    return (RCStatusBarView *)self.statusBarItem.view;
}

//=========================================================================

- (void)showArrowPanel
{
    NSWindow *statusBarItemWindow = [[self statusBarItemView] window];
    
    NSRect statusBarRect = statusBarItemWindow.frame;
    NSRect aRect = self.arrowPanel.frame;
    aRect.origin.x = statusBarRect.origin.x + statusBarRect.size.width / 2.f - aRect.size.width / 2.f;
    aRect.origin.y = statusBarRect.origin.y - aRect.size.height - statusBarRect.size.height;

    [self.arrowPanel setFrame:aRect display:YES];
    [self.arrowPanel makeKeyAndOrderFront:self];
}

//=========================================================================

- (void)menuItem:(NSMenuItem *)menuItem setTitleWithFormat:(NSString *)format value:(id)value
{
    if (value == nil)
        value = @"-";
    
    NSString *title = [NSString stringWithFormat:format, value];
    [menuItem setTitle:title];
}

//=========================================================================

- (void)updateStatusBarIcon
{
    //Update status bar icon
    RCStatusBarIconType iconType = RCIconTypeInactive;
    if (self.routerManager.router.active)
    {
        iconType = RCIconTypeActive;
    }
    [[self statusBarItemView] setIconType:iconType];
}

//=========================================================================

- (IBAction)shutdown:(id)sender
{
    DDLogInfo(@"Shutdown");
}

//=========================================================================

- (IBAction)restart:(id)sender
{
    DDLogInfo(@"Restart");
}

//=========================================================================

- (IBAction)openPreferences:(id)sender
{
	if (!self.prefsWindowController)
	{
		RCPreferencesWindowController *ctrl = [[RCPreferencesWindowController alloc] initWithWindowNibName:@"Preferences"];
        [ctrl setRouterManager:self.routerManager];
        self.prefsWindowController = ctrl;
	}
	
	[self.prefsWindowController showWindow:self];
}

//=========================================================================

- (IBAction)quit:(id)sender
{
    [NSApp terminate:self];
}

//=========================================================================
#pragma mark NSApplicationDelegate
//=========================================================================

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if ([self isRunningUnitTests])
        return;

    [self initializeLogging];

    //Add status bar item
    [self addStatusBarItem];
    
    BOOL isFirstStart = [RCPrefs isFirstStart];
    if (isFirstStart)
    {
        [RCPrefs setIsFirstStart:NO];
        [RCPrefs synchronize];
        
        //Show window with the pointing arrow to the login item
        [self showArrowPanel];
    }

    //Initialize router manager
    RCRouterManager *routerManager = [[RCRouterManager alloc] init];
    self.routerManager = routerManager;

    [self registerForNotifications];

    //Start looking for router
    [self.routerManager restartRouter];
}

//=========================================================================
#pragma mark NSMenuDelegate
//=========================================================================

- (void)menuWillOpen:(NSMenu *)menu
{
    if (menu != self.statusBarMenu)
        return;
    
    [(RCMenu *)menu setEnableUpdates:YES];
    
    if (self.arrowPanel)
    {
        //Dismiss arrow panel
        [self.arrowPanel orderOut:self];
        self.arrowPanel = nil;
    }

    //Draw blue background under the status bar icon
    [[self statusBarItemView] setHighlighted:YES];
}

//=========================================================================

- (void)menuDidClose:(NSMenu *)menu
{
    if (menu != self.statusBarMenu)
        return;

    [(RCMenu *)menu setEnableUpdates:NO];

    [[self statusBarItemView] setHighlighted:NO];
}

//=========================================================================
#pragma mark Notifications
//=========================================================================

- (void)routerDidUpdateRouterInfo:(NSNotification *)notification
{
    [self updateStatusBarIcon];
}

//=========================================================================

- (void)managerDidSetRouter:(NSNotification *)notification
{
    [self updateStatusBarIcon];

    //Update router info menu entry
    NSMenuItem *basicInfoMenuItem = [self.statusBarMenu itemWithTag:kRouterBasicInfoMenuTag];
    [basicInfoMenuItem setRepresentedObject:self.routerManager.router];
}

//=========================================================================
@end
//=========================================================================

