//
//  TableViewController.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 9/25/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit
import Firebase

class TablesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var lastPriceList = [LastPrice]()

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
}
