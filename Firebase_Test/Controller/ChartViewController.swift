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
    
     let annotationGroup = SCIAnnotationCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSurface()
        if UIDevice().model == "iPad" {
            addAxis(BarsToShow: 300)
        } else {
           addAxis(BarsToShow: 150)
        }
        addDefaultModifiers()
        addDataSeries()
        getTradeEntry()
        surface.annotations = annotationGroup
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
        let darkGrayPen = SCISolidPenStyle(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), withThickness: 0.5)
        let lightGrayPen = SCISolidPenStyle(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), withThickness: 0.5)
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
                        showTradesOnChart(currentBar: currentBar, signal: signal, high: high, low: low, close: close)
                    }
                }
            }
        }
        let barRenderSeries = SCIFastOhlcRenderableSeries()
        barRenderSeries.dataSeries = ohlcDataSeries
        barRenderSeries.strokeUpStyle = upWickPen
        barRenderSeries.strokeDownStyle = downWickPen
        return barRenderSeries
    }
    
    func showTradesOnChart(currentBar: Int, signal: Double, high: Double, low: Double, close:Double) {
        if(signal == 1) {
            print("\nLong signal: \(signal) on bar \(currentBar)")
            annotationGroup.add( createUpArrow(Date: currentBar, Entry: low) )
        }
        if(signal == -1) {
            print("\nShrt signal: \(signal) on bar \(currentBar)")
            annotationGroup.add( createDnArrow(Date: currentBar, Entry: high) )
        }
        
        if(signal == -2 || signal == 2) {
            print("\nExit signal: \(signal) on bar \(currentBar)")
            annotationGroup.add( createExit(Date: currentBar, Entry: close) )
        }
    }
    
    func createUpArrow(Date: Int, Entry:Double)-> SCICustomAnnotation {
        let customAnnotationGreen = SCICustomAnnotation()
        customAnnotationGreen.customView = UIImageView.init(image: UIImage.init(named: "triangleUp"))
        customAnnotationGreen.x1=SCIGeneric(Date)
        customAnnotationGreen.y1=SCIGeneric(Entry)
        return customAnnotationGreen
    }
    
    func createDnArrow(Date: Int, Entry:Double)-> SCICustomAnnotation {
        let customAnnotationGreen = SCICustomAnnotation()
        customAnnotationGreen.customView = UIImageView.init(image: UIImage.init(named: "triangleDown"))
        customAnnotationGreen.x1=SCIGeneric(Date)
        customAnnotationGreen.y1=SCIGeneric(Entry)
        return customAnnotationGreen
    }
    
    func createExit(Date: Int, Entry:Double)-> SCICustomAnnotation {
        let customAnnotationGreen = SCICustomAnnotation()
        customAnnotationGreen.customView = UIImageView.init(image: UIImage.init(named: "exit"))
        customAnnotationGreen.x1=SCIGeneric(Date)
        customAnnotationGreen.y1=SCIGeneric(Entry)
        return customAnnotationGreen
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
        let lastBarnum = items.count
        let lastBar = self.lastPriceList.last
        let currentBar = lastBar?.currentBar
        let diff = lastBarnum - currentBar!
        
        print("\nCurrent bar \(currentBar!) items.count \(lastBarnum) diff: \(diff)")
        
        // in short
        if (lastBar?.inShort == true) {
            let currentBar  = lastBarnum - 1
            let lineLength = lastBar?.shortLineLength
            let startBar = currentBar - lineLength!
            let sellPrice = lastBar?.shortEntryPrice
            addTradeEntry(SignalLine: sellPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.red, Direction: "Sold")
            print("\nCurrentBar: \(currentBar) start bar \(startBar) lastBarArray\(lastBarnum)")
        }
        // in long
        if ( lastBar?.inLong == true ) {
            let currentBar  = lastBarnum - 1
            let lineLength = lastBar?.longLineLength
            let startBar = currentBar - lineLength!
            let buyPrice = lastBar?.longEntryPrice
            addTradeEntry(SignalLine: buyPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.green, Direction: "Bought")
            print("\nLastBarnume - 1: \(currentBar) Current bar \(String(describing: lastBar?.currentBar)) items.count \(lastBarnum)")
        }
        
        // flat needs to be addressed
        
        // use market replay to test this!
        // looking long or short while in a trade? how. do. it. work.
        // might need to call this horizontalLine2
        if (lastBar?.inShort == false) {
            // looking short
            let currentBar  = lastBarnum - 1
            let lineLength = lastBar?.shortLineLength
            let startBar = currentBar - lineLength!
            let sellPrice = lastBar?.shortEntryPrice
            addTradeEntry(SignalLine: sellPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.red, Direction: "Sell")
        } else if ( lastBar?.inLong == false ) {
            //looking long
            let currentBar  = lastBarnum - 1
            let lineLength = lastBar?.longLineLength
            let startBar = currentBar - lineLength!
            let buyPrice = lastBar?.longEntryPrice
            addTradeEntry(SignalLine: buyPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.green, Direction: "Buy")
        }
        
        
    }
    
    private func addTradeEntry(SignalLine: Double, StartBar: Int, EndBar: Int, Color: UIColor, Direction: String) {

        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.coordinateMode = .absolute;
        horizontalLine1.x1 = SCIGeneric(StartBar)   // lower number pushes to left side of x axis
        horizontalLine1.x2 = SCIGeneric(EndBar)     // Higher number pushes bar right of x axis
        horizontalLine1.y1 = SCIGeneric(SignalLine) // the position on y (price) axis
        horizontalLine1.horizontalAlignment = .center
        horizontalLine1.isEditable = false
        horizontalLine1.style.linePen = SCISolidPenStyle.init(color: Color, withThickness: 2.0)
        horizontalLine1.add(self.buildLineTextLabel("\(Direction) \(SignalLine)", alignment: .top, backColor: UIColor.clear, textColor: Color))
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
