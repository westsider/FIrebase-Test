//
//  ChartViewController.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/5/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//
//  MARK: - Todo annimation of circle https://github.com/foolsong/EasyChartsSwift?ref=ioscookies.com

import Foundation
import UIKit
import SciChart

class ChartViewController: UIViewController {

    var lastPriceList = [LastPrice]()
    
    var surface = SCIChartSurface()
    
    var ohlcDataSeries: SCIOhlcDataSeries!
    
    var ohlcRenderableSeries: SCIFastOhlcRenderableSeries!
    
    let showTrades = ShowTrades()
    
    let showEntry = ShowEntry()
    
    let firebaseLink = FirebaseLink()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSurface()
        if UIDevice().model == "iPad" {
            addAxis(BarsToShow: 75)
        } else {
           addAxis(BarsToShow: 150)
        }
        addDefaultModifiers()
        addDataSeries()
        surface.annotations.add( showEntry.getTradeEntry(allPrices: lastPriceList) )
        
        // try live update
        let on = false
        if (on) {
            firebaseLink.fetchData(debug: false) { ( urlCallDone ) in
                if urlCallDone {
                    print("firebase has updated the Prices Object")
                    //self.updateUISegmented()
                }
            }
        }
        
    }

    fileprivate func addSurface() {
        surface = SCIChartSurface(frame: self.view.bounds)
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = self.view.bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // background color
        surface.backgroundColor = .white
        surface.renderableSeriesAreaFill.color = .white
        surface.renderableSeriesAreaBorder = SCISolidPenStyle(color: .lightGray, withThickness: 1)
        self.view.addSubview(surface)
    }
    
    // surface.renderableSeriesAreaBorder.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    
    fileprivate func addAxis(BarsToShow: Int) {

        let totalBars = lastPriceList.count
        let rangeStart = totalBars - BarsToShow
        // horizontal - Date axis
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(rangeStart), max: SCIGeneric(totalBars))
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        // this made some of the backgroung white
        xAxis.style.gridBandBrush = SCISolidBrushStyle(color: .white)
        //xAxis.style.drawMajorBands = false -- this did not render a white background
        
        
        // Date changing major grid line color and thicknes. major grid line is line at the label position
        xAxis.style.majorGridLineBrush = SCISolidPenStyle(color: .lightGray, withThickness: 0.5)
        
        // changing minor grid line color and thicknes. minor grid lines are located between major grid lines -- ??
        xAxis.style.minorGridLineBrush = SCISolidPenStyle(color: .lightGray, withThickness: 0.5)
        // date axis label color
        xAxis.style.labelStyle.color = .darkGray
        // axis label font
        xAxis.style.labelStyle.fontName = "Helvetica"
        // axis label font size
        xAxis.style.labelStyle.fontSize = 14
        // drawing ticks is enabled by default. That lines are added just to show that such propertyes exist and what they do
        xAxis.style.drawMajorTicks = true
        xAxis.style.drawMinorTicks = true
        // drawing labels is enabled by default to. If set to false, there will be no labels on axis. Labels are placed at majot tick position
        xAxis.style.drawLabels = true
        // major ticks are marks on axis that are located at label
        // length of major tick in points
        xAxis.style.majorTickSize = 5
        
        // color and thicknes of major tick - On the Date axis
        xAxis.style.majorTickBrush = SCISolidPenStyle(color: .darkGray, withThickness: 1)
        
        // minor ticks are marks on axis that fills space between major ticks
        // length of minor tick in points
        xAxis.style.minorTickSize = 2
        // color and thicknes of minor tick  -- ??
        xAxis.style.minorTickBrush = SCISolidPenStyle(color: .darkGray, withThickness: 1)
        surface.xAxes.add(xAxis)
        
        // verticle - Price Axis
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        yAxis.axisAlignment = .right
        yAxis.autoRange = .always
        //yAxis.axisId = "PrimaryAxisId"
        
        // setting axis band color. Band is filled area between major grid lines
        yAxis.style.gridBandBrush = SCISolidBrushStyle(color: .white)
        // yAxis.style.drawMajorBands = false - this did not render a white background
        
        // changing major grid line color and thicknes. major grid line is line at the label position
        yAxis.style.majorGridLineBrush = SCISolidPenStyle(color: .lightGray, withThickness: 1)
        
        // changing minor grid line color and thicknes. minor grid lines are located between major grid lines
        yAxis.style.minorGridLineBrush = SCISolidPenStyle(color: .white, withThickness: 0.5)
        
        // set custom label provider for axis. Label provider defines text for labels
        //yAxis.labelProvider = ThousandsLabelProvider()
        // axis label color
        yAxis.style.labelStyle.color = .darkGray
        // axis label font size
        yAxis.style.labelStyle.fontSize = 12
        // major ticks are marks on axis that are located at label
        // length of major tick in points
        yAxis.style.majorTickSize = 3
        
        // color and thicknes of major tick
        yAxis.style.majorTickBrush = SCISolidPenStyle(color: .darkGray, withThickness: 0.5)
        // minor ticks are marks on axis that fills space between major ticks
        // length of minor tick in points
        yAxis.style.minorTickSize = 2
        // color and thicknes of minor tick
        yAxis.style.minorTickBrush = SCISolidPenStyle(color: .lightGray, withThickness: 0.5)

        
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        let upBrush = SCISolidBrushStyle(color: .red)
        let downBrush = SCISolidBrushStyle(color: .red)
        let darkGrayPen = SCISolidPenStyle(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), withThickness: 0.5)
        let lightGrayPen = SCISolidPenStyle(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), withThickness: 0.5)
        surface.renderableSeries.add(getBarRenderSeries(false, upBodyBrush: upBrush, upWickPen: lightGrayPen, downBodyBrush: downBrush, downWickPen: darkGrayPen, count: 30))
    }
    
    fileprivate func getBarRenderSeries(_ isReverse: Bool,
                                           upBodyBrush: SCISolidBrushStyle,
                                           upWickPen: SCISolidPenStyle,
                                           downBodyBrush: SCISolidBrushStyle,
                                           downWickPen: SCISolidPenStyle,
                                           count: Int) -> SCIFastOhlcRenderableSeries {
        
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double) // try swiftdatetime
        
        ohlcDataSeries.acceptUnsortedData = true
        let items = self.lastPriceList

        var lastLongEntryLine = 0
        var lastLongEntryPrice = 0.0
        var lastShortEntryLine = 0
        var lastShortEntryPrice = 0.0
        for things in items {
            let date:Date = things.date!
            ///print("Date OHLC: \(date) \(items[i].open!) \(items[i].high!) \(items[i].low!) \(items[i].close!)")
            ohlcDataSeries.appendX(SCIGeneric(date),
                                   open: SCIGeneric(things.open!),
                                   high: SCIGeneric(things.high!),
                                   low: SCIGeneric(things.low!),
                                   close: SCIGeneric(things.close!))
            
            // show entries and exits on chart
            if let signal = things.signal {
                if ( signal != 0 ) {
                    if let currentBar = things.currentBar,  let high = things.high, let low = things.low, let close = things.close {
                        surface.annotations = showTrades.showTradesOnChart(currentBar: currentBar, signal: signal, high: high, low: low, close: close)
                    }
                }
            }
            
            // show past long entrylines on chart
            if let longEntryLine = things.longLineLength,
                let longEntryPrice = things.longEntryPrice,
                let currentBar = things.currentBar {
                //print("\nIn looking for long entries...\(String(describing: longEntryLine)) \(lastLongEntryLine)")
                // mark last line
                if (longEntryLine == 0 && lastLongEntryLine != 0 ) {
                    //print("longEntryLine == 0 && lastLongEntryLine != 0 @ \(lastLongEntryPrice)\n")
                    let hLine = showEntry.addHorizontalLine(Long: true, Price: lastLongEntryPrice, LineLength: lastLongEntryLine, CurrentBar: currentBar)
                    surface.annotations.add( hLine )
                }
                lastLongEntryLine = longEntryLine
                lastLongEntryPrice = longEntryPrice
            }
            // show past short entrylines on chart
            if let shortEntryLine = things.shortLineLength, let shortEntryPrice = things.shortEntryPrice, let currentBar = things.currentBar {
                // mark last line
                if (shortEntryLine == 0 && lastShortEntryLine != 0 ) {
                    let hLine = showEntry.addHorizontalLine(Long: false, Price: lastShortEntryPrice, LineLength: lastShortEntryLine, CurrentBar: currentBar)
                    surface.annotations.add( hLine )
                }
                lastShortEntryLine = shortEntryLine
                lastShortEntryPrice = shortEntryPrice
            }
        }
        let barRenderSeries = SCIFastOhlcRenderableSeries()
        barRenderSeries.dataSeries = ohlcDataSeries
        barRenderSeries.strokeUpStyle = upWickPen
        barRenderSeries.strokeDownStyle = downWickPen
        return barRenderSeries
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        let extendZoomModifier = SCIZoomExtentsModifier()
        let pinchZoomModifier = SCIPinchZoomModifier()
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        
        let marker = SCIEllipsePointMarker()
        marker.width = 20
        marker.height = 20
        marker.strokeStyle = SCISolidPenStyle(colorCode:0xFF390032,withThickness:0.25)
        marker.fillStyle = SCISolidBrushStyle(colorCode:0xE1245120)
        rolloverModifier.style.pointMarker = marker
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        surface.chartModifiers = groupModifier
    }
}
