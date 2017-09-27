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
    
//    var ref: DatabaseReference!
//
//    let currentChild = "-KupyHKs9UxNJiBn1iYO"
//
//    var userEmail = ""
    
    let firebaseLink = FirebaseLink()
 
    var lastPriceList = [LastPrice]()
    
    var json:[String:AnyObject]?

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseLink.authFirebase()
        fetchValuesFromFireBase()

        //MARK: - TODO - Make a how to
        //MARK: - TODO - push prices to Firebase and see how this loads
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
    
//    func authFirebase() {
//
//        ref = Database.database().reference().child(currentChild).child("Table1")
//        let email = "whansen1@mac.com"
//        let password = "123456"
//
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//
//            if error == nil {
//                self.userEmail = (user?.email!)!
//            } else {
//                print(error ?? "something went wrong getting error")
//            }
//        }
//    }

    func fetchValuesFromFireBase() {
    
        //observing the data changes
        firebaseLink.ref.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                self.lastPriceList.removeAll()
                
                //iterating through all the values
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let artistObject = artists.value as? [String: AnyObject]
               
                    let date = DateHelper().convertToDateFrom(string: artistObject?["date"] as! String )
                    
                    let open    = (artistObject?["open"] as! NSString).doubleValue

                    let high    = (artistObject?["high"] as! NSString).doubleValue

                    let low     = (artistObject?["low"] as! NSString).doubleValue

                    let close   = (artistObject?["close"] as! NSString).doubleValue

                    let lastPrice = LastPrice(ticker: "SPY", date: date, open: open, high: high, low: low, close: close, volume: 10000, signal: 0 )
                    //  appending it to list
                    self.lastPriceList.append(lastPrice)
                }
                
                self.lastPriceList = LastPriceTable().sortPrices(arrayToSort: self.lastPriceList)
                //reloading the tableview
                self.tableview.reloadData()

                //for item in self.lastPriceList {
                //    print(item.date!, item.open!, item.high!, item.low!, item.close!)
                //}
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

