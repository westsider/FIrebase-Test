//
//  Dates.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/2/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import UIKit

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
    
    func calcTimeFromLastUpdate(lastTime: Date)-> (String, String) {
        let date = Date()
        let calendar = Calendar.current
        let hourNow = calendar.component(.hour, from: date)
        let minuteNow = calendar.component(.minute, from: date)
        // time from trade server
        let timeString = String(describing: lastTime)
        let timeArray = timeString.components(separatedBy: " ")
        
        let mid = timeArray[1]
        let endIndex = mid.index(mid.endIndex, offsetBy: -3)
        //let truncated = mid.substring(to: endIndex)
        let truncated = mid[..<endIndex]
       
        
        let arr = truncated.components(separatedBy: ":")
        var stampHour = Int(arr[0])
        stampHour = stampHour! - 3 // adj for EST
        let stampMin = Int(arr[1])
        
        let hoursElapsed = hourNow - stampHour!
        let minsElapsed = minuteNow - stampMin!
        
       
        
        //print("elapsed: \(hoursElapsed):\(minsElapsed)")
        let timefromLast = ("\(hoursElapsed):\(minsElapsed)")
        let lastUpdate = String(describing: stampHour!)+":"+String(describing: stampMin!)
        return (timefromLast, lastUpdate)
    }
}
