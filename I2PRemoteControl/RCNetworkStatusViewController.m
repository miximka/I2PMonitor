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
#import "RCBWMeasurement.h"
#import "RCBWMeasurementBuffer.h"

//=========================================================================

#define GRAPH_VISIBLE_TIME_INTERVAL 60 * 2 //15 mins
#define GRAPH_IDENTIFIER_INBOUND    @"Inbound"
#define GRAPH_IDENTIFIER_OUTBOUND   @"Outbound"

@interface RCNetworkStatusViewController () <CPTPlotDataSource>
@property (nonatomic) CPTXYGraph *graph;
//@property (nonatomic) NSArray *downloadPlotData;
//@property (nonatomic) NSArray *uploadPlotData;
@end

//=========================================================================
@implementation RCNetworkStatusViewController
//=========================================================================

- (void)dealloc
{
    [self unregisterFromNotifications];
}

//=========================================================================

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(routerDidUpdateRouterInfo:)
                                                 name:RCRouterDidUpdateRouterInfoNotification
                                               object:nil];
}

//=========================================================================

- (void)unregisterFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//=========================================================================

- (void)setRouterStatusString:(NSString *)string
{
    //Check whether the string fits into one line
    NSDictionary *attributes = @{ NSFontAttributeName : self.singleLineStatusTextField.font };
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    NSSize textFieldSize = self.singleLineStatusTextField.frame.size;
    NSRect boundingRect = [attributedStr boundingRectWithSize:textFieldSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine];
    
    //Decide to use single or multiline text field
    BOOL fitsIntoOneLine = textFieldSize.height >= boundingRect.size.height;

    [self.singleLineStatusTextField setHidden:!fitsIntoOneLine];
    [self.multiLineStatusTextField setHidden:fitsIntoOneLine];
    
    [self.singleLineStatusTextField setStringValue:string];
    [self.multiLineStatusTextField setStringValue:string];
}

//=========================================================================

- (void)updateStatus
{
    RCRouter *router = (RCRouter *)self.representedObject;
    
    NSString *str = router.routerInfo.routerStatus;
    [self setRouterStatusString:GetValueOrDefaulIfNil(str)];
}

//=========================================================================

- (void)configureSpaceForGraph:(CPTXYGraph *)graph measurementsBuffer:(RCBWMeasurementBuffer *)buffer
{
    CGFloat maxBandwidthValue = fmax(buffer.maxInbound, buffer.maxOutbound);
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;

    NSDate *endDate = [NSDate date];
    NSDate *startDate = [endDate dateByAddingTimeInterval:-GRAPH_VISIBLE_TIME_INTERVAL];
    
    NSTimeInterval startTimestamp = [startDate timeIntervalSince1970];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(startTimestamp) length:CPTDecimalFromDouble(GRAPH_VISIBLE_TIME_INTERVAL)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(maxBandwidthValue)];
    
    NSLog(@"Start: %f", startTimestamp);
    NSLog(@"End: %f", startTimestamp + GRAPH_VISIBLE_TIME_INTERVAL);
    NSLog(@"Max value: %f", maxBandwidthValue);
}

//=========================================================================

