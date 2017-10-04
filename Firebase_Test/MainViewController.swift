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
    

    let firebaseLink = FirebaseLink()
    
    var lastPriceList = [LastPrice]()
    
    var json:[String:AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Trade Server"
        firebaseLink.authFirebase()
        fetchValuesFromFireBase(debug: false)
        updateUI()
    }
    
    func updateUI() {
        let lastUpdate = lastPriceList.last
        
        var thisClose = 00.00
        
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
            serverConnectTime?.text = timeOnly[1]
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
                    
                    let lastPrice = LastPrice(ticker: ticker, date: date, open: open ,
                                              high: high, low: low, close: close, volume: 10000,
                                              signal: signal, trade: trade, bartype: bartype,
                                              connectStatus: connectStatus, connectTime: connectTime )
                    self.lastPriceList.append(lastPrice)
                }
                
                self.lastPriceList = LastPriceTable().sortPrices(arrayToSort: self.lastPriceList)
                //self.tableview.reloadData()
                self.updateUI()
                
                if(debug) {
                    for item in self.lastPriceList {
                        print(item.date!, item.ticker!, item.open!, item.high!, item.low!, item.close!,
                              item.signal!, item.signal!, item.trade!, item.bartype!)
                    }
                }
                
            }
        })
    }
   
}
