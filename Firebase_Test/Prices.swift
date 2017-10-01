//
//  Prices.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 9/26/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import UIKit

class LastPrice {
    var ticker: String?
    var date: Date?
    var open: Double?
    var high: Double?
    var low: Double?
    var close: Double?
    var volume: Double?
    var signal: Double?
    
    init(ticker: String, date: Date, open: Double, high:Double, low:Double, close:Double, volume:Double, signal:Double ) {
        self.ticker = ticker
        self.date = date
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
        self.signal = signal
    }
}

class LastPriceTable {
    
    func sortPrices(arrayToSort: [LastPrice])-> [LastPrice] {
        
        return arrayToSort.sorted(by: { $0.date?.compare($1.date!) == .orderedAscending })
    }
}

class DateHelper {
    func convertToDateFrom(string: String)-> Date {
        
        let dateS    = string
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date:Date = formatter.date(from: dateS)!
        return date
    }
    
    func convertToStringFrom(date: Date)-> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }
}
