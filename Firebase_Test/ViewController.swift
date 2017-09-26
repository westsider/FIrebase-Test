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
import SwiftyJSON

class LastPrice {
    var ticker: String?
    var date: String?
    var open: Double?
    var high: Double?
    var low: Double?
    var close: Double?
    var volume: Double?
    var signal: Double?
    
    init(ticker: String, date: String, open: Double, high:Double, low:Double, close:Double, volume:Double, signal:Double ) {
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

class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    let currentChild = "-KupyHKs9UxNJiBn1iYO"

    var userEmail = ""
 
    var lastPriceList = [LastPrice]()
    
    var json:[String:AnyObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authFirebase()
        fetchValuesFromFireBase()
        
        //MARK: - TODO make tableview
        //MARK: - TODO - only load last file?
        //MARK: - TODO - sort by date
    }
    
    func authFirebase() {
        
        ref = Database.database().reference().child(currentChild).child("Table1")
        let email = "whansen1@mac.com"
        let password = "123456"
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
   
            if error == nil {
                self.userEmail = (user?.email!)!
            } else {
                print(error ?? "something went wrong getting error")
            }
        }
    }

    func fetchValuesFromFireBase() {
    
        //observing the data changes
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                self.lastPriceList.removeAll()
                
                //iterating through all the values
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let artistObject = artists.value as? [String: AnyObject]
                    
                    let date    = artistObject?["date"] as! String
                    
                    let open    = (artistObject?["open"] as! NSString).doubleValue
 
                    let high    = (artistObject?["high"] as! NSString).doubleValue
                    
                    let low     = (artistObject?["low"] as! NSString).doubleValue
                   
                    let close   = (artistObject?["close"] as! NSString).doubleValue
                    
                    let lastPrice = LastPrice(ticker: "SPY", date: date, open: open, high: high, low: low, close: close, volume: 10000, signal: 0 )
                    //  appending it to list
                    self.lastPriceList.append(lastPrice)
                }
                
                //reloading the tableview
                //self.tableViewArtists.reloadData()
                
                for item in self.lastPriceList {
                    print(item.date!, item.open!, item.high!, item.low!, item.close!)
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

