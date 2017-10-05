//
//  MainViewController.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/1/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    @IBOutlet weak var serverConnectedLable: UILabel!
    
    @IBOutlet weak var lastPriceLabel: UILabel!
    
    @IBOutlet weak var priceDifferenceLabel: UILabel!
    
    @IBOutlet weak var priceCurrentLabel: UILabel!
    
    @IBOutlet weak var lastUpdateTime: UILabel!
    
    @IBOutlet weak var serverConnectTime: UILabel!
    
    @IBOutlet weak var lastPriceTop: UILabel!
    
    let firebaseLink = FirebaseLink()
    
    var lastPriceList = [LastPrice]()
    
    var json:[String:AnyObject]?
    
    var counter = 0;
    
    var currentLongEntryPrice:Double?
    
    var currentShortEntryPrice:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Trade Server"
        firebaseLink.authFirebase()
        fetchValuesFromFireBase(debug: false)
    }
    
    func updateUI() {
        
        let lastUpdate = lastPriceList.last
        
        var thisClose = 00.00
        
        print("inLong: \(String(describing: lastUpdate?.inLong)) inShort: \(String(describing: lastUpdate?.inLong)) ")

        if let inLong = lastUpdate?.inLong, let inShort = lastUpdate?.inShort, let longE:Double = currentLongEntryPrice, let shortE:Double = currentShortEntryPrice, let close = lastUpdate?.close {

            var lastPriceUpdateTop:String?
            
            lastPriceTop.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            
            if (inLong) {
                // clac Long Profit
                let longProfit = close - longE
                lastPriceUpdateTop = "Long \(String(describing: longE)) \(String(format: "%.2f", longProfit))"
                if (longProfit < 0) {
                    lastPriceTop.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            } else if (inShort) {
                // clac short Profit
                let shortProfit =   shortE - close
                //let shortP = String(format: "%.2f", shortProfit)
                lastPriceUpdateTop = "Short \(String(describing: shortE)) \(String(format: "%.2f", shortProfit))"
                if (shortProfit < 0){
                    lastPriceTop.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            } else {
                lastPriceUpdateTop = "System Is Flat"
                lastPriceTop.textColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
            }
            
            lastPriceTop?.text = lastPriceUpdateTop!
        } else {
            print("parse inTade failed")
        }
        
        if let connectStat = lastUpdate?.connectStatus {
            serverConnectedLable.text = connectStat
        } else {
            serverConnectedLable.text = "loading"
        }

        if let theClose = lastUpdate?.close {
            lastPriceLabel.text = String(theClose)
            thisClose = theClose
        } else {
            lastPriceLabel.text = "loading"
        }
        

        let index = lastPriceList.count
        if (index > 3) {
            let priorBar = lastPriceList[index-2]
            
            if let priorClose = priorBar.close {
                let priceDiff = thisClose - priorClose
                if (priceDiff >= 0) {
                    priceDifferenceLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                priceDifferenceLabel.text = String(format:"%.2f", priceDiff)
            } else {
                priceDifferenceLabel.text = "loading"
            }
        }
        
        if let lastTime = lastUpdate?.date {
            let convertedDate = DateHelper().calcTimeFromLastUpdate(lastTime: lastTime)
            priceCurrentLabel.text = convertedDate.0
            lastUpdateTime.text = convertedDate.1
        }
        
        if let serverDateTime = lastUpdate?.connectTime {
            let timeOnly = serverDateTime.components(separatedBy: " ")
            let arr = timeOnly[1].components(separatedBy: ":")
            var hour = Int(arr[0])
            hour = hour! - 3 // adj for EST
            let min = arr[1]
            serverConnectTime?.text = "\(hour!)" + ":" + min
        }
    }

    func fetchValuesFromFireBase(debug: Bool) {
        
        firebaseLink.ref.observe(DataEventType.value, with: { (snapshot) in
            
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
                        print("Long Entry")
                        self.currentLongEntryPrice = longEntryPrice
                    }
                    if (trade == -1) {
                         print("Short Entry")
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
                        self.counter = self.counter + 1
                    }
                }
                
                self.updateUI()
            }
        })
    }
   
}
