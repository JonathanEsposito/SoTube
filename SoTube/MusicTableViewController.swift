//
//  MusicTableViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 09/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class MusicTableViewController: MyMusicTabBarViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties
    let reuseIdentifier = "MusicCell"
    let dummmyData = ["a", "b", "c", "d"]
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var songTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFooterHeight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let headerView = songTableView.tableFooterView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                songTableView.tableFooterView = headerView
            }
        }
    }
    
    // MARK: - Constraints Size Classes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFooterHeight()
    }
    
    // MARK: - TableView
    // MARK: DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        print("cell created")
        return cell
    }
    
    // MARK: Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        let path: String! = Bundle.main.resourcePath?.appending("/\(indexPath.row).mp3")
        let songURL = URL(fileURLWithPath: path)
        musicPlayer.play(contentOf: songURL)
        
        self.updateMiniPlayer()

        updateFooterHeight()
        print(musicPlayer.hasSong)
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return
//    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationvc = segue.destination
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let musicCollectionVC = destinationvc as? MusicCollectionViewController {
            musicCollectionVC.data = self.dummmyData
        }
    }
    
    // Private Methods
    private func updateFooterHeight() {
        let height: CGFloat
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if musicPlayer.hasSong {
                height = 94
            } else {
                height = 50
            }
        } else {
            height = 50
        }
        songTableView.tableFooterView?.frame.size.height = height
        
        // Reset tableview contentsize height
        let lastTableViewSubviewYPosition = songTableView.tableFooterView?.frame.origin.y
        let lastTableViewSubviewHeight = songTableView.tableFooterView?.bounds.height
        let newHeight = (lastTableViewSubviewYPosition ?? 0) + (lastTableViewSubviewHeight ?? 0)
        songTableView.contentSize = CGSize(width: songTableView.contentSize.width, height: newHeight)
        
        
//        tableFooterView.frame.size.height = height
        
//        print(songTableView.tableFooterView)
//        songTableView.tableFooterView?.heightAnchor.constraint(equalToConstant: 94)
//        songTableView.tableFooterView?.backgroundColor = UIColor.green
////        songTableView.
//        songTableView.setNeedsLayout()
//        songTableView.tableFooterView?.setNeedsLayout()
//        songTableView.layoutIfNeeded()
//        songTableView.tableFooterView?.layoutIfNeeded()
//        songTableView.subviews.last
        
//        tableFooterView.setNeedsLayout()
//        tableFooterView.layoutIfNeeded()
//        let rect = CGRect(x: tableFooterView.frame.origin.x, y: tableFooterView.frame.origin.y, width: tableFooterView.bounds.width
//            , height: height)
//        print(tableFooterView.bounds.height)
        
//        tableFooterView.draw(rect)
//        songTableView.reloadData()
//        songTableView.rectForRow(at: IndexPath(row: 0, section: 1))
        
    }
}
