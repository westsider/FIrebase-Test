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
        self.addTradeEntry()
        // Axis Bigger
        // make zoom Segmented Control  << - 5 Days + >>
        // dark gray background
    }

    fileprivate func addSurface() {
        surface = SCIChartSurface(frame: self.view.bounds)
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = self.view.bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(surface)
    }
    
    fileprivate func addAxis() {
        /*
         let axisStyle = SCIAxisStyle()
         
         let majorPen = SCISolidPenStyle(colorCode: 0xFF393532, withThickness: 0.5)
         let minorPen = SCISolidPenStyle(colorCode: 0xFF262423, withThickness: 0.5)
         
         let textFormat = SCITextFormattingStyle()
         textFormat.fontName = SCSFontsName.defaultFontName
         textFormat.fontSize = SCSFontSizes.defaultFontSize
         
         axisStyle.majorTickBrush = majorPen
         axisStyle.majorGridLineBrush = majorPen
         axisStyle.gridBandBrush = SCISolidBrushStyle(colorCode: 0xE1232120)
         axisStyle.minorTickBrush = minorPen
         axisStyle.minorGridLineBrush = minorPen
         axisStyle.labelStyle = textFormat
         axisStyle.drawMinorGridLines = true
         axisStyle.drawMajorBands = true
         */
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
        let darkGrayPen = SCISolidPenStyle(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), withThickness: 0.5)
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
        let last30items = Array(items.suffix(150))

        for things in last30items {
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
    
    //MARK: - Trade entry margin line
    func addTradeEntry() {
        
        let lastBar = self.lastPriceList.last
        let sellPrice = lastBar?.shortEntryPrice
        print("Last Bar Sell Price \(sellPrice!)")
        let annotationGroup = SCIAnnotationCollection()
        
        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.coordinateMode = .absolute;
        horizontalLine1.y1 = SCIGeneric(sellPrice!);
        horizontalLine1.horizontalAlignment = .stretch
        horizontalLine1.add(self.buildLineTextLabel("\(sellPrice!)", alignment: .axis, backColor: UIColor.red, textColor: UIColor.white))
        horizontalLine1.style.linePen = SCISolidPenStyle.init(color: UIColor.red, withThickness:2)
        annotationGroup.add(horizontalLine1)
        surface.annotations = annotationGroup
        
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
