//
//  SplitViewDetailViewController.swift
//  SoTube
//
//  Created by .jsber on 11/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class MusicSplitViewDetailViewController: TabBarViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Properties
    @IBOutlet weak var albumsCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    let database = DatabaseViewModel()
    var genre: String = ""
    var artist: Artist?
    
    var albums: [Album] = [] {
        didSet {
            albumsCollectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide Navigation controller background and shadow
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Get data
        if let artist = self.artist {
            database.getAlbums(forArtist: artist) { albums in
                self.albums = albums
            }
        } else {
            print("By genre it is!")
        }
    }
    
    // MARK: - Constraints Size Classes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFooterHeight()
    }
    
    // MARK: - CollectionView
    // MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCell", for: indexPath) as? AlbumCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of AlbumCollectionViewCell.")
        }
        
        let album = albums[indexPath.row]
        cell.albumCoverImageView.image(fromLink: album.coverUrl)
        cell.albumNameLabel.text = album.name
        cell.artistNameLabel.text = album.artist
        
        return cell
    }
    
    // MARK: DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        var widthPerItem: CGFloat
        var heightPerItem: CGFloat
        
        if availableWidth <= 375 {
            //For iPhone 7 or smaller
            let itemsPerRow: CGFloat = 2
            widthPerItem = availableWidth / itemsPerRow - albumsCollectionViewFlowLayout.sectionInset.left - albumsCollectionViewFlowLayout.minimumInteritemSpacing / 2
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
        if segue.identifier == "showAlbumSegue", let destinationVC = segue.destination as? AlbumViewController {
            // Get indexpath from sender as cell
            guard let albumCell = sender as? UICollectionViewCell else { print("wrong sender"); return }
            guard let indexPath = self.albumsCollectionView.indexPath(for: albumCell) else { print("cell not from this collection"); return }
            
            // Get album from array
            let album = albums[indexPath.row]
            
            // Set destinationVC properties
            destinationVC.album = album
        }
    }
    
    // MARK: - Private Methods
    private func updateFooterHeight() {
        let newHeight: CGFloat
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if musicPlayer.hasSong {
                newHeight = 94
            } else {
                newHeight = 50
            }
        } else {
            newHeight = 50
        }
        
        albumsCollectionViewFlowLayout.footerReferenceSize.height = newHeight
    }
}
