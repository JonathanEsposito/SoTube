//
//  StoreDetailViewController.swift
//  SoTube
//
//  Created by .jsber on 18/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit


class StoreDetailViewController: TabBarViewController {
    @IBOutlet weak var musicCollectionView: UICollectionView!
    @IBOutlet weak var musicFlowLayout: UICollectionViewFlowLayout!
    
    var collection: [Any]?
    let spotifyModel = SpotifyModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Collection viewDidLoad
    // MARK: DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath) as! StoreCollectionViewCell
        if let collection = collection as! [Album]? {
            cell.coverImageView.image(fromLink: collection[indexPath.row].coverUrl)
            cell.nameLabel.text = collection[indexPath.row].name
        }
        if let collection = collection as! [Playlist]? {
            cell.coverImageView.image(fromLink: collection[indexPath.row].coverUrl)
            cell.nameLabel.text = collection[indexPath.row].name
        }
        if let collection = collection as! [Category]? {
            cell.coverImageView.image(fromLink: collection[indexPath.row].coverUrl)
            cell.nameLabel.text = collection[indexPath.row].name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collection as? [Category]? {
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
                if let collection = collection as? [Category] {
                    spotifyModel.getPlaylist(from: collection[indexPaths!.first!.row], OnCompletion: {playlists in
                    destinationVC.collection = playlists
                    })
                }
            }
        }
        if segue.identifier == "showAlbumSegue" {
            if let destinationVC = destinationVC as? StoreAlbumViewController {
                if let collection = collection as? [Playlist] {
                    destinationVC.playlist = collection[indexPaths!.first!.row]
                }
                if let collection = collection as? [Album] {
                    destinationVC.album = collection[indexPaths!.first!.row]
                }
            }
        }
    }
}






