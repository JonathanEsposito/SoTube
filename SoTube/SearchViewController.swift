//
//  SearchViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 29/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class SearchViewController: TabBarViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var spotifyModel = SpotifyModel()
    var albums: [Album] = []
    var artists: [Artist] = []
    var tracks: [Track] = []
    var playlists: [Playlist] = []
    let searchController = UISearchController(searchResultsController: nil)
    var typePicker: UISearchBar?
    @IBOutlet weak var tableViewFooter: UIView!
    
    var indexForType: [String: Int] = ["albums": 0, "artists": 1, "tracks": 2, "playlists": 3]
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set navigation bar title
        self.navigationItem.title = "Search"
        
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
//        updateFooterHeight()
    }
    
    // Show en hide navigationcontroller navigationbar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Constraints Size Classes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // because our player moves down when in landscape mode
//        updateFooterHeight()
    }
    
    // MARK: - UITableView
    // MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if typePicker?.selectedScopeButtonIndex == indexForType["albums"] {
            return albums.count
        } else if typePicker?.selectedScopeButtonIndex == indexForType["artists"] {
            return artists.count
        } else if typePicker?.selectedScopeButtonIndex == indexForType["tracks"] {
            return tracks.count
        } else if typePicker?.selectedScopeButtonIndex == indexForType["playlists"] {
            return playlists.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if typePicker?.selectedScopeButtonIndex == indexForType["tracks"] {
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
            if typePicker?.selectedScopeButtonIndex == indexForType["albums"] {
                let album = albums[indexPath.row]
                print(indexPath.row)
                print(albums)
                print(album)
                cell.itemImageView.image(fromLink: album.coverUrl)
                cell.nameLabel.text = album.name
            } else if typePicker?.selectedScopeButtonIndex == indexForType["artists"] {
                let artist = artists[indexPath.row]
                cell.itemImageView.image(fromLink: artist.artistCoverUrl)
                cell.nameLabel.text = artist.artistName
            } else if typePicker?.selectedScopeButtonIndex == indexForType["playlists"] {
                let playlist = playlists[indexPath.row]
                cell.itemImageView.image(fromLink: playlist.coverUrl)
                cell.nameLabel.text = playlist.name
            }
            return cell
        }
    }
    
    // MARK: Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if typePicker?.selectedScopeButtonIndex == indexForType["tracks"] {
            return 70
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if typePicker?.selectedScopeButtonIndex == indexForType["albums"] {
            performSegue(withIdentifier: "showAlbumSegue", sender: nil)
        }
        if typePicker?.selectedScopeButtonIndex == indexForType["artists"] {
            performSegue(withIdentifier: "showAlbumsFromArtistSegue", sender: nil)
        }
        if typePicker?.selectedScopeButtonIndex == indexForType["playlists"] {
            performSegue(withIdentifier: "showPlaylistSegue", sender: nil)
        }
        if typePicker?.selectedScopeButtonIndex == indexForType["tracks"] {
            let index = indexPath.row
            let selectedTrack = tracks[index]
            
            musicPlayer.play(selectedTrack)
            self.updateMiniPlayer()
            
            //                updateFooterHeight()
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
    
//    private func updateFooterHeight() {
//        let height: CGFloat
//        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
//            if musicPlayer.hasSong {
//                height = 94
//            } else {
//                height = 50
//            }
//        } else {
//            height = 50
//        }
//        searchTableView.tableFooterView?.frame.size.height = height
//        
//        // Reset tableview contentsize height is miniPlayer is shown
//        let lastTableViewSubviewYPosition = searchTableView.tableFooterView?.frame.origin.y
//        let lastTableViewSubviewHeight = searchTableView.tableFooterView?.bounds.height
//        let newHeight = (lastTableViewSubviewYPosition ?? 0) + (lastTableViewSubviewHeight ?? 0)
//        searchTableView.contentSize = CGSize(width: searchTableView.contentSize.width, height: newHeight)
//    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        if segue.identifier == "showAlbumsFromArtistSegue" {
            if let destinationVC = destinationVC as? StoreDetailViewController {
                let indexPath = searchTableView.indexPathForSelectedRow
                destinationVC.navigationItem.title = artists[indexPath!.row].artistName
                spotifyModel.getAlbums(from: artists[indexPath!.row], onCompletion: {albums in
                    DispatchQueue.main.async {
                        destinationVC.collection = albums
                        destinationVC.musicCollectionView.reloadData()
                    }
                })
                
            }
        }
        if segue.identifier == "showAlbumSegue" {
            if let destinationVC = destinationVC as? AlbumViewController {
                let indexPath = searchTableView.indexPathForSelectedRow
                destinationVC.album = self.albums[indexPath!.row]
                destinationVC.tracksTableView.reloadData()
            }
        }
        if segue.identifier == "showPlaylistSegue" {
            if let destinationVC = destinationVC as? AlbumViewController {
                let indexPath = searchTableView.indexPathForSelectedRow
                destinationVC.playlist = self.playlists[indexPath!.row]
//                destinationVC.tracksTableView.reloadData()
            }
        }
//        if segue.identifier == "playTrackSegue" {
//            let indexPath = searchTableView.indexPathForSelectedRow
//            let track = self.tracks[indexPath!.row]
//        }
    }
}