- (void)initializeGraph
{
    //Create graph
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    self.graph = graph;
    
    graph.paddingLeft = 0;
    graph.paddingRight = 0;
    graph.paddingTop = 0;
    graph.paddingBottom = 0;

    //Draw border line
    CPTMutableLineStyle *borderLineStyle = [[CPTMutableLineStyle alloc] init];
    borderLineStyle.lineWidth = 1;
    borderLineStyle.lineColor = [CPTColor colorWithComponentRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    graph.plotAreaFrame.borderLineStyle = borderLineStyle;
    
    //Setup scatter plot space
    self.graphHostView.hostedGraph = graph;

    //Setup scatter plot space
    [self configureSpaceForGraph:graph measurementsBuffer:[(RCRouter *)self.representedObject measurementsBuffer]];
    
    //Hide Axes
    graph.axisSet = nil;
    
    //Create bandwidth inboud plot
    CPTScatterPlot *downloadPlot = [[CPTScatterPlot alloc] init];
    downloadPlot.identifier = GRAPH_IDENTIFIER_INBOUND;
    downloadPlot.dataSource = self;
    
    CPTMutableLineStyle *lineStyle = [downloadPlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 1.5;
    lineStyle.lineColor = [CPTColor colorWithComponentRed:0.4 green:1.0 blue:0.4 alpha:1.0];
    downloadPlot.dataLineStyle = lineStyle;
    
    //Put an area gradient under the plot above
    CPTColor *areaColor = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    areaGradient.angle = -90.0;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    downloadPlot.areaFill = areaGradientFill;
    downloadPlot.areaBaseValue = CPTDecimalFromDouble(1.75);

    //Add plot to the graph
    [graph addPlot:downloadPlot];

//    //Create bandwidth outbound plot
//    CPTScatterPlot *outboundPlot = [[CPTScatterPlot alloc] init];
//    outboundPlot.identifier = GRAPH_IDENTIFIER_OUTBOUND;
//    outboundPlot.dataSource = self;
//    
//    lineStyle = [lineStyle mutableCopy];
//    lineStyle.lineColor = [CPTColor colorWithComponentRed:1.0 green:0.4 blue:0.4 alpha:1.0];
//    outboundPlot.dataLineStyle = lineStyle;
//    
//    //Put an area gradient under the plot above
//    areaColor = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
//    areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
//    areaGradient.angle = -90.0;
//    areaGradientFill = [CPTFill fillWithGradient:areaGradient];
//    outboundPlot.areaFill = areaGradientFill;
//    outboundPlot.areaBaseValue = CPTDecimalFromDouble(1.75);
//
//    [graph addPlot:outboundPlot];
}

//=========================================================================

- (void)updatePlot
{
    CPTXYGraph *graph = self.graph;
    [self configureSpaceForGraph:graph measurementsBuffer:[(RCRouter *)self.representedObject measurementsBuffer]];
    
    [[self.graph plotWithIdentifier:GRAPH_IDENTIFIER_INBOUND] setDataNeedsReloading];
//    [[self.graph plotWithIdentifier:GRAPH_IDENTIFIER_OUTBOUND] setDataNeedsReloading];
}

//=========================================================================

- (void)updateGUI
{
    [super updateGUI];
    
    [self updateStatus];
    [self updatePlot];
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
    
    [self registerForNotifications];
}

//=========================================================================

- (void)setRepresentedObject:(id)object
{
    [super setRepresentedObject:object];
    [self updateGUI];
}

//=========================================================================
#pragma mark CPTPlotDataSource
//=========================================================================

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    RCBWMeasurementBuffer *buffer = [(RCRouter *)self.representedObject measurementsBuffer];
    return buffer.count;
}

//=========================================================================

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    RCBWMeasurementBuffer *buffer = [(RCRouter *)self.representedObject measurementsBuffer];

    if (fieldEnum == CPTScatterPlotFieldX)
    {
        RCBWMeasurement *measurement = [buffer objectAtIndex:index];
        NSTimeInterval x = [measurement.date timeIntervalSince1970];
        
        NSLog(@"X: %f", x);
        
        return [NSNumber numberWithFloat:x];
    }
    else if (fieldEnum == CPTScatterPlotFieldY)
    {
        RCBWMeasurement *measurement = [buffer objectAtIndex:index];
        CGFloat bandwidth = 0;
        
        if ([plot.identifier isEqual:GRAPH_IDENTIFIER_INBOUND])
        {
            bandwidth = measurement.inbound;
        }
//        else if ([plot.identifier isEqual:GRAPH_IDENTIFIER_OUTBOUND])
//        {
//            bandwidth = measurement.outbound;
//        }

        NSLog(@"Y: %f", bandwidth);

        return [NSNumber numberWithFloat:bandwidth];
    }

    return nil;
}

//=========================================================================
#pragma mark Notifications
//=========================================================================

- (void)routerDidUpdateRouterInfo:(NSNotification *)notification
{
    [self updateGUI];
}

//=========================================================================
@end
//=========================================================================
