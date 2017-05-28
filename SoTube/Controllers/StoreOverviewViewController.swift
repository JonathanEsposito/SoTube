//
//  StoreOverviewViewController.swift
//  SoTube
//
//  Created by .jsber on 18/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class StoreOverviewViewController: TabBarViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - Properties
    @IBOutlet weak var newReleasesCollectionView: UICollectionView!
    @IBOutlet weak var newReleasesFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var featuredPlaylistsCollectionView: UICollectionView!
    @IBOutlet weak var featuredPlaylistsFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesFlowLayout: UICollectionViewFlowLayout!
    
    let spotifyModel = SpotifyModel()
    let player = SPTPlayerModel()
    var newReleases: [Album] = []
    var featuredPlaylists: [Playlist] = []
    var categories: [Category] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide Navigation controller background and shadow
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // Do any additional setup after loading the view.
        
        spotifyModel.getNewReleases(amount: 10, withOffset: 0, OnCompletion: {albums in
            DispatchQueue.main.async {
                self.newReleases = albums
                self.newReleasesCollectionView.reloadData()
            }
        })
        spotifyModel.getFeaturedPlaylists(amount: 10, withOffset: 0, OnCompletion: {playlists in
            DispatchQueue.main.async {
                self.featuredPlaylists = playlists
                self.featuredPlaylistsCollectionView.reloadData()
            }
        })
        spotifyModel.getCategories(amount: 10, withOffset: 0, OnCompletion: {categories in
            DispatchQueue.main.async {
                self.categories = categories
                self.categoriesCollectionView.reloadData()
            }
        })
    }
    
    // MARK: - Collection viewDidLoad
    // MARK: DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case newReleasesCollectionView:
            return newReleases.count
        case featuredPlaylistsCollectionView:
            return featuredPlaylists.count
        case categoriesCollectionView:
            return categories.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: StoreCollectionViewCell?
        

        if collectionView === newReleasesCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath) as? StoreCollectionViewCell
            cell?.nameLabel.text = newReleases[indexPath.row].name
            cell?.coverImageView.image(fromLink: newReleases[indexPath.row].coverUrl)
        }
        
        if collectionView === featuredPlaylistsCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath) as? StoreCollectionViewCell
            cell?.nameLabel.text = featuredPlaylists[indexPath.row].name
            cell?.coverImageView.image(fromLink: featuredPlaylists[indexPath.row].coverUrl)
        }
        
        if collectionView === categoriesCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath) as? StoreCollectionViewCell
            cell?.nameLabel.text = categories[indexPath.row].name
            cell?.coverImageView.image(fromLink: categories[indexPath.row].coverUrl)
        }
        
        self.reloadInputViews()
        return cell!
    }
    
    // MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === newReleasesCollectionView {
            performSegue(withIdentifier: "showAlbumSegue", sender: nil)
        }
        if collectionView === featuredPlaylistsCollectionView {
            performSegue(withIdentifier: "showPlaylistsSegue", sender: nil)
        }
        if collectionView === categoriesCollectionView {
            performSegue(withIdentifier: "showPlaylistsInCategorySegue", sender: nil)
        }
    }
    
    // MARK: DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableHeight = collectionView.frame.height
        var widthPerItem: CGFloat
        var heightPerItem: CGFloat
        var itemsInHeight: CGFloat
        var flowLayout = UICollectionViewFlowLayout()
        
        if availableHeight <= 200 {
            // Smaller than iPhone 7
            itemsInHeight = 1
        } else {
            //For anything bigger or equal than iPhone 7
            //107.5 because we want to fit 3 into an iPhone 7+ screen
            itemsInHeight = 2
        }
        
        if collectionView === newReleasesCollectionView {
            flowLayout = newReleasesFlowLayout
        }
        
        if collectionView === featuredPlaylistsCollectionView {
            flowLayout = featuredPlaylistsFlowLayout
        }
        
        if collectionView === categoriesCollectionView {
            flowLayout = categoriesFlowLayout
        }
        
        heightPerItem = (availableHeight - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom)
        if itemsInHeight == 2 {
            heightPerItem -= flowLayout.minimumInteritemSpacing / 2
        } else if itemsInHeight < 2 {
            heightPerItem -= flowLayout.minimumInteritemSpacing
        }
        
        widthPerItem = heightPerItem - 20
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        if segue.identifier == "showNewReleasesSegue" {
            if let destinationVC = destinationVC as? StoreDetailViewController {
                destinationVC.collection = self.newReleases
                destinationVC.navigationItem.title = "New Releases"
                DispatchQueue.main.async {
                    self.spotifyModel.getNewReleases(amount: 40, withOffset: 10, OnCompletion: {albums in
                        destinationVC.collection.append(albums)
                    })
                }
            }
        }
        if segue.identifier == "showFeaturedPlaylistsSegue" {
            if let destinationVC = destinationVC as? StoreDetailViewController {
                destinationVC.collection = self.featuredPlaylists
                destinationVC.navigationItem.title = "Featured Playlists"
//                spotifyModel.getFeaturedPlaylists(amount: 40, withOffset: 10, OnCompletion: {playlists in
//                    destinationVC.collection.append(playlists)
//                })
            }
        }
        if segue.identifier == "showCategoriesSegue" {
            if let destinationVC = destinationVC as? StoreDetailViewController {
                destinationVC.collection = self.categories
                destinationVC.navigationItem.title = "Categories"
//                spotifyModel.getNewReleases(amount: 40, withOffset: 10, OnCompletion: {categories in
//                    destinationVC.collection.append(categories)
//                })
            }
        }
        if segue.identifier == "showAlbumSegue" {
            if let destinationVC = destinationVC as? AlbumViewController {
                let indexPaths = newReleasesCollectionView.indexPathsForSelectedItems
                destinationVC.album = self.newReleases[indexPaths!.first!.row]
            }
        }
        if segue.identifier == "showPlaylistsSegue" {
            if let destinationVC = destinationVC as? AlbumViewController {
                let indexPaths = featuredPlaylistsCollectionView.indexPathsForSelectedItems
                destinationVC.playlist = self.featuredPlaylists[indexPaths!.first!.row]
            }
        }
        if segue.identifier == "showPlaylistsInCategorySegue" {
            if let destinationVC = destinationVC as? StoreDetailViewController {
               let indexPaths = categoriesCollectionView.indexPathsForSelectedItems
                let category = categories[indexPaths!.first!.row]
                destinationVC.navigationItem.title = category.name
                spotifyModel.getPlaylist(from: category, OnCompletion: {playlists in
                    DispatchQueue.main.async {
                        destinationVC.collection = playlists
                        destinationVC.navigationItem.title = category.name
                        destinationVC.musicCollectionView.reloadData()
                    }
                })
            }
        }
    }
}




