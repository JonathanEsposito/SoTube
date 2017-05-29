//
//  SearchViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 29/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var spotifyModel = SpotifyModel()
    var albums: [Album]?
    var artists: [Artist]?
    var tracks: [Track]?
    var playlists: [Playlist]?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var typePicker: UISegmentedControl!
    @IBOutlet weak var searchTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableView Delegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if typePicker.isEnabledForSegment(at: 0) {
            return albums!.count
        } else if typePicker.isEnabledForSegment(at: 1) {
            return artists!.count
        } else if typePicker.isEnabledForSegment(at: 2) {
            return tracks!.count
        } else if typePicker.isEnabledForSegment(at: 3) {
            return playlists!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if typePicker.isEnabledForSegment(at: 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackTableViewCell
            let track = tracks![indexPath.row]
            cell.albumImageView.image(fromLink: track.coverUrl)
            cell.titelLabel.text = track.name
            cell.artistLabel.text = track.artistName
            cell.albumLabel.text = track.albumName
//            cell.ratingLabel.text = ""
            cell.timeLabel.text = string(fromDuration: track.duration)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as! MusicTableViewCell
            if typePicker.isEnabledForSegment(at: 0) {
                let album = albums![indexPath.row]
                cell.itemImageView.image(fromLink: album.coverUrl)
                cell.nameLabel.text = album.name
            } else if typePicker.isEnabledForSegment(at: 1) {
                let artist = artists![indexPath.row]
                cell.itemImageView.image(fromLink: artist.artistCoverUrl)
                cell.nameLabel.text = artist.artistName
            } else if typePicker.isEnabledForSegment(at: 3) {
                let playlist = playlists![indexPath.row]
                cell.itemImageView.image(fromLink: playlist.coverUrl)
                cell.nameLabel.text = playlist.name
            }
            return cell
        }
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        updateSearch()
    }
    
    // MARK: - Homemade Functions
    func updateSearch() {
        if let searchQuery = searchBar.text {
            let url = spotifyModel.getSearchUrl(for: searchQuery, ofTypes: [.album,.artist,.playlist,.track], amount: 50, offSet: 0)
            print(url)
            spotifyModel.getSearchResults(fromUrl: url, onCompletion: { albums, artists, tracks, playlists in
                self.albums = albums
                self.artists = artists
                self.playlists = playlists
                self.tracks = tracks
            })
        }
        searchTableView.reloadData()
    }
    
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
    
    // MARK: - IBActions
    @IBAction func typePicker(_ sender: UISegmentedControl) {
        searchTableView.reloadData()
    }
}
