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
    
    let database = DatabaseViewModel()
    var genres: [String] = []
    var artists: [Artist] = [] {
        didSet {
            musicTableView.reloadData()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set tabBar and miniPlayer
        setTabBarAndMiniPlayerVisibility()
        
        // Get all artists from owned tracks
        database.getArtists { [weak self] artists in
            DispatchQueue.main.async {
                // Return artist sorted by name
                self?.artists = artists.sorted { $0.artistName < $1.artistName }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set tabBar and miniPlayer
        setTabBarAndMiniPlayerVisibility()
    }
    
    // MARK: - Constraints Size Classes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFooterHeight()
    }
    
    // MARK: - TableView
    // MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.title == "Genres"{
            return genres.count
        } else if self.title == "Artists" {
            return artists.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as? MusicSplitViewMasterTableViewCell else {
            fatalError("not the right Cell")
        }
        // Remove previous image to prevent flickering on scroll (or wrongly displayd images)
        cell.itemImageView.image = nil
        // Set values
        if self.title == "Genres" {
            cell.nameLabel.text = "Genre Name"
        } else if self.title == "Artists" {
            let artist = artists[indexPath.row]
            cell.itemImageView.image(fromLink: artist.artistCoverUrl)
            cell.nameLabel.text = artist.artistName
        }
        return cell
    }
    
    // MARK: Delegate

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get indexpath from sender as cell
        guard let itemCell = sender as? MusicSplitViewMasterTableViewCell else { print("wrong sender"); return }
        guard let indexPath = self.musicTableView.indexPath(for: itemCell) else { print("cell not from this collection"); return }
        let index = indexPath.row
        
        // If the segue destination is a navigationController, get the embeded viewController from this navigationController
        var destinationvc = segue.destination
        if let navcon = segue.destination as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        
        // Cast destination vc
        if let musicCollectionVC = destinationvc as? MusicSplitViewDetailViewController {
            if self.title == "Genres" {
                let genre = genres[index]
                musicCollectionVC.genre = genre
                musicCollectionVC.navigationItem.title = genre
            } else if self.title == "Artists" {
                let artist = artists[index]
                musicCollectionVC.artist = artist
                musicCollectionVC.navigationItem.title = artist.artistName
            }
        }
    }
    
    // MARK: - Private Methods
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
        musicTableView.tableFooterView?.frame.size.height = height
    }
    
    private func setTabBarAndMiniPlayerVisibility() {
        // If this viewController is fullscreen (iPhone), show miniPlayer otherwise, detailView will have player and we need to hide it here
        if UIScreen.main.bounds.width != self.view.bounds.width {
            self.view.subviews.forEach {
                if let miniPlayer = miniPlayer {
                    if $0 == miniPlayer {
                        $0.isHidden = true
                    }
                    if $0 == musicProgressView {
                        $0.isHidden = true
                    }
                }
            }
        } else {
            self.view.subviews.forEach {
                if let miniPlayer = miniPlayer {
                    if $0 == miniPlayer {
                        $0.isHidden = false
                    }
                    if $0 == musicProgressView {
                        $0.isHidden = false
                    }
                }
            }
        }
    }
}
