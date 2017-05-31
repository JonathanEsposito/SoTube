//
//  SearchViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 29/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class SearchViewController: TabBarViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, SearchTrakCellDelegate, PaymentDelegate {
    // MARK: - Properties
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableViewFooter: UIView!
    
    let paymentViewModel = PaymentViewModel()
    let database = DatabaseViewModel()
    let spotifyModel = SpotifyModel()
    var ownedTracks: [Track] = []
    var albums: [Album] = []
    var artists: [Artist] = []
    var tracks: [Track] = []
    var playlists: [Playlist] = []
    let searchController = UISearchController(searchResultsController: nil)
    var typePicker: UISearchBar?
    var indexForType: [Types: Int] = [.albums: 0, .artists: 1, .tracks: 2, .playlists: 3]
    
    enum Types {
        case albums, artists, tracks, playlists
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get ownedTracks
        database.getTracks { [weak self] databaseTracks in
            DispatchQueue.main.async {
                self?.ownedTracks = databaseTracks
            }
        }
        
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
        
//        updateHeaderHeight()
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
        updateFooterHeight()
    }
    
    // MARK: - UITableView
    // MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if typePicker?.selectedScopeButtonIndex == indexForType[.albums] {
            return albums.count
        } else if typePicker?.selectedScopeButtonIndex == indexForType[.artists] {
            return artists.count
        } else if typePicker?.selectedScopeButtonIndex == indexForType[.tracks] {
            return tracks.count
        } else if typePicker?.selectedScopeButtonIndex == indexForType[.playlists] {
            return playlists.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if typePicker?.selectedScopeButtonIndex == indexForType[.tracks] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! SearchTrackTableViewCell
            let track = tracks[indexPath.row]
            cell.albumImageView.image = nil
            cell.albumImageView.image(fromLink: track.coverUrl)
            cell.titelLabel.text = track.name
            cell.artistLabel.text = track.artistName
            cell.albumLabel.text = track.albumName
            //            cell.ratingLabel.text = ""
            
            print(track.bought)
            if track.bought || self.guestuser {
                cell.buyTrackButton.isHidden = true
            } else {
                cell.buyTrackButton.isHidden = false
            }
            
            // Set Cell Delegate
            weak var weakSelf = self
            cell.delegate = weakSelf
            cell.timeLabel.text = string(fromDuration: track.duration)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as! MusicTableViewCell
            cell.itemImageView.image = nil
            if typePicker?.selectedScopeButtonIndex == indexForType[.albums] {
                let album = albums[indexPath.row]
                
                cell.itemImageView.image(fromLink: album.coverUrl)
                cell.nameLabel.text = album.name
            } else if typePicker?.selectedScopeButtonIndex == indexForType[.artists] {
                let artist = artists[indexPath.row]
                cell.itemImageView.image(fromLink: artist.artistCoverUrl)
                cell.nameLabel.text = artist.artistName
            } else if typePicker?.selectedScopeButtonIndex == indexForType[.playlists] {
                let playlist = playlists[indexPath.row]
                cell.itemImageView.image(fromLink: playlist.coverUrl)
                cell.nameLabel.text = playlist.name
            }
            return cell
        }
    }
    
    // MARK: Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if typePicker?.selectedScopeButtonIndex == indexForType[.tracks] {
            return 70
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if typePicker?.selectedScopeButtonIndex == indexForType[.albums] {
            performSegue(withIdentifier: "showAlbumSegue", sender: nil)
        }
        if typePicker?.selectedScopeButtonIndex == indexForType[.artists] {
            performSegue(withIdentifier: "showAlbumsFromArtistSegue", sender: nil)
        }
        if typePicker?.selectedScopeButtonIndex == indexForType[.playlists] {
            performSegue(withIdentifier: "showPlaylistSegue", sender: nil)
        }
        if typePicker?.selectedScopeButtonIndex == indexForType[.tracks] {
            let index = indexPath.row
            let selectedTrack = tracks[index]
            
            musicPlayer.play(selectedTrack)
            self.updateMiniPlayer()
            
            updateFooterHeight()
        }
    }
    
    // MARK: - AlbumTrakCellDelegate
    func buySong(_ cell: SearchTrackTableViewCell) {
        // If there is a logged in user
        if self.guestuser {
            let alertController = UIAlertController(title: "SoTunes Store", message: "As a guest you can only preview tracks but not buy track. Do you want to create an account or log in?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let creatAccountAction = UIAlertAction(title: "Create new account", style: .default, handler: { _ in
                // Go to Create Account screen
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let createNewAccountController = storyboard.instantiateViewController(withIdentifier: "createAccountVC")
                self.present(createNewAccountController, animated: true, completion: nil)
            })
            alertController.addAction(creatAccountAction)
            let loginAction = UIAlertAction(title: "Log in", style: .default, handler: { _ in
                // Go to login screen
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                UIApplication.shared.keyWindow?.rootViewController = loginViewController
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(loginAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            guard let index = searchTableView.indexPath(for: cell)?.row else { return }
            //            print(index)
            // user row as index to get song form array
            
            let track = self.tracks[index]
            database.getCoins { [weak self] currentCoins in
                DispatchQueue.main.async {
                    if (currentCoins - coinsPerTrackRate) > 0 {
                        let alertController = UIAlertController(title: "SoTunes Store", message: "You are about to buy \"\(track.name)\" by \"\(track.artistName)\" for \(coinsPerTrackRate) SoCoins.\n\nCurrently you have \(currentCoins) SoCoins.\nAfter buying this song you will have \(currentCoins - coinsPerTrackRate) SoCoins left.\n\nDo you want to continue?", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        
                        let buyTrackAction = UIAlertAction(title: "Buy this track!", style: .default, handler: { _ in
                            self?.database.buy(track, withCoins: coinsPerTrackRate, onCompletion: { error in
                                DispatchQueue.main.async {
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        let boughtTrack = track
                                        track.bought = true
                                        // print("track bought :D")
                                        self?.tracks.forEach { storeTrack in
                                            if storeTrack.id == boughtTrack.id {
                                                storeTrack.bought = true
                                            }
                                        }
                                        track.bought = true
                                        dump(track)
                                        let indexPath = IndexPath(row: index, section: 0)
                                        print(indexPath)
                                        self?.searchTableView.beginUpdates()
                                        self?.searchTableView.reloadRows(at: [indexPath], with: .automatic)
                                        self?.searchTableView.endUpdates()
                                    }
                                }
                            })
                        })
                        alertController.addAction(buyTrackAction)
                        self?.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        let alertController = UIAlertController(title: "SoTunes Store", message: "You are about to buy \"\(track.name)\" by \"\(track.artistName)\" for \(coinsPerTrackRate) SoCoins.\n\nSadly you currently only have \(currentCoins) SoCoins left.\nWould you want to top up your acount?", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        let topUpAccount = UIAlertAction(title: "Topup account", style: .default, handler: { _ in
                            self?.presentTopUpAlertController(onCompletion: { amount in
                                if let price = self!.paymentViewModel.pricePerAmount[amount] {
                                    let coinPurchase = CoinPurchase(amount: amount, price: price)
                                    // print("I'm buying!!")
                                    self?.database.updateCoins(with: coinPurchase) {
                                        // print("bought coins :D")
                                    }
                                }
                            })
                        })
                        alertController.addAction(topUpAccount)
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let searchQuery = searchBar.text {
            if searchQuery != "" {
                let url = spotifyModel.getSearchUrl(for: searchQuery, ofTypes: [.album,.artist,.playlist,.track], amount: 50, offSet: 0)
                //                print(url)
                spotifyModel.getSearchResults(fromUrl: url, onCompletion: { [weak self] albums, artists, playlistTracks, playlists in
                    DispatchQueue.main.async {
                        
                        // Get array with all the track ids
                        let databaseTrackIds = self!.ownedTracks.map { $0.id }
                        
                        // set store tracks bought to true if was bought by user
                        playlistTracks.forEach { storeTrack in
                            if databaseTrackIds.contains(storeTrack.id) {
                                return storeTrack.bought = true
                            }
                        }
                        
                        self?.albums = albums
                        self?.artists = artists
                        self?.playlists = playlists
                        self?.tracks = playlistTracks
                        self?.searchTableView.reloadData()
                        self?.searchTableView.contentOffset = CGPoint(x: 0, y: 50)
                    }
                })
            }
        }
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchTableView.reloadData()
        searchTableView.contentOffset = CGPoint.zero
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
        searchTableView.tableFooterView?.frame.size.height = height
        
        // Reset tableview contentsize height is miniPlayer is shown
        let lastTableViewSubviewYPosition = searchTableView.tableFooterView?.frame.origin.y
        let lastTableViewSubviewHeight = searchTableView.tableFooterView?.bounds.height
        let newHeight = (lastTableViewSubviewYPosition ?? 0) + (lastTableViewSubviewHeight ?? 0)
        searchTableView.contentSize = CGSize(width: searchTableView.contentSize.width, height: newHeight)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        if segue.identifier == "showAlbumsFromArtistSegue" {
            if let destinationVC = destinationVC as? StoreDetailViewController {
                let indexPath = searchTableView.indexPathForSelectedRow
                destinationVC.navigationItem.title = artists[indexPath!.row].artistName
                destinationVC.navigationItem.backBarButtonItem?.title = "Search"
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
                destinationVC.navigationItem.title = albums[indexPath!.row].name
                destinationVC.navigationItem.backBarButtonItem?.title = "Search"
                destinationVC.album = self.albums[indexPath!.row]
            }
        }
        if segue.identifier == "showPlaylistSegue" {
            if let destinationVC = destinationVC as? AlbumViewController {
                let indexPath = searchTableView.indexPathForSelectedRow
                destinationVC.navigationItem.title = playlists[indexPath!.row].name
                destinationVC.navigationItem.backBarButtonItem?.title = "Search"
                destinationVC.playlist = self.playlists[indexPath!.row]
            }
        }
    }
}
