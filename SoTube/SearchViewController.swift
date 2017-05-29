//
//  SearchViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 29/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var spotifyModel = SpotifyModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateSearch() {
        if let searchQuery = searchBar.text {
            let url = spotifyModel.getSearchUrl(for: searchQuery, ofTypes: [.track], amount: 50, offSet: 0)
        }
        
    }
    
}
