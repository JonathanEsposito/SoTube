//
//  AccountViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 16/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class AccountViewController: TabBarViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, paymentDelegate {
    // MARK: - Properties
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var usernameTextField: UITextField!
    
    let reuseIdentifier = "paymentCell"
    let paymentViewModel = PaymentViewModel()
    var pricePerAmount: [Int: Double]?
    var buyAmounts: [Int]?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pricePerAmount = paymentViewModel.pricePerAmount
        buyAmounts = pricePerAmount!.keys.sorted(by: <)
        
        // Set navigation controller background and shadow
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
    
    // MARK: - IBActions
    @IBAction func changeUsername(_ sender: UIButton) {
//        let alertController = UIAlertController(title: "Change Username", message: "", preferredStyle: .alert)
//        
//        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "resetPasswordVC")
//        
//        alertController.addChildViewController(viewController!)
////        alertController.addTextField { (oldUsernameTextField) in
////            oldUsernameTextField.placeholder = "Current username"
////        }
////        alertController.addTextField { (newUsernameTextField) in
////            newUsernameTextField.placeholder = "New username"
////        }
////        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
////        alertController.addAction(cancelAction)
////        let changeAction = UIAlertAction(title: "Change", style: .default) { [weak self] _ in
////            guard let oldUsernameTextField = alertController.textFields?.first, let oldUsername = oldUsernameTextField.text else {
////                print("Old username not set")
////                return
////            }
////            guard let newUsernameTextField = alertController.textFields?.last, let newUsername = newUsernameTextField.text else {
////                print("New username not set")
////                return
////            }
////            print("changes made :D")
////        }
////        alertController.addAction(changeAction)
//        present(alertController, animated: true, completion: nil)
        let vc = ChangeUsernameViewController()
        self.present(vc, animated: true)
    }
    
    // MARK: - Private Methods
    func showAlert(withTitle title: String, message: String, actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions == nil {
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
        } else {
            actions?.forEach { alertController.addAction($0)}
        }
        present(alertController, animated: true, completion: nil)
    }
}
