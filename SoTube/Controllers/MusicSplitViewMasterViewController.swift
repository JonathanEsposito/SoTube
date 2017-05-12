//
//  SplitViewMasterViewController.swift
//  SoTube
//
//  Created by .jsber on 11/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class MusicSplitViewMasterViewController: MyMusicTabBarViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties
    @IBOutlet weak var musicTableView: UITableView!
    let dummmyData = ["a", "b", "c", "d"]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as? MusicSplitViewMasterTableViewCell else {
            fatalError("not the right Cell")
        }
        
        if self.title == "Genres" {
            cell.nameLabel.text = "Genre Name"
        } else if self.title == "Artists" {
            cell.nameLabel.text = "Artist Name"
        }
        
        return cell
    }
    
    // MARK: Delegate

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationvc = segue.destination
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let musicCollectionVC = destinationvc as? MusicSplitViewDetailViewController {
            musicCollectionVC.data = self.dummmyData
            destinationvc.navigationItem.title = selectedName ?? ""
        }
        
        
    }
    
    var selectedName: String? {
        if let selectedIndexPath = musicTableView.indexPathForSelectedRow {
            if let selectedCell = musicTableView.cellForRow(at: selectedIndexPath) as? MusicSplitViewMasterTableViewCell {
                return selectedCell.nameLabel.text
            }
        }
        return nil
    }

}
