//
//  AlbumViewController.swift
//  SoTube
//
//  Created by .jsber on 24/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class StoreAlbumViewController: TabBarViewController, UITableViewDelegate, UITableViewDataSource, AlbumTrakCellDelegate {
    // MARK: - Properties
    @IBOutlet weak var albumCoverImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var landscapeTotalAlbumDurationLabel: UILabel!
    @IBOutlet weak var landscapeTotalAmountOfSongsLabel: UILabel!
    
    let backgroundViewGradientLayer = CAGradientLayer()
    let firstStaticCellGradientLayer = CAGradientLayer()
    
    var firstStaticCellPortretHeight: CGFloat?
    var averageCoverImageColor: UIColor?
    
    var musicSource = SpotifyModel()
    var database = DatabaseViewModel()
    
    var playlist: Playlist?
    var album: Album?
    var totalAlbumDuration: Int?
    var totalAmountOfSongs: Int?
    var myTracks: [Track] = []
    var tracks: [Track] = [] {
        didSet {
            tracksTableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        //        album = Album(named: "Climate Change", fromArtist: "Pitbull", withCoverUrl: "https://i.scdn.co/image/e1ca3a27d6b2d897ec72425c95685f0475c35be3", withId: "4jtKPpBQ5eneMwEI94f5Y0")
        
        super.viewDidLoad()
        // get tracks from music source
        if let album = album {
            // Get cover
            albumCoverImageView.image(fromLink: album.coverUrl, onCompletion: { (image: UIImage) in
                // set expensive color. If no image is set, user white
                // self.averageCoverImageColor = albumCoverImageView.image?.areaAverage() ?? UIColor.white // To slow :s
                self.averageCoverImageColor = image.averageColor
                // gets the primary color // slightly to slow :/ could fix this later if we have time
                //                image.getColors { colors in
                //                    DispatchQueue.main.async {
                //                        self.averageCoverImageColor = colors.primaryColor
                //                        print(colors.primaryColor)
                //                    }
                //                }
            })
            
            // If album tracks is ampty, get tracks from database
            if album.trackIds.isEmpty {
                
            }
            
            
            // Get Tracks from musicSource
            musicSource.getTracks(from: album, OnCompletion: { tracks in
                DispatchQueue.main.async {
                    if album.trackIds.isEmpty { // If Album comes from store, load my tracks if any
                        self.database.getAlbum(byId: album.id) { databaseAlbum in
                            self.myTracks = tracks.filter { databaseAlbum.trackIds.contains($0.id) }
                            
                            print(self.myTracks)
                        }
                        self.tracks = tracks
                    } else {
                        self.tracks = tracks.filter { self.album!.trackIds.contains($0.id) }
                    }
                    
                    print(tracks)
                    
                    self.totalAmountOfSongs = tracks.count
                    let totalAlbumDuration = tracks.map {$0.duration}.reduce(0, +)
                    self.totalAlbumDuration = totalAlbumDuration
                    
                    self.landscapeTotalAmountOfSongsLabel.text = "\(tracks.count)"
                    self.landscapeTotalAlbumDurationLabel.text = self.string(fromIntInMiliSec: totalAlbumDuration)
                    
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tracksTableView.beginUpdates()
                    self.tracksTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    self.tracksTableView.endUpdates()
                }
            })
        } else if let playlist = self.playlist {
            albumCoverImageView.image(fromLink: playlist.coverUrl) { image in
                // set expensive color. If no image is set, user white
                // self.averageCoverImageColor = albumCoverImageView.image?.areaAverage() ?? UIColor.white // To slow :s
                self.averageCoverImageColor = image.averageColor
            }
            
            musicSource.getTracks(from: playlist) { tracks in
                DispatchQueue.main.async {
                    self.tracks = tracks
                    
                    self.totalAmountOfSongs = tracks.count
                    let totalAlbumDuration = tracks.map {$0.duration}.reduce(0, +)
                    self.totalAlbumDuration = totalAlbumDuration
                    
                    self.landscapeTotalAmountOfSongsLabel.text = "\(tracks.count)"
                    self.landscapeTotalAlbumDurationLabel.text = self.string(fromIntInMiliSec: totalAlbumDuration)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tracksTableView.beginUpdates()
                    self.tracksTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    self.tracksTableView.endUpdates()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // do stuff when we are in compact width, regural height sizeClass
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            // Scale original AlbumCoverImageView height to new height (7:6) and remove the navigation bar height
            let scaledAlbumCoverImageViewHeight = albumCoverImageView.bounds.height - (albumCoverImageView.bounds.height / 7)
            
            // Set backgroundView gradient
            let clearColor = UIColor.clear.cgColor
            // Fist time called, there might not be an image yet so use white, otherwise use avergeColor
            let averageCoverImageCGColor = averageCoverImageColor?.cgColor ?? UIColor.white.cgColor
            let relativeAlbumCoverImageViewBottom = scaledAlbumCoverImageViewHeight / view.bounds.height
            
            backgroundViewGradientLayer.frame = self.backgroundView.bounds
            backgroundViewGradientLayer.colors = [clearColor, averageCoverImageCGColor]
            backgroundViewGradientLayer.locations = [0.0, NSNumber(value: Float(relativeAlbumCoverImageViewBottom))]
            
            // as it is a let in our class property, it will only be added once. Beats me why, but very usefull and easy :D
            backgroundView.layer.addSublayer(backgroundViewGradientLayer)
            
            // Get the imageview height when constraints are all set and active! And use for static cell height.
            if firstStaticCellPortretHeight == nil || (firstStaticCellPortretHeight ?? 0 ) < (albumCoverImageView.bounds.height) {
                firstStaticCellPortretHeight = albumCoverImageView.bounds.height
                
                // update first static cell
                let indexPath = IndexPath(row: 0, section: 0)
                tracksTableView.beginUpdates()
                tracksTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tracksTableView.endUpdates()
            }
            
            // Set albumCoverImageViewCornerRadius
            albumCoverImageView.cornerRadius = 0
        } else {
            albumCoverImageView.cornerRadius = 10
        }
        
        // help setting tableview footer height
        if let footerView = tracksTableView.tableFooterView {
            let height = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var footerFrame = footerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != footerFrame.size.height {
                footerFrame.size.height = height
                footerView.frame = footerFrame
                tracksTableView.tableFooterView = footerView
            }
        }
    }
    
    // MARK: - Constraints Size Classes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFooterHeight()
    }
    
    // MARK: - TableView
    // MARK: DataSourced
    func numberOfSections(in: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return tracks.count
        }
        return 1 // for static content return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if (indexPath.section == 0) {
            guard let staticCell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? StaticAlbumTableViewCell else {
                fatalError("The dequeued cell is not an instance of StaticAlbumTableViewCell.")
            }
            
            staticCell.albumTitleLabel.text = album?.name
            staticCell.artistNameLabel.text = album?.artist
            staticCell.totalAmountOfSongsLabel.text = "\(totalAmountOfSongs ?? 0)"
            staticCell.totalAlbumDurationLabel.text = string(fromIntInMiliSec: totalAlbumDuration ?? 0)
            
            if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
                let clearColor = UIColor.clear.cgColor
                let whiteColor = UIColor.white.withAlphaComponent(0.75).cgColor
                firstStaticCellGradientLayer.frame = staticCell.bounds
                firstStaticCellGradientLayer.colors = [clearColor, whiteColor]
                firstStaticCellGradientLayer.locations = [0.4, 0.95]
                staticCell.layer.insertSublayer(firstStaticCellGradientLayer, at: 0)
            }
            cell = staticCell
            
        } else if (indexPath.section == 1) {
            guard let trackCell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as? AlbumTrackTableViewCell else {
                fatalError("The dequeued cell is not an instance of AlbumTrackTableViewCell.")
            }
            
            let track = tracks[indexPath.row]
            
            if album != nil { // Hide tracknumbers in playlists
                trackCell.trackNumberLabel.text = "\(track.trackNumber)"
            } else {
                trackCell.trackNumberLabel.text = "\(indexPath.row + 1)"
            }
            trackCell.trackNameLabel.text = "\(track.name)"
            trackCell.trackDurationLabel.text = string(fromIntInMiliSec: track.duration)
            trackCell.delegate = self
            cell = trackCell
        }
        return cell
    }
    
    // MARK: Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let customCellHeight: CGFloat = 70
        
        if indexPath == IndexPath(row: 0, section: 0) {
            if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
                
                // This function is called many times before all layout is set and after all layout is set
                // So when not all layout is set, the albumCover height is not correct yet, so we pass
                // the default rowheight. When all layout is set, we set the right height.
                // When this function is called agian, we will have the right height :)
                return firstStaticCellPortretHeight ?? customCellHeight
            } else {
                return customCellHeight
            }
        }
        return tableView.rowHeight
    }
    
    // MARK: - AlbumTrakCellDelegate
    func buySong(_ cell: AlbumTrackTableViewCell) {
        guard let row = tracksTableView.indexPath(for: cell)?.row else { return }
        print(row)
        // user row as index to get song form array
        
        let track = tracks[row]
        database.buy(track, withCoins: 5, onCompletion: { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("track bought :D")
            }
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // Private Methods
    private func updateFooterHeight() {
        let height: CGFloat
        let tabBarHeight: CGFloat = 50
        let tabBarAndMiniPlayerHeight: CGFloat = 94
        
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if musicPlayer.hasSong {
                height = tabBarAndMiniPlayerHeight
            } else {
                height = tabBarHeight
            }
        } else {
            height = tabBarHeight
        }
        tracksTableView.tableFooterView?.frame.size.height = height
        
        // Reset tableview contentsize height
        let lastTableViewSubviewYPosition = tracksTableView.tableFooterView?.frame.origin.y
        let lastTableViewSubviewHeight = tracksTableView.tableFooterView?.bounds.height
        let newHeight = (lastTableViewSubviewYPosition ?? 0) + (lastTableViewSubviewHeight ?? 0)
        tracksTableView.contentSize = CGSize(width: tracksTableView.contentSize.width, height: newHeight)
    }
    
    private func string(fromIntInMiliSec timeMS: Int) -> String {
        
        let time = timeMS / 1000
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        if hours == 0 {
            return String(format: "%0.1d:%0.2d",minutes,seconds)
        } else {
            return String(format: "%0.1d:%0.2d:%0.2d",hours,minutes,seconds)
        }
    }
}
