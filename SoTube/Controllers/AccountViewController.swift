//
//  AccountViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 16/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class AccountViewController: TabBarViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PaymentDelegate, userInfoDelegate {
    // MARK: - Properties
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var reloadUserInfoActivityIndicatorViewCollection: [UIActivityIndicatorView]!
    @IBOutlet weak var amountOfCoinsLabel: UILabel!
    @IBOutlet weak var amountOfSongsLabel: UILabel!
    
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
    
    // MARK: - UICollectionView
    // MARK: DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buyAmounts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentCell", for: indexPath) as! PaymentCollectionViewCell
        if let amount = buyAmounts?[indexPath.row] {
            // Remove previous image to prevent flickering on scroll
            cell.coinImageView.image = nil
            // Set values
            cell.amountLabel.text = "\(amount) SoCoins"
            cell.coinImageView.image = UIImage(named: "coin")
        
            if let price = paymentViewModel.pricePerAmount[amount] {
                cell.priceLabel.text = "\(price) €"
            }
        }
        return cell
    }
    
    // MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let amount = buyAmounts?[indexPath.row]
        buySoCoin(amount: amount!) { [weak self] amount in
            DispatchQueue.main.async {
                if let price = self?.pricePerAmount?[amount] {
                    let coinPurchase = CoinPurchase(amount: amount, price: price)
//                    print("I'm buying!!")
                    self?.database.updateCoins(with: coinPurchase) {
                        DispatchQueue.main.async {
                            // update coins count
                            let currentAmount = Int(self?.amountOfCoinsLabel.text ?? "0")
                            let amountOfCoins = (currentAmount ?? 0) + amount
                            self?.amountOfCoinsLabel.text = "\(amountOfCoins)"
                        }
                     } // End coinUpdate
                }
            }
        } // End buy coins
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
        database.getCurrentUserProfile { [weak self] profile in
            DispatchQueue.main.async {
                self?.reloadUserInfoActivityIndicatorViewCollection.forEach { $0.stopAnimating() }
                self?.usernameTextField.text = profile.username
                self?.emailTextField.text = profile.email
                self?.amountOfCoinsLabel.text = "\(profile.amountOfCoins)"
                self?.amountOfSongsLabel.text = "\(profile.amountOfSongs)"
            }
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
        database.signOut { [weak self] in
            self?.userDefaults.removeObject(forKey: self!.kuserDefaultsEmailKey)
            self?.userDefaults.removeObject(forKey: self!.kuserDefaultsPasswordKey)
            
            // remove player
            musicPlayer.track = nil
            musicPlayer.player.player = nil
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
            self?.dismiss(animated: true, completion: nil)
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
