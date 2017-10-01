//
//  ViewController.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 9/25/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let firebaseLink = FirebaseLink()
 
    var lastPriceList = [LastPrice]()
    
    var json:[String:AnyObject]?

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseLink.authFirebase()
        fetchValuesFromFireBase(debug: false)
  
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastPriceList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = DateHelper().convertToStringFrom(date: lastPriceList[indexPath.row].date!)
        cell.detailTextLabel?.text = String(describing: lastPriceList[indexPath.row].close!)
        return cell
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
                    
                    let lastPrice = LastPrice(ticker: ticker, date: date, open: open ,
                                              high: high, low: low, close: close, volume: 10000,
                                              signal: signal, trade: trade, bartype: bartype )
                    self.lastPriceList.append(lastPrice)
                }
                
                self.lastPriceList = LastPriceTable().sortPrices(arrayToSort: self.lastPriceList)
                self.tableview.reloadData()

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




