//
//  ViewController.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 9/25/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//
    /*
    firebase instructions
    new ios project, NEW FIREBASE PROJECT + NEW ios project, download install plsit, 
    pod ** copy current list **
    app delegate import Firebase, Firebase.configure()
    firebase / auth / add auth method / enable email/pass / add user/pass manually
 
    firebase Database rules
     {
     "rules": {
     ".read": true,
     ".write": "auth == null"
     }
     }}
     }
 
    */

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
  
        //MARK: - TODO - Make a how to
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
                    
                    //MARK: - TODO - Fix date format 00:00
                    // get all other values ticker ect
                    let data    = items.value as? [String: AnyObject]
                    let date    = DateHelper().convertToDateFrom(string: data?["date"] as! String )
                    let open    = data?["open"] as! Double
                    let high    = data?["high"] as! Double
                    let low     = data?["low"] as! Double
                    let close   = data?["close"] as! Double
                    let lastPrice = LastPrice(ticker: "SPY", date: date, open: open ,
                                              high: high, low: low, close: close, volume: 10000, signal: 0 )
                    self.lastPriceList.append(lastPrice)
                }
                
                self.lastPriceList = LastPriceTable().sortPrices(arrayToSort: self.lastPriceList)
                self.tableview.reloadData()

                if(debug) {
                    for item in self.lastPriceList {
                        print(item.date!, item.open!, item.high!, item.low!, item.close!)
                    }
                }
                
            }
        })
    }
}



/*
 <script src="https://www.gstatic.com/firebasejs/4.4.0/firebase.js"></script>
 <script>
 // Initialize Firebase
 var config = {
 apiKey: "AIzaSyCCHm4SuTobNHLB9k9xLHJSSUkxR9Js0hI",
 authDomain: "mtdash01.firebaseapp.com",
 databaseURL: "https://mtdash01.firebaseio.com",
 projectId: "mtdash01",
 storageBucket: "mtdash01.appspot.com",
 messagingSenderId: "634510800862"
 };
 firebase.initializeApp(config);
 </script>
 */

