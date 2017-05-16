//
//  AccountViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 16/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, paymentDelegate {

    let reuseIdentifier = "paymentCell"
    let paymentViewModel = PaymentViewModel()
    var pricePerAmount: [Int: Double]?
    var buyAmounts: [Int]?
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newUsernameTextField: UITextField!
    @IBOutlet weak var saveUsernameButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pricePerAmount = paymentViewModel.pricePerAmount
        buyAmounts = pricePerAmount!.keys.sorted(by: <)
    }
    

    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return buyAmounts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PaymentCollectionViewCell
        if let amount = buyAmounts?[indexPath.row] {
            cell.amountLabel.text = String(amount)
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let amount = buyAmounts?[indexPath.row]
        buySoCoin(amount: amount!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let availableWidth = collectionView.frame.width
        let availableHeight = collectionView.frame.height
        var widthPerItem: CGFloat
        var heightPerItem: CGFloat
        
//        let itemsPerRow: CGFloat = 2
        heightPerItem = availableHeight
        widthPerItem = heightPerItem
        
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
