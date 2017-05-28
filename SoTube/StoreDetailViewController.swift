//
//  StoreDetailViewController.swift
//  SoTube
//
//  Created by .jsber on 18/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit


class StoreDetailViewController: TabBarViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var musicCollectionView: UICollectionView!
    @IBOutlet weak var musicFlowLayout: UICollectionViewFlowLayout!
    
    
    var albums: [Album] = [] {
        didSet {
            DispatchQueue.main.async {
//                self.musicCollectionView.insertItems(at: (1...self.albums.count).map({ IndexPath(row: $0, section: 0) }))
                self.musicCollectionView.reloadData()
            }
        }
    }
    var playlists: [Playlist] = []
    var categories: [Category] = []
    var collection: [Any] = []
    let spotifyModel = SpotifyModel()

    override func viewDidLoad() {
        super.viewDidLoad()
//        musicCollectionView.reloadData()
    }

    // MARK: - Collection viewDidLoad
    // MARK: DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath) as? StoreCollectionViewCell else {
        fatalError("Could not cast cell as StoreCollectionViewCell")
    }
        if let albums = collection as? [Album] {
            let album = albums[indexPath.row]
            print(album)
            cell.coverImageView.image(fromLink: album.coverUrl)
            cell.nameLabel.text = album.name
        }
        if let playlists = collection as? [Playlist] {
            let playlist = playlists[indexPath.row]
            cell.coverImageView.image(fromLink: playlist.coverUrl)
            cell.nameLabel.text = playlist.name
        }
        if let categories = collection as? [Category] {
            let category = categories[indexPath.row]
            cell.coverImageView.image(fromLink: category.coverUrl)
            cell.nameLabel.text = category.name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collection as? [Category] {
            performSegue(withIdentifier: "showPlaylistsInCategorySegue", sender: nil)
        } else {
            performSegue(withIdentifier: "showAlbumSegue", sender: nil)
        }
    }
    
    // MARK: DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        var widthPerItem: CGFloat
        var heightPerItem: CGFloat
        
        if availableWidth <= 375 {
            //For iPhone 7 or smaller
            let itemsPerRow: CGFloat = 2
            widthPerItem = availableWidth / itemsPerRow - musicFlowLayout.sectionInset.left - musicFlowLayout.minimumInteritemSpacing / 2
        } else {
            //For anything bigger than iPhone 7
            //107.5 because we want to fit 3 into an iPhone 7+ screen
            widthPerItem = 107.5
        }
        
        heightPerItem = widthPerItem + 50
        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        let indexPaths = musicCollectionView.indexPathsForSelectedItems
        if segue.identifier == "showPlaylistsInCategorySegue" {
            if let destinationVC = destinationVC as? StoreDetailViewController {
                if let categories = collection as? [Category] {
                    let category = categories[indexPaths!.first!.row]
                    spotifyModel.getPlaylist(from: category, OnCompletion: {playlists in
                        destinationVC.collection = playlists
                        destinationVC.navigationItem.title = category.name
                        destinationVC.musicCollectionView.reloadData()
                    })
                }
            }
        }
        if segue.identifier == "showAlbumSegue" {
            if let destinationVC = destinationVC as? AlbumViewController {
                if let playlists = collection as? [Playlist] {
                    let playlist = playlists[indexPaths!.first!.row]
                    destinationVC.playlist = playlist
                    destinationVC.navigationItem.title = playlist.name
                }
                if let albums = collection as? [Album] {
                    let album = albums[indexPaths!.first!.row]
                    destinationVC.album = album
                    destinationVC.navigationItem.title = album.name
                }
            }
        }
    }
}






