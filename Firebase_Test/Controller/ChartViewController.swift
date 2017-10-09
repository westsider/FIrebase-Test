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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSurface()
        addAxis(BarsToShow: 150)
        addDefaultModifiers()
        addDataSeries()
        getTradeEntry()

        // Axis Bigger - No Joy
        // white background - No joy
        
        // show only n bars
        // make zoom Segmented Control  << - 5 Days + >>

    }


    
    fileprivate func addSurface() {
        surface = SCIChartSurface(frame: self.view.bounds)
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = self.view.bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // background color
        //surface.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //surface.renderableSeriesAreaFill.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubview(surface)
    }
    
    // surface.renderableSeriesAreaBorder.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    
    fileprivate func addAxis(BarsToShow: Int) {

        let totalBars = lastPriceList.count
        let rangeStart = totalBars - BarsToShow
        // horizontal - Date axis
        let xAxis = SCICategoryDateTimeAxis()
        //xAxis.axisId = "xaxis"
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(rangeStart), max: SCIGeneric(totalBars))
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.xAxes.add(xAxis)
        
        // verticle - Price Axis
        let yAxis = SCINumericAxis()
        //yAxis.axisId = "yaxis"
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        let upBrush = SCISolidBrushStyle(colorCode: 0x9000AA00)
        let downBrush = SCISolidBrushStyle(colorCode: 0x90FF0000)
        let darkGrayPen = SCISolidPenStyle(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), withThickness: 0.5)
        let lightGrayPen = SCISolidPenStyle(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), withThickness: 0.5)
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
        //let last30items = Array(items.suffix(150))
        print("\nCount: \(items.count)")
        for things in items {
            let date:Date = things.date!
            ///print("Date OHLC: \(date) \(items[i].open!) \(items[i].high!) \(items[i].low!) \(items[i].close!)")
            ohlcDataSeries.appendX(SCIGeneric(date),
                                   open: SCIGeneric(things.open!),
                                   high: SCIGeneric(things.high!),
                                   low: SCIGeneric(things.low!),
                                   close: SCIGeneric(things.close!))
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

    func getTradeEntry() {
        //MARK: - TODO add logic fo short or long
        let items = self.lastPriceList
        let last30items = Array(items.suffix(150))
        let lastBar = last30items.last
        let sellPrice = lastBar?.shortEntryPrice
        addTradeEntry(SignalLine: sellPrice!, StartBar: 438, EndBar: 538)
    }
    
    func addTradeEntry(SignalLine: Double, StartBar: Int, EndBar: Int) {

        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.coordinateMode = .absolute;
        //horizontalLine1.xAxisId = "xaxis"
        //horizontalLine1.yAxisId = "yaxis"
        horizontalLine1.x1 = SCIGeneric(StartBar)  // lower number pushes to left side
        horizontalLine1.x2 = SCIGeneric(EndBar) // last bar is 150?
        horizontalLine1.y1 = SCIGeneric(SignalLine)
        horizontalLine1.horizontalAlignment = .center
        horizontalLine1.isEditable = false
        horizontalLine1.style.linePen = SCISolidPenStyle.init(color: UIColor.red, withThickness: 2.0)
        horizontalLine1.add(self.buildLineTextLabel("Sell \(SignalLine)", alignment: .top, backColor: UIColor.clear, textColor: UIColor.red))
        surface.annotations.add(horizontalLine1)
    }

    private func buildLineTextLabel(_ text: String, alignment: SCILabelPlacement, backColor: UIColor, textColor: UIColor) -> SCILineAnnotationLabel {
        let lineText = SCILineAnnotationLabel()
        lineText.text = text
        lineText.style.labelPlacement = alignment
        lineText.style.backgroundColor = backColor
        lineText.style.textStyle.color = textColor
        return lineText
    }

}
