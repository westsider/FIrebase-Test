//
//  ChartViewController.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/5/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import UIKit
import SciChart

class ChartViewController: UIViewController {

    var lastPriceList = [LastPrice]()
    
    var surface = SCIChartSurface()
    
    var ohlcDataSeries: SCIOhlcDataSeries!
    
    var ohlcRenderableSeries: SCIFastOhlcRenderableSeries!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSurface()
        self.addAxis()
        self.addDefaultModifiers()
        self.addDataSeries()
        //self.addTradeEntry()
    }

    fileprivate func addSurface() {
        surface = SCIChartSurface(frame: self.view.bounds)
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = self.view.bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(surface)
    }
    
    fileprivate func addAxis() {
        //let xAxis = SCIDateTimeAxis()
        //let xAxis = SCINumericAxis()
        let xAxis = SCICategoryDateTimeAxis()
        
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        let upBrush = SCISolidBrushStyle(colorCode: 0x9000AA00)
        let downBrush = SCISolidBrushStyle(colorCode: 0x90FF0000)
        let upWickPen = SCISolidPenStyle(colorCode: 0xFF00AA00, withThickness: 0.7)
        let downWickPen = SCISolidPenStyle(colorCode: 0xFFFF0000, withThickness: 0.7)
        
        surface.renderableSeries.add(getCandleRenderSeries(false, upBodyBrush: upBrush, upWickPen: upWickPen, downBodyBrush: downBrush, downWickPen: downWickPen, count: 30))
    }
    
    fileprivate func getCandleRenderSeries(_ isReverse: Bool,
                                           upBodyBrush: SCISolidBrushStyle,
                                           upWickPen: SCISolidPenStyle,
                                           downBodyBrush: SCISolidBrushStyle,
                                           downWickPen: SCISolidPenStyle,
                                           count: Int) -> SCIFastCandlestickRenderableSeries {
        
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double) // try swiftdatetime
        
        ohlcDataSeries.acceptUnsortedData = true
        let items = self.lastPriceList
        let last30items = Array(items.suffix(10))

        for things in last30items {
            let date:Date = things.date!
            ///print("Date OHLC: \(date) \(items[i].open!) \(items[i].high!) \(items[i].low!) \(items[i].close!)")
            ohlcDataSeries.appendX(SCIGeneric(date),
                                   open: SCIGeneric(things.open!),
                                   high: SCIGeneric(things.high!),
                                   low: SCIGeneric(things.low!),
                                   close: SCIGeneric(things.close!))
        }
        let candleRendereSeries = SCIFastCandlestickRenderableSeries()
        candleRendereSeries.dataSeries = ohlcDataSeries
        candleRendereSeries.fillUpBrushStyle = upBodyBrush
        candleRendereSeries.fillDownBrushStyle = downBodyBrush
        candleRendereSeries.strokeUpStyle = upWickPen
        candleRendereSeries.strokeDownStyle = downWickPen
        
        return candleRendereSeries
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
