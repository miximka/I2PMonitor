//
//  RCNetworkStatusViewController.m
//  I2PRemoteControl
//
//  Created by miximka on 16/05/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "RCNetworkStatusViewController.h"
#import "RCRouter.h"
#import <CorePlot/CorePlot.h>
#import "RCGraphTextField.h"
#import "RCRouterInfo.h"
#import "FBKVOController.h"

//=========================================================================

@interface RCNetworkStatusViewController () <CPTPlotDataSource>
@property (nonatomic) FBKVOController *kvoController;
@property (nonatomic) CPTXYGraph *graph;
@property (nonatomic) NSArray *downloadPlotData;
@property (nonatomic) NSArray *uploadPlotData;
@end

//=========================================================================
@implementation RCNetworkStatusViewController
//=========================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

//=========================================================================

- (void)updateStatus
{
    RCRouter *router = (RCRouter *)self.representedObject;
    
    NSString *str = router.routerInfo.routerStatus;
    [self.statusTextField setStringValue:GetValueOrDefaulIfNil(str)];
}

//=========================================================================

- (void)initializeGraph
{
    NSUInteger observedMinutes = 40; //15 mins
    CGFloat tickTimeInterval = 60; //60 sec
    NSTimeInterval entireTimeInterval = observedMinutes * tickTimeInterval;
    CGFloat maxYValue = 100.0; //Kbps
    
    //Create graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    self.graph.paddingLeft = 0;
    self.graph.paddingRight = 0;
    self.graph.paddingTop = 0;
    self.graph.paddingBottom = 0;

    CPTMutableLineStyle *borderLineStyle = [[CPTMutableLineStyle alloc] init];
    borderLineStyle.lineWidth = 1;
    borderLineStyle.lineColor = [CPTColor colorWithComponentRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    self.graph.plotAreaFrame.borderLineStyle = borderLineStyle;
    
    self.graphHostView.hostedGraph = self.graph;

    //Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(entireTimeInterval)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(maxYValue)];
    
    //Hide Axes
    self.graph.axisSet = nil;
    
    //Create a plot
    CPTScatterPlot *downloadPlot = [[CPTScatterPlot alloc] init];
    downloadPlot.identifier = @"Download";
    
    CPTMutableLineStyle *lineStyle = [downloadPlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 1.5;
    lineStyle.lineColor = [CPTColor colorWithComponentRed:0.4 green:1.0 blue:0.4 alpha:1.0];
    downloadPlot.dataLineStyle = lineStyle;
    
    downloadPlot.dataSource = self;
    [self.graph addPlot:downloadPlot];
    
    // Put an area gradient under the plot above
    CPTColor *areaColor = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    areaGradient.angle = -90.0;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    downloadPlot.areaFill = areaGradientFill;
    downloadPlot.areaBaseValue = CPTDecimalFromDouble(1.75);
    
    // Add some data
    NSMutableArray *newData = [NSMutableArray array];
    for ( NSUInteger i = 0; i <= observedMinutes; i++ ) {
        
        NSTimeInterval x = tickTimeInterval * i;
        CGFloat y = maxYValue/4 + maxYValue*2/4 * rand() / (double)RAND_MAX;
        
        [newData addObject:
         @{ @(CPTScatterPlotFieldX): @(x),
            @(CPTScatterPlotFieldY): @(y) }
         ];
    }
    self.downloadPlotData = newData;
    
    //Create a plot
    CPTScatterPlot *uploadPlot = [[CPTScatterPlot alloc] init];
    uploadPlot.identifier = @"Upload";
    
    lineStyle = [lineStyle mutableCopy];
    lineStyle.lineColor = [CPTColor colorWithComponentRed:1.0 green:0.4 blue:0.4 alpha:1.0];
    uploadPlot.dataLineStyle = lineStyle;
    
    uploadPlot.dataSource = self;
    [self.graph addPlot:uploadPlot];
    
    // Put an area gradient under the plot above
    areaColor = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    areaGradient.angle = -90.0;
    areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    uploadPlot.areaFill = areaGradientFill;
    uploadPlot.areaBaseValue = CPTDecimalFromDouble(1.75);
    
    // Add some data
    newData = [NSMutableArray array];
    for ( NSUInteger i = 0; i <= observedMinutes; i++ ) {
        
        NSTimeInterval x = tickTimeInterval * i;
        CGFloat y = maxYValue/2 * rand() / (double)RAND_MAX;
        
        [newData addObject:
         @{ @(CPTScatterPlotFieldX): @(x),
            @(CPTScatterPlotFieldY): @(y) }
         ];
    }
    self.uploadPlotData = newData;

}

//=========================================================================

- (void)updateGUI
{
    [self updateStatus];
}

//=========================================================================
#pragma mark Overridden Methods
//=========================================================================

- (void)loadView
{
    [super loadView];

    self.downloadTextField.textColor = [NSColor colorWithCalibratedRed:0.5 green:1.0 blue:0.5 alpha:1.0];
    self.uploadTextField.textColor = [NSColor colorWithCalibratedRed:1.0 green:0.5 blue:0.5 alpha:1.0];

    [self updateGUI];
    [self initializeGraph];
}

//=========================================================================

- (void)setRepresentedObject:(id)object
{
    [super setRepresentedObject:object];

    NSAssert([object isKindOfClass:[RCRouter class]], @"Invalid object");
    RCRouter *router = (RCRouter *)object;
    
    //Register for KVO notifications
    FBKVOController *kvoController = [[FBKVOController alloc] initWithObserver:self];
    self.kvoController = kvoController;
    
    __weak RCNetworkStatusViewController *blockSelf = self;
    [self.kvoController observe:router.routerInfo
                        keyPath:NSStringFromSelector(@selector(routerStatus))
                        options:0
                          block:^(id observer, id object, NSDictionary *change) {
                              
                              [blockSelf updateStatus];
                              
                          }];

    [self updateGUI];
}

//=========================================================================
#pragma mark CPTPlotDataSource
//=========================================================================

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([plot.identifier isEqual:@"Download"])
    {
        return self.downloadPlotData.count;
    }
    else if ([plot.identifier isEqual:@"Upload"])
    {
        return self.uploadPlotData.count;
    }
    
    return 0;
}

//=========================================================================

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSArray *plotData = nil;
    
    if ([plot.identifier isEqual:@"Download"])
    {
        plotData = self.downloadPlotData;
    }
    else if ([plot.identifier isEqual:@"Upload"])
    {
        plotData = self.uploadPlotData;
    }
    
    return plotData[index][@(fieldEnum)];
}

//=========================================================================
@end
//=========================================================================
