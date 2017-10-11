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
        let items = allPrices
        let lastBarnum = items.count
        let lastBar = allPrices.last
        let currentBar = (lastBar?.currentBar)! - 1
        let buyPrice = lastBar?.longEntryPrice
        let sellPrice = lastBar?.shortEntryPrice
        let shortLineLength = lastBar?.shortLineLength
        let longLineLength = lastBar?.longLineLength
        
        // in long looking short
        if (lastBar?.inLong == true && sellPrice != 0 ) {
            let startBar = currentBar - shortLineLength!
            horizontalLine = addTradeEntry(SignalLine: sellPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.red, Direction: "Sold")
            print("\nCurrentBar: \(currentBar) start bar \(startBar) lastBarArray\(lastBarnum)")
        }
        
        // in long but no short yet
        if (lastBar?.inLong == true && sellPrice == 0 ) {
            let startBar = currentBar - longLineLength!
            horizontalLine = addTradeEntry(SignalLine: buyPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.green, Direction: "Bought")
            print("\nLastBarnume - 1: \(currentBar) Current bar \(String(describing: lastBar?.currentBar)) items.count \(lastBarnum)")
        }
        
        // in short looking long
        if ( lastBar?.inShort == true && buyPrice != 0) {
            let startBar = currentBar - longLineLength!
            horizontalLine = addTradeEntry(SignalLine: buyPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.green, Direction: "Bought")
            print("\nLastBarnume - 1: \(currentBar) Current bar \(String(describing: lastBar?.currentBar)) items.count \(lastBarnum)")
        }
        // in short but no long yet
        if ( lastBar?.inShort == true && buyPrice == 0 ) {
            let startBar = currentBar - shortLineLength!
            horizontalLine = addTradeEntry(SignalLine: sellPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.red, Direction: "Sold")
            print("\nCurrentBar: \(currentBar) start bar \(startBar) lastBarArray\(lastBarnum)")
        }
        // flat
        if (lastBar?.inShort == false && lastBar?.inLong == false )  {
            // looking short
            if ( sellPrice != 0) {
                let startBar = currentBar - shortLineLength!
                horizontalLine = addTradeEntry(SignalLine: sellPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.red, Direction: "Sell")
                // looking long
            } else if ( buyPrice != 0 ) {
                let startBar = currentBar - longLineLength!
                horizontalLine = addTradeEntry(SignalLine: buyPrice!, StartBar: startBar, EndBar: currentBar, Color: UIColor.green, Direction: "Buy")
            }
        }
        return horizontalLine
        
    }
    
    func addHorizontalLine(Long: Bool, Price: Double, LineLength: Int, CurrentBar: Int) -> SCIHorizontalLineAnnotation {
        let startBar = CurrentBar - LineLength
        if ( Long ) {
            horizontalLine = addTradeEntry(SignalLine: Price, StartBar: startBar, EndBar: CurrentBar, Color: UIColor.green, Direction: "L ")
        } else {
            horizontalLine = addTradeEntry(SignalLine: Price, StartBar: startBar, EndBar: CurrentBar, Color: UIColor.red, Direction: "S ")
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


