//
//  FireBaseLink.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 9/26/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseLink {
    
    var ref: DatabaseReference!
    
    var userEmail = ""
    
    var lastPriceList = [LastPrice]()
    
    var currentLongEntryPrice:Double?
    
    var currentShortEntryPrice:Double?
    
    var currentShortAndLong:(Double,Double)?
    
    func authFirebase() {
        
        ref = Database.database().reference()//.child(currentChild) //.child("Table1")
        let email = "whansen1@mac.com"
        let password = "123456"
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                self.userEmail = (user?.email!)!
                print("\nSigned into Firebase as: \(self.userEmail)\n")
            } else {
                print(error ?? "something went wrong getting error")
            }
        }
    }
    
    func fetchData(debug: Bool, dataComplete: @escaping (Bool) -> Void) {
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                self.lastPriceList.removeAll()
                
                for items in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    // get all other values ticker ect
                    let data    = items.value as? [String: AnyObject]
                    
                    let ticker  = data?["ticker"] as! String
                    let date    = DateHelper().convertToDateFrom(string: data?["date"] as! String )
                    let open    = data?["open"] as! Double
                    let high    = data?["high"] as! Double
                    let low     = data?["low"] as! Double
                    let close   = data?["close"] as! Double
                    
                    let signal  = data?["signal"] as! Double
                    
                    let trade   = data?["trade"] as! Double
                    let bartype = data?["bartype"] as! String
                    
                    let connectStatus = data?["connectStatus"] as! String
                    let connectTime = data?["connectTime"] as! String
                    
                    let longEntryPrice = data?["longEntryPrice"] as! Double
                    let shortEntryPrice = data?["shortEntryPrice"] as! Double
                    
                    if (trade == 1) {
                        //print("Long Entry")
                        self.currentLongEntryPrice = longEntryPrice
                    }
                    if (trade == -1) {
                        // print("Short Entry")
                        self.currentShortEntryPrice = shortEntryPrice
                    }
                    
                    let longLineLength = data?["longLineLength"] as! Int
                    let shortLineLength = data?["shortLineLength"] as! Int
                    let currentBar = data?["currentBar"] as! Int
                    
                    let inLong = data?["inLong"] as! Bool  // = (boolValue as! CFBoolean) as Bool
                    let inShort = data?["inShort"] as! Bool
                    
                    let lastPrice = LastPrice(ticker: ticker, date: date, open: open ,
                                              high: high, low: low, close: close, volume: 10000,
                                              signal: signal, trade: trade, bartype: bartype,
                                              connectStatus: connectStatus, connectTime: connectTime,
                                              longEntryPrice: longEntryPrice, shortEntryPrice: shortEntryPrice,
                                              longLineLength: longLineLength, shortLineLength: shortLineLength,
                                              currentBar: currentBar, inLong: inLong, inShort: inShort)
                    self.lastPriceList.append(lastPrice)
                }
                
                if(debug) {
                    for item in self.lastPriceList {
                        print(item.date!, item.ticker!, item.open!, item.high!, item.low!, item.close!,
                              item.signal!, item.trade!, item.bartype!, item.connectStatus!, item.connectTime!, item.longEntryPrice!, item.shortEntryPrice!, item.longLineLength!, item.shortLineLength!, item.currentBar!, item.inLong!, item.inShort!)
                       // self.counter = self.counter + 1
                    }
                }
                dataComplete(true) // i put this after the network call and the real write
            }
        })
    }
}
