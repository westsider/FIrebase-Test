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
    
    let currentChild = "-KupyHKs9UxNJiBn1iYO"
    
    var userEmail = ""
    
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
}
