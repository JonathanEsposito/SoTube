//
//  PurchaseHistoryViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 16/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class PurchaseHistoryViewController: TabBarViewController, UITableViewDelegate, UITableViewDataSource {

    
    var musicHistory = ["test", "test", "test", "test"]
    var SoCoinHistory = ["test", "test", "test", "test", "test", "test", "test"]
    
    
    @IBOutlet weak var selectHistorySegmentedController: UISegmentedControl!
    @IBOutlet weak var historyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func selectHistorySegmentedController(_ sender: UISegmentedControl) {
        historyTableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectHistorySegmentedController.selectedSegmentIndex {
        case 0:
            return musicHistory.count
        case 1:
            return SoCoinHistory.count
        default:
            return 0
        }
    }
    
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! PurchaseHistoryTableViewCell
        
        switch selectHistorySegmentedController.selectedSegmentIndex {
        case 0:
            cell.productImageView.image = #imageLiteral(resourceName: "princeCover")
            cell.productLabel.text = musicHistory[indexPath.row]
            cell.priceLabel.text = musicHistory[indexPath.row]
        case 1:
            cell.productImageView.image = #imageLiteral(resourceName: "princeCover")
            cell.productLabel.text = SoCoinHistory[indexPath.row]
            cell.priceLabel.text = SoCoinHistory[indexPath.row]
        default:
            break
        }
        
        return cell
    }
    
}
