//
//  PurchaseHistoryViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 16/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class PurchaseHistoryViewController: TabBarViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK : - Properties
    @IBOutlet weak var selectHistorySegmentedController: UISegmentedControl!
    @IBOutlet weak var historyTableView: UITableView!
    
    var SoCoinHistory: [CoinPurchase] = []
    var musicHistory: [Track] = []  {
        didSet {
            historyTableView.reloadData()
        }
    }
    
    let database = DatabaseViewModel()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database.getCoinHistory { coinPurchases in
            let sortedCoinPurchases = coinPurchases.sorted {
                $0.date > $1.date
            }
            
            self.SoCoinHistory.append(contentsOf: sortedCoinPurchases)
        }
        
        database.getTracks { musicPurchases in
            let sortedMusicPurchases = musicPurchases.sorted(by: {
                $0.dateOfPurchase! > $1.dateOfPurchase!
            })
            self.musicHistory.append(contentsOf: sortedMusicPurchases)
            
        }
    }
    
    
    // MARK: - TableView
    // MARK: Data source
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
    
    // MARK: Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! PurchaseHistoryTableViewCell
        
        switch selectHistorySegmentedController.selectedSegmentIndex {
        case 0:
            let trackPurchase = musicHistory[indexPath.row]
            cell.productImageView.image(fromLink: trackPurchase.coverUrl)
            cell.dateLabel.text = trackPurchase.dateString
            cell.productLabel.text = trackPurchase.name
            if let price = trackPurchase.priceInCoins {
                print(price)
                cell.priceLabel.text = "\(price) SoCoins"
            }
        case 1:
            let coinPurchase = SoCoinHistory[indexPath.row]
            cell.productImageView.image = #imageLiteral(resourceName: "coin")
            print(coinPurchase.dateString)
            cell.dateLabel.text = "\(coinPurchase.dateString)"
            cell.productLabel.text = "\(coinPurchase.amount) SoCoins"
            cell.priceLabel.text = "\(coinPurchase.price) €"
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - IBActions
    @IBAction func selectHistorySegmentedController(_ sender: UISegmentedControl) {
        historyTableView.reloadData()
    }
    
}
