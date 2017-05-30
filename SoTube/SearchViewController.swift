//
//  SearchViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 29/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var spotifyModel = SpotifyModel()
    var albums: [Album] = []
    var artists: [Artist] = []
    var tracks: [Track] = []
    var playlists: [Playlist] = []
    let searchController = UISearchController(searchResultsController: nil)
    var typePicker: UISearchBar?
    
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Albums", "Artists", "Tracks", "Playlists"]
        searchTableView.tableHeaderView = searchController.searchBar
        
        // Setup UISearchBar
        typePicker = searchController.searchBar
        
        updateHeaderHeight()
    }
    
    // MARK: - UITableView Delegate and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if typePicker?.selectedScopeButtonIndex == 0 {
            return albums.count
        } else if typePicker?.selectedScopeButtonIndex == 1 {
            return artists.count
        } else if typePicker?.selectedScopeButtonIndex == 2 {
            return tracks.count
        } else if typePicker?.selectedScopeButtonIndex == 3 {
            return playlists.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if typePicker?.selectedScopeButtonIndex == 2 {
            return 70
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if typePicker?.selectedScopeButtonIndex == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackTableViewCell
            let track = tracks[indexPath.row]
            cell.albumImageView.image(fromLink: track.coverUrl)
            cell.titelLabel.text = track.name
            cell.artistLabel.text = track.artistName
            cell.albumLabel.text = track.albumName
//            cell.ratingLabel.text = ""
            cell.timeLabel.text = string(fromDuration: track.duration)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as! MusicTableViewCell
            if typePicker?.selectedScopeButtonIndex == 0 {
                let album = albums[indexPath.row]
                print(indexPath.row)
                print(albums)
                print(album)
                cell.itemImageView.image(fromLink: album.coverUrl)
                cell.nameLabel.text = album.name
            } else if typePicker?.selectedScopeButtonIndex == 1 {
                let artist = artists[indexPath.row]
                cell.itemImageView.image(fromLink: artist.artistCoverUrl)
                cell.nameLabel.text = artist.artistName
            } else if typePicker?.selectedScopeButtonIndex == 3 {
                let playlist = playlists[indexPath.row]
                cell.itemImageView.image(fromLink: playlist.coverUrl)
                cell.nameLabel.text = playlist.name
            }
            return cell
        }
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let searchQuery = searchBar.text {
            if searchQuery != "" {
                let url = spotifyModel.getSearchUrl(for: searchQuery, ofTypes: [.album,.artist,.playlist,.track], amount: 50, offSet: 0)
                print(url)
                spotifyModel.getSearchResults(fromUrl: url, onCompletion: { albums, artists, tracks, playlists in
                    weak var weakSelf: SearchViewController! = self
                    DispatchQueue.main.async {
                        print("LOOK HERE")
                        print(albums)
                        print(artists)
                        print(tracks)
                        print(playlists)
                        
                        weakSelf.albums = albums
                        weakSelf.artists = artists
                        weakSelf.playlists = playlists
                        weakSelf.tracks = tracks
                        self.searchTableView.reloadData()
                    }
                })
            }
        }
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchTableView.reloadData()
        updateHeaderHeight()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Homemade Functions
    private func string(fromDuration duration: Int) -> String {
        let time = Int(duration / 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        if hours == 0 {
            return String(format: "%0.1d:%0.2d",minutes,seconds)
        } else {
            return String(format: "%0.1d:%0.2d:%0.2d",hours,minutes,seconds)
        }
    }
    
    // MARK: - HomemadeFunctions
    private func updateHeaderHeight() {
        let height: CGFloat
        if typePicker?.selectedScopeButtonIndex == 2 {
            height = 70
        } else {
            height = 44
        }
        searchTableView.tableHeaderView?.frame.size.height = height
        
        // Reset tableview contentsize height
        let lastTableViewSubviewYPosition = searchTableView.tableHeaderView?.frame.origin.y
        let lastTableViewSubviewHeight = searchTableView.tableFooterView?.bounds.height
        let newHeight = (lastTableViewSubviewYPosition ?? 0) + (lastTableViewSubviewHeight ?? 0)
        searchTableView.contentSize = CGSize(width: searchTableView.contentSize.width, height: newHeight)
    }
}
