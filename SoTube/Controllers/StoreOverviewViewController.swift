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
        // Do any additional setup after loading the view.
        
        spotifyModel.getNewReleases(amount: 50, withOffset: 0, OnCompletion: {albums in
            self.newReleases = albums
            self.newReleasesCollectionView.reloadData()
        })
        spotifyModel.getFeaturedPlaylists(amount: 50, withOffset: 0, OnCompletion: {playlists in
            self.featuredPlaylists = playlists
            self.featuredPlaylistsCollectionView.reloadData()
        })
        spotifyModel.getCategories(amount: 50, withOffset: 0, OnCompletion: {categories in
            self.categories = categories
            self.categoriesCollectionView.reloadData()
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView === newReleasesCollectionView {
//            try? player.play(contentOf: spotifyModel.getSpotifyString(ofType: .playString, forItemType: .albums, andID: newReleases[indexPath.row].id))
//        }
//        
//        if collectionView === featuredPlaylistsCollectionView {
//
//        }
//        
//        if collectionView === categoriesCollectionView {
//            
//        }
//    }
    
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
