//
//  Show Entry Line.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/10/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import SciChart

class ShowEntry {
    
    var horizontalLine = SCIHorizontalLineAnnotation()
    
    func getTradeEntry(allPrices: [LastPrice])-> SCIHorizontalLineAnnotation {
        //MARK: - TODO add logic fo short or long
        let items = allPrices
        let lastBarnum = items.count
        let lastBar = allPrices.last
        let currentBar = lastBar?.currentBar
        let diff = lastBarnum - currentBar!
        
        print("\nCurrent bar \(currentBar!) items.count \(lastBarnum) diff: \(diff)")
        
        // in short
        if (lastBar?.inShort == true) {
            let currentBar  = lastBarnum - 1
            let lineLength = lastBar?.shortLineLength
            let startBar = currentBar - lineLength!
            let sellPrice = lastBar?.shortEntryPrice
            horizontalLine = addTradeEntry(SignalLine: sellPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.red, Direction: "Sold")
            print("\nCurrentBar: \(currentBar) start bar \(startBar) lastBarArray\(lastBarnum)")
        }
        // in long
        if ( lastBar?.inLong == true ) {
            let currentBar  = lastBarnum - 1
            let lineLength = lastBar?.longLineLength
            let startBar = currentBar - lineLength!
            let buyPrice = lastBar?.longEntryPrice
            horizontalLine = addTradeEntry(SignalLine: buyPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.green, Direction: "Bought")
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
            horizontalLine = addTradeEntry(SignalLine: sellPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.red, Direction: "Sell")
        } else if ( lastBar?.inLong == false ) {
            //looking long
            let currentBar  = lastBarnum - 1
            let lineLength = lastBar?.longLineLength
            let startBar = currentBar - lineLength!
            let buyPrice = lastBar?.longEntryPrice
            horizontalLine = addTradeEntry(SignalLine: buyPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.green, Direction: "Buy")
        }
        return horizontalLine
        
    }
    
    private func addTradeEntry(SignalLine: Double, StartBar: Int, EndBar: Int, Color: UIColor, Direction: String) -> SCIHorizontalLineAnnotation{
        
        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.coordinateMode = .absolute;
        horizontalLine1.x1 = SCIGeneric(StartBar)   // lower number pushes to left side of x axis
        horizontalLine1.x2 = SCIGeneric(EndBar)     // Higher number pushes bar right of x axis
        horizontalLine1.y1 = SCIGeneric(SignalLine) // the position on y (price) axis
        horizontalLine1.horizontalAlignment = .center
        horizontalLine1.isEditable = false
        horizontalLine1.style.linePen = SCISolidPenStyle.init(color: Color, withThickness: 2.0)
        horizontalLine1.add(self.buildLineTextLabel("\(Direction) \(SignalLine)", alignment: .top, backColor: UIColor.clear, textColor: Color))
        //surface.annotations.add(horizontalLine1)
        return horizontalLine1
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


