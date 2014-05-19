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

#define GRAPH_VISIBLE_TIME_INTERVAL 60 * 10 //10 mins
#define GRAPH_IDENTIFIER_INBOUND    @"Inbound"
#define GRAPH_IDENTIFIER_OUTBOUND   @"Outbound"

@interface RCNetworkStatusViewController () <CPTPlotDataSource>
@property (nonatomic) CPTXYGraph *graph;
@property (nonatomic) NSDate *referenceDateInPast;
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

    NSDate *now = [NSDate date];
    NSTimeInterval timeIntervalSinceReferenceDate = [now timeIntervalSinceDate:self.referenceDateInPast] - GRAPH_VISIBLE_TIME_INTERVAL;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(timeIntervalSinceReferenceDate) length:CPTDecimalFromDouble(GRAPH_VISIBLE_TIME_INTERVAL)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(maxBandwidthValue)];
}

//=========================================================================

- (CPTScatterPlot *)initializedPlotWithIdentifier:(NSString *)identifier lineColor:(CPTColor *)lineColor gradientStartColor:(CPTColor *)gradientStartColor
{
    //Create bandwidth outbound plot
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
    plot.identifier = identifier;
    plot.dataSource = self;

    CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 1.5;
    lineStyle.lineColor = lineColor;
    plot.dataLineStyle = lineStyle;

    //Put an area gradient under the plot above
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:gradientStartColor endingColor:[CPTColor clearColor]];
    areaGradient.angle = -90.0;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    plot.areaFill = areaGradientFill;
    plot.areaBaseValue = CPTDecimalFromDouble(1.75);
    
    return plot;
}

//=========================================================================

- (void)initializeGraph
{
    //Define reference date for relative calculations
    self.referenceDateInPast = [NSDate dateWithTimeIntervalSinceNow:-60*25];
    
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

    //Create inboud plot
    CPTScatterPlot *plot = [self initializedPlotWithIdentifier:GRAPH_IDENTIFIER_INBOUND
                                                     lineColor:[CPTColor colorWithComponentRed:0.4 green:1.0 blue:0.4 alpha:1.0]
                                            gradientStartColor:[CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8]];

    //Add plot to the graph
    [graph addPlot:plot];

    //Create outbound plot
    plot = [self initializedPlotWithIdentifier:GRAPH_IDENTIFIER_OUTBOUND
                                     lineColor:[CPTColor colorWithComponentRed:1.0 green:0.4 blue:0.4 alpha:1.0]
                            gradientStartColor:[CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8]];
    
    //Add plot to the graph
    [graph addPlot:plot];
}

//=========================================================================

- (void)updatePlot
{
    CPTXYGraph *graph = self.graph;
    [self configureSpaceForGraph:graph measurementsBuffer:[(RCRouter *)self.representedObject measurementsBuffer]];
    
    [[self.graph plotWithIdentifier:GRAPH_IDENTIFIER_INBOUND] setDataNeedsReloading];
    [[self.graph plotWithIdentifier:GRAPH_IDENTIFIER_OUTBOUND] setDataNeedsReloading];
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

    [self initializeGraph];

    self.downloadTextField.textColor = [NSColor colorWithCalibratedRed:0.5 green:1.0 blue:0.5 alpha:1.0];
    self.uploadTextField.textColor = [NSColor colorWithCalibratedRed:1.0 green:0.5 blue:0.5 alpha:1.0];

    [self updateGUI];
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
        NSTimeInterval timeIntervalSinceReferenceDate = [measurement.date timeIntervalSinceDate:self.referenceDateInPast];
        
        return [NSNumber numberWithFloat:timeIntervalSinceReferenceDate];
    }
    else if (fieldEnum == CPTScatterPlotFieldY)
    {
        RCBWMeasurement *measurement = [buffer objectAtIndex:index];
        CGFloat bandwidth = 0;
        
        if ([plot.identifier isEqual:GRAPH_IDENTIFIER_INBOUND])
        {
            bandwidth = measurement.inbound;
        }
        else if ([plot.identifier isEqual:GRAPH_IDENTIFIER_OUTBOUND])
        {
            bandwidth = measurement.outbound;
        }

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
