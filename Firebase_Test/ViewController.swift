//
//  ViewController.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 9/25/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        
    }

    func getData() {
        
        let storageRef = Storage.storage().reference()
        
        let tableRef = storageRef.child("-KupyHKs9UxNJiBn1iYO")
        
        let fileName = "Table1"
        let spaceRef = tableRef.child(fileName)
        print("spaceRef: \(spaceRef)")
        
        let gsReference = spaceRef.parent()
        print("gsReference: \(gsReference!)")
        
        spaceRef.downloadURL(completion: { (url, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "Download URL error")
                return
            }
            
            //Now you can start downloading the image or any file from the storage using URLSession.
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error ?? "UrL Session Error")
                    return
                }
                
                guard let thisDownload = data else { return }
                
                //
                for things in thisDownload {
                    print(things);
                }
                //                DispatchQueue.main.async {
                //                    //self.imageView.image = imageData
                //                }
                
            }).resume()
        })
    }
    /*
     
     Github set up
     1. Create repository with space in name,  NO README, copy link
     2. Config, remotes. +, add remote no spaces in name, commit, push
     
     Add images to git readme
     Issues > new issue > drop in an image > copy the link > paste into my readme
     
     Github Markup  for commits
     type: subject
     body
     Footer
     
     feat: a new feature
     fix: a bug fix
     docs: changes to documentation
     style: formatting, missing semi colons, etc; no code change
     refactor: refactoring production code
     test: adding tests, refactoring test; no production code change
     chore: updating build tasks, package manager configs, etc; no production code change    */

}

