//
//  MainViewController.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/1/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    //MARK: - TODO parse connection status from NT
    @IBOutlet weak var serverConnectedLable: UILabel!
    //MARK: - TODO parse last prise from server
    @IBOutlet weak var lastPriceLabel: UILabel!
    //MARK: - TODO Clac last price difference
    @IBOutlet weak var priceDifferenceLabel: UILabel!
    //MARK: - TODO Clactime from last update to show current / late
    @IBOutlet weak var priceCurrentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Trade Server" 
        // Do any additional setup after loading the view.
    }


}
