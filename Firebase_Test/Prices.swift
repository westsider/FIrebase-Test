//
//  Prices.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 9/26/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import UIKit

/**
 - Author: Warren Hansen
 
This class will hold price data for every bar on the chart
 
 ### Declare As:
     let firebaseLink = FirebaseLink()
 ### Use Like
     
 */
class LastPrice {
    
    var ticker: String?
    var date: Date?
    var open: Double?
    var high: Double?
    var low: Double?
    var close: Double?
    var volume: Double?
    var signal: Double?
    var trade: Double?
    var bartype: String?
    var connectStatus: String?
    var connectTime: String?
    
    var longEntryPrice: Double?
    var shortEntryPrice: Double?
    
    var longLineLength: Int?
    var shortLineLength: Int?
    var currentBar: Int?
    
    var inLong: Bool?
    var inShort: Bool?  // make these no optional
    
    //MARK: - TODO add NSDATE from server
    //var barTime:Date?
    
    init(ticker: String, date: Date, open: Double, high:Double, low:Double,
         close:Double, volume:Double, signal:Double, trade:Double, bartype:String,
         connectStatus:String, connectTime:String, longEntryPrice:Double,
         shortEntryPrice:Double, longLineLength:Int, shortLineLength:Int, currentBar:Int, inLong:Bool, inShort:Bool) {
        self.ticker = ticker
        self.date = date
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
        self.signal = signal
        self.trade = trade
        self.bartype = bartype
        self.connectStatus = connectStatus
        self.connectTime = connectTime
        self.longEntryPrice = longEntryPrice
        self.shortEntryPrice = shortEntryPrice
        self.longLineLength = longLineLength
        self.shortLineLength = shortLineLength
        self.currentBar = currentBar
        self.inLong = inLong
        self.inShort = inShort
        //self.barTime = barTime
    }
    
    func sortPrices(arrayToSort: [LastPrice])-> [LastPrice] {
        
        return arrayToSort.sorted(by: { $0.date?.compare($1.date!) == .orderedAscending })
    }
}




