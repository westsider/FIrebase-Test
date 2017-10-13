//
//  Time +  Timer.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/1/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit
import Foundation

class TimeUtility {

    let now = Date()
    
    func timerDuration(Seconds: Int , timerComplete: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(Seconds)) {
            print("timer complete \(self.now)")
            timerComplete(true)
        }
    }

    func isMarketHours(begin: [Int], end: [Int] ) -> Bool  {
        var isMakretHours: Bool
        let calendar = Calendar.current
        
        let start_today = calendar.date(
            bySettingHour: begin[0],
            minute: begin[1],
            second: 0,
            of: now)!
        
        let end_today = calendar.date(
            bySettingHour: end[0],
            minute: end[1],
            second: 0,
            of: now)!
        
        if (now >= start_today && now <= end_today ) {
            print("The time is between \(begin[0]):\(begin[1]) and \(end[0]):\(end[1])")
            isMakretHours = true
        } else {
            print("The time is outside of \(begin[0]):\(begin[1]) and \(end[0]):\(end[1])")
            isMakretHours = false
        }
        return isMakretHours
    }
}















// this is here if you want a countdown timer
/*
 var timer = Timer()
 //var seconds = 1000
 var isTimerRunning = false
 var resetSeconds = 0
 var timerDone = false
func fetchTimer(resetSec: Int , timerComplete: @escaping (Bool) -> Void) {
    timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateUI)), userInfo: nil, repeats: true)
    isTimerRunning = true
    seconds = resetSec
    resetSeconds = resetSec
    timerComplete(true)
    cancelTimer()
}


//    func runTimer(resetSec: Int ) {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateUI)), userInfo: nil, repeats: true)
//        isTimerRunning = true
//        seconds = resetSec
//        resetSeconds = resetSec
//
//    }

@objc func updateUI() {
    seconds -= 1
    print("\(timeString(time: TimeInterval(seconds)))\r", terminator: "")   //timerLabel.text = timeString(time: TimeInterval(seconds))
    //restartTimer()
    if ( seconds == 0 ) {
        timerDone = true
        print("timer done")
        seconds = resetSeconds
        print(timeString(time: TimeInterval(seconds)))     //timerLabel.text = timeString(time: TimeInterval(seconds))
        cancelTimer()
    } else {
        timerDone = false
    }
}

//    func restartTimer() {
//
//        if ( seconds == 0 ) {
//            timerDone = true
//            print("timer done")
//            seconds = resetSeconds
//            print(timeString(time: TimeInterval(seconds)))     //timerLabel.text = timeString(time: TimeInterval(seconds))
//            cancelTimer()
//        } else {
//           timerDone = false
//        }
//    }

func cancelTimer() {
    timer.invalidate()
    isTimerRunning = false
    
    
    // reset this
    seconds = resetSeconds
}
 
 
 func timeString(time:TimeInterval) -> String {
 //let hours = Int(time) / 3600
 let minutes = Int(time) / 60 % 60
 let seconds = Int(time) % 60
 //print(String(format:"%02i:%02i:%02i", hours, minutes, seconds))
 return String(format:"%02i:%02i", minutes, seconds)
 }
*/




