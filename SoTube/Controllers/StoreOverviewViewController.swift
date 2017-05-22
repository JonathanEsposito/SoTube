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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        return 20//data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView === newReleasesCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath)
        }
        
        if collectionView === featuredPlaylistsCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath)
        }
        
        if collectionView === categoriesCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath)
        }
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
