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
}

class ViewController: UIViewController {
    
    var ref: DatabaseReference!

    var userEmail = ""
    
    var lastPriceObject = LastPrice()
    
    var lastPrice = [LastPrice]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authFirebase()
        
        //MARK: - TODO - alert when new upload - get the child name
        //MARK: - TODO - find last child uploaded
    }
    
    func authFirebase() {
        
        ref = Database.database().reference()
        let email = "whansen1@mac.com"
        let password = "123456"
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
   
            if error == nil {

                self.userEmail = (user?.email!)!
                self.observeMessages()
            } else {
                print(error ?? "something went wrong getting error")
            }
        }
    }

    //Method to load Messages
    func observeMessages(){
        
        
        
        print("\nnow in observeMessages")
        // M3O9kJFvFzfmDaoGzjqqwKkFDhw2  this is user id

        let userID = Auth.auth().currentUser?.uid
        print("\nuserID: \(String(describing: userID!)) userEmail: \(userEmail)\n")
        
        let currentChild = "-KupyHKs9UxNJiBn1iYO"
        
       // lastPrice.removeAll()
        
        Database.database().reference().child(currentChild).child("Table1").queryOrderedByKey().observe(.childAdded, with:
        {
                (snapshot) in
                
                let json = snapshot.value as? [String:AnyObject]
                //print(json!)
                
//                let dates = json!["date"] as? String
//                print("\(dates!)\n")
            
                
                
                //lastPriceObject.ticker = ticker
                
                if let date = json!["date"] as? String {
                    self.lastPriceObject.date = date
                    print(date)
                } else {
                    print("No Date string")
                }
                
                if let open = json!["open"] as? Double {
                    self.lastPriceObject.open = open
                }
                
                if let high = json!["high"] as? Double {
                    self.lastPriceObject.high = high
                }
                if let low = json!["low"] as? Double {
                    self.lastPriceObject.low = low
                }
                
                if let close = json!["close"] as? Double {
                    self.lastPriceObject.close = close
                }
                self.lastPrice.append(self.lastPriceObject)
                
        })
        
//        print("lastPrice: \(self.lastPrice)")
//        for item in lastPrice {
//            print(item.date!)
//        }
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

