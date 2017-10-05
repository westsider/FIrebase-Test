//
//  MainViewController.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/1/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var serverConnectedLable: UILabel!
    
    @IBOutlet weak var lastPriceLabel: UILabel!
    
    @IBOutlet weak var priceDifferenceLabel: UILabel!
    
    @IBOutlet weak var priceCurrentLabel: UILabel!
    
    @IBOutlet weak var lastUpdateTime: UILabel!
    
    @IBOutlet weak var serverConnectTime: UILabel!
    
    @IBOutlet weak var lastPriceTop: UILabel!
    
    let firebaseLink = FirebaseLink()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Trade Server"
        firebaseLink.authFirebase()
  
        firebaseLink.fetchData(debug: false) { ( urlCallDone ) in
            if urlCallDone {
                print("network call finished")
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        
        let lastUpdate = firebaseLink.lastPriceList.last
        
        var thisClose = 00.00
        
        //print("inLong: \(String(describing: lastUpdate?.inLong)) inShort: \(String(describing: lastUpdate?.inLong)) ")

        if let inLong = lastUpdate?.inLong, let inShort = lastUpdate?.inShort, let longE:Double = firebaseLink.currentLongEntryPrice, let shortE:Double = firebaseLink.currentShortEntryPrice, let close = lastUpdate?.close {

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
        

        let index = firebaseLink.lastPriceList.count
        if (index > 3) {
            let priorBar = firebaseLink.lastPriceList[index-2]
            
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
   
}
