//
//  MainViewController.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/1/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController {
    
    @IBOutlet weak var serverConnectedLable: UILabel!
    
    @IBOutlet weak var lastPriceLabel: UILabel!
    
    @IBOutlet weak var priceDifferenceLabel: UILabel!
    
    @IBOutlet weak var priceCurrentLabel: UILabel!
    
    @IBOutlet weak var lastUpdateTime: UILabel!
    
    @IBOutlet weak var serverConnectTime: UILabel!
    
    @IBOutlet weak var lastPriceTop: UILabel!
    
    let firebaseLink = FirebaseLink()
    
    var currentLongEntryPrice:Double?
    
    var currentShortEntryPrice:Double?
    
    var myTimer = TimeUtility()
    
    var theSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Trade Server"
        firebaseLink.authFirebase()
        firebaseLink.fetchData(debug: false) { ( urlCallDone ) in
            if urlCallDone {
                print("firebase has updated the Prices Object")
                self.updateUISegmented()
            }
        }
        initNotificaationSetupCheck()
    }
    
    func initNotificaationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ])
        { ( success, error) in
            if success {
                print("\n*** Notifiation Permission Granted ***\n")
            } else {
                print("\n------------ There was a problem with permissions ---------------\n\(String(describing: error))")
            }
        }
    }
    
    @IBAction func notificationTestAction(_ sender: Any) {
        let myContent = ["Server Status", "Suspicious Price", "Last two closes were the same"] // watch skips middle subtitle
        sendNotification(content: myContent)
    }
    
    func sendNotification(content: [String]) {
        let notification = UNMutableNotificationContent()
        notification.title = content[0]
        notification.subtitle = content[1]
        notification.body = content[2]
        notification.sound = UNNotificationSound.default()
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification1", content: notification, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @IBAction func toobarTableViewAction(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "tableVC") as! TablesViewController
        myVC.lastPriceList = firebaseLink.lastPriceList
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func chartAction(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "chartVC") as! ChartViewController
        myVC.lastPriceList = firebaseLink.lastPriceList
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    func updateUISegmented() {
        let lastUpdate = firebaseLink.lastPriceList.last
        var thisClose = 00.00
        calcEntryAndOpenProfit(lastUpdate: lastUpdate!, debug: false)
        thisClose = lastPriceLableCalc(lastUpdate: lastUpdate!)
        priceDifferenceLables(thisClose: thisClose)
        serverConnectedLable(lastUpdate: lastUpdate!, debug: false)
        serverConLable(lastUpdate: lastUpdate!)
    }
    
    func calcEntryAndOpenProfit(lastUpdate: LastPrice!, debug: Bool) {
        if (debug) {
            print("\ninLong: \(String(describing: lastUpdate.inLong)) inShort: \(String(describing: lastUpdate.inShort)) longE: \(String(describing: firebaseLink.currentLongEntryPrice)) shortE: \(String(describing: firebaseLink.currentShortEntryPrice)) close: \(String(describing: lastUpdate.close))\n")
        }
        if let inLong = lastUpdate.inLong,
            let inShort = lastUpdate.inShort,
            let close = lastUpdate.close {
            
            let longE:Double = firebaseLink.currentLongEntryPrice
            let shortE:Double = firebaseLink.currentShortEntryPrice
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
            lastPriceTop?.text = "Calc Profit Failed"
        }
    }
    
    func lastPriceLableCalc(lastUpdate: LastPrice)-> Double {
        if let theClose = lastUpdate.close {
            lastPriceLabel.text = String(theClose)
            return theClose
        } else {
            lastPriceLabel.text = "loading"
            return 0.0
        }
    }
    
    func priceDifferenceLables( thisClose: Double) {
        let index = firebaseLink.lastPriceList.count
        if (index > 3) {
            let priorBar = firebaseLink.lastPriceList[index-2]
            
            if let priorClose = priorBar.close {
                let priceDiff = thisClose - priorClose
                if (priceDiff >= 0) {
                    priceDifferenceLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                // send alert if closes were the same
                if ( priceDiff == 0.0 ) {
                    let myContent = ["Server Status", "Suspicious Price", "Last two closes were the same"]
                    sendNotification(content: myContent)
                    priceDifferenceLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    priceDifferenceLabel.text = "Same Close!"
                }
                priceDifferenceLabel.text = String(format:"%.2f", priceDiff)
            } else {
                priceDifferenceLabel.text = "loading"
            }
        }
        upDateTimer()
    }
    
    //  MARK: - TODO  notify is last update > 31 minutes
    //  this only runs when the server updates, need to take this out of the loop and run every 5 mins bettween 630 - 1 pm
    //  Bottom - upper right = serverConnectTime
    //  Bottom - upper left = lastUpdateTime, Bottom - lower left = priceCurrentLabel
    func serverConnectedLable(lastUpdate: LastPrice, debug: Bool) {
     
        if (debug) {
            serverConnectTime?.text = "sConTime"
            priceCurrentLabel.text = "pCurLabel"
            lastUpdateTime.text =  "lUpdateTime"
        } else {
            if let lastTime = lastUpdate.date { // "10/12/2017 3:30:00 PM"
                
                // this is now correct
                let server = DateHelper().convertServeDateToLocal(server: lastTime, debug: true)
                let local = DateHelper().convertUTCtoLocal(debug: true, UTC: Date())
              
let alert = DateHelper().calcDiffInMinHours(from: local, server: server, debug: false)
                
                // time elaplse greater than 31 mins or 1 hour = send notifiation
                if ( alert.0 ) {
                    print("\nSending late update alert!\n")
                    let myContent = ["Server Status", "Update is Late", "Last update was \(alert.1):\(alert.2) ago"] // watch skips middle subtitle
                    sendNotification(content: myContent)
                }
                
                // data is correct
                // correct on lable
                // 5:21 elapsed not correct
                
                priceCurrentLabel.text = "\(alert.1):\(alert.2) elapsed"   // lower left
//                // correct for 9:0 to 9:00
//                var timeOfLastUpdate = convertedDate.1
//                //print(timeOfLastUpdate)
//                let firstChar =    String(timeOfLastUpdate.characters.prefix(1))
//                //print("First Char is \(firstChar)")
//                if (timeOfLastUpdate.characters.count == 3) { // 5:0
//                    timeOfLastUpdate = timeOfLastUpdate + "0"
//                } else if (timeOfLastUpdate.characters.count == 4 && firstChar == "1" ) {
//                    timeOfLastUpdate = timeOfLastUpdate + "0"
//                }
//                var calendar = Calendar.current
//                calendar.timeZone = TimeZone(identifier: "EST")!
//                let comp = calendar.dateComponents([.hour, .minute], from: server)
//                let hour = comp.hour
//                let minute = comp.minute
                lastUpdateTime.text = DateHelper().convertServeDateToLocalString(server: server, debug: true)
            }
            
            if let serverDateTime = lastUpdate.connectTime {
                let timeOnly = serverDateTime.components(separatedBy: " ")
                //print("/nIn ServerDateTime: \(serverDateTime) _______ \(timeOnly)")
                // expecting array of 3
                if ( timeOnly.count < 3 ) {
                    serverConnectTime?.text = "00:00"       // Bottom -  upper right
                    return
                }
                let arr = timeOnly[1].components(separatedBy: ":")
                //print("Arrary: \(arr[0]) \(arr[1])")
                var hour = Int(arr[0])      // hour is nil
                //print("Hour: \(String(describing: hour))")
                hour = hour! - 3 // adj for EST
                let min = arr[1]
                serverConnectTime?.text = "\(hour!)" + ":" + min    // Bottom -  upper right
            } else {
                serverConnectTime?.text = "No Data"                 // Bottom -  upper right
            }
        }

    }

    // Bottom lower right - Connected
    func serverConLable(lastUpdate: LastPrice){
        if let connectStat = lastUpdate.connectStatus {
            serverConnectedLable.text = connectStat
            let myContent = ["Server Status", "Connetion Update", connectStat] // watch skips middle subtitle
            if (connectStat != "Connected") {
                sendNotification(content: myContent)
            }
        } else {
            serverConnectedLable.text = "loading"
        }
    }
    
    func upDateTimer() {
        if ( myTimer.isMarketHours(begin: [6,35], end: [16,10])) {
            
            // 60 * 5 = 300 sec for 5 min
            myTimer.timerDuration(Seconds: 60) { ( finished ) in
                if finished {
                    DispatchQueue.main.async {
                        print("\nUpdating UI...")
                        self.updateUISegmented()
                    }
                    
                }
            }
        }
    }
    
}

