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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath)
        
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
            widthPerItem = availableWidth / itemsPerRow - musicFlowLayout.sectionInset.left - musicFlowLayout.minimumInteritemSpacing / 2
        } else {
            //For anything bigger than iPhone 7
            //107.5 because we want to fit 3 into an iPhone 7+ screen
            widthPerItem = 107.5
        }
        
        heightPerItem = widthPerItem + 50
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
