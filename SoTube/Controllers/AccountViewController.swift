//
//  AccountViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 16/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class AccountViewController: TabBarViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, paymentDelegate, userInfoDelegate {
    // MARK: - Properties
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var reloadUserInfoActivityIndicatorViewCollection: [UIActivityIndicatorView]!
    @IBOutlet weak var amountOfCoinsLabel: UILabel!
    @IBOutlet weak var amountOfSongsLabel: UILabel!
    
    // UserDefaults
    let kuserDefaultsEmailKey = "userEmail"
    let kuserDefaultsPasswordKey = "userPassword"
    let userDefaults = UserDefaults.standard
    
    let reuseIdentifier = "paymentCell"
    let paymentViewModel = PaymentViewModel()
    var pricePerAmount: [Int: Double]?
    var buyAmounts: [Int]?
    
    var database = DatabaseViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pricePerAmount = paymentViewModel.pricePerAmount
        buyAmounts = pricePerAmount!.keys.sorted(by: <)
        
        // Set navigation controller background and shadow
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // set username, email and "password"
        updateTextFields()
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
            cell.amountLabel.text = "\(amount) SoCoins"
            cell.coinImageView.image = UIImage(named: "coin")
        
            if let price = paymentViewModel.pricePerAmount[amount] {
                cell.priceLabel.text = "\(price) €"
            }
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let amount = buyAmounts?[indexPath.row]
        buySoCoin(amount: amount!) { amount in
            self.database.updateCoins(with: amount) {
                // update coins count
                let currentAmount = Int(self.amountOfCoinsLabel.text ?? "0")
                let amountOfCoins = (currentAmount ?? 0) + amount
                self.amountOfCoinsLabel.text = "\(amountOfCoins)"
            }
        }
    }
    
    // MARK: FlowLayout
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
    
    // MARK: - UsernameDelegate
    func updateTextFields() {
        self.reloadUserInfoActivityIndicatorViewCollection.forEach { $0.startAnimating() }
        database.getCurrentUserProfile { profile in
            self.reloadUserInfoActivityIndicatorViewCollection.forEach { $0.stopAnimating() }
            self.usernameTextField.text = profile.username
            self.emailTextField.text = profile.email
            self.amountOfCoinsLabel.text = "\(profile.amountOfCoins)"
        }
    }
    
    func updateUserDefaults(password: String?, orEmail email: String?) {
        if let password = password {
            userDefaults.set(password, forKey: kuserDefaultsPasswordKey)
        }
        
        if let email = email {
            userDefaults.set(email, forKey: kuserDefaultsEmailKey)
        }
        
        userDefaults.synchronize()
    }
    
    // MARK: - IBActions
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        database.signOut {
            userDefaults.removeObject(forKey: kuserDefaultsEmailKey)
            userDefaults.removeObject(forKey: kuserDefaultsPasswordKey)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func changeUsername(_ sender: UIButton) {
        let vc = ChangeUsernameViewController()
        vc.username = usernameTextField.text
        vc.database = self.database
        weak var weakSelf = self
        vc.delegate = weakSelf
        self.present(vc, animated: true)
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        let vc = ChangePasswordViewController()
        vc.database = self.database
        weak var weakSelf = self
        vc.delegate = weakSelf
        vc.email = emailTextField.text
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
