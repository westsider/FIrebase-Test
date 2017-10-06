//
//  MainViewModel.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/5/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import UIKit

class MainViewModel {
    
    func updateLastPrice(lastPriceList: [LastPrice], currentShortLong: (Double, Double))-> (String, UIColor) {

        let lastUpdate = lastPriceList.last
        var lastPriceUpdateTop = "Starting Update"
        var textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)

        // not getting the righ objects
        if let inLong = lastUpdate?.inLong, let inShort = lastUpdate?.inShort, let longE:Double = currentShortLong.1, let shortE:Double =  currentShortLong.0, let close = lastUpdate?.close {

            if (inLong) {
                // clac Long Profit
                let longProfit = close - longE
                lastPriceUpdateTop = "Long \(String(describing: longE)) \(String(format: "%.2f", longProfit))"
                if (longProfit < 0) {
                    textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            } else if (inShort) {
                // clac short Profit
                let shortProfit =   shortE - close
                //let shortP = String(format: "%.2f", shortProfit)
                lastPriceUpdateTop = "Short \(String(describing: shortE)) \(String(format: "%.2f", shortProfit))"
                if (shortProfit < 0){
                    textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            } else {
                lastPriceUpdateTop = "System Is Flat"
                textColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
            }

            //lastPriceTop?.text = lastPriceUpdateTop!
        } else {
            lastPriceUpdateTop = "Update failed"
        }

        return ( lastPriceUpdateTop, textColor )
    }
}
