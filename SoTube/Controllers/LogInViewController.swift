//
//  LogInViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 08/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

// Declare MusicPlayer
var musicPlayer = MusicPlayer()

class LogInViewController: UIViewController, DatabaseDelegate {
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginActivityIndicatorView: UIActivityIndicatorView!
    
    // UserDefaults
    let kuserDefaultsEmailKey = "userEmail"
    let kuserDefaultsPasswordKey = "userPassword"
    let userDefaults = UserDefaults.standard
    
    var database = DatabaseViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set database delegate
        weak var weakSelf = self
        database.delegate = weakSelf
        
        // If a login object is being saved to UserDefaults, use this object to log in and do the segue
        if userDefaults.object(forKey: kuserDefaultsEmailKey) != nil,
            userDefaults.object(forKey: kuserDefaultsPasswordKey) != nil {
            // Get credentials from UserDefaults
            let (emailAddress, password) = loadSavedLogin()
            // Perform login
            self.login(withEmail: emailAddress, password: password)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailAddressTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: - DatabaseDelegate
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginAsGuest" {
            selectedTabBarItemWithTitle = "Store"
        }
    }
    
    // MARK: - IBActions
    @IBAction func logIn(_ sender: UIButton) {
        guard let emailAddress = emailAddressTextField.text, emailAddress != "", let password = passwordTextField.text, password != "" else {
            showAlert(withTitle: "Login Error", message: "Both email and password must be filled out")
            return
        }
        self.login(withEmail: emailAddress, password: password)
    }
    
    @IBAction func requestPasswordReset(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Password reset", message: "Enter the email address of the account to reset", preferredStyle: .alert)
        alertController.addTextField { (emailTextField) in
            emailTextField.placeholder = "Email Address"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let resetAction = UIAlertAction(title: "Reset", style: .default) { [weak self] _ in
            guard let emailTextField = alertController.textFields?.first,
            let email = emailTextField.text
                else { return }
            self?.database.resetPassword(forEmail: email)
        }
        alertController.addAction(resetAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methodes
    private func login(withEmail emailAddress: String, password: String) {
        // activityindicator should start here. Check stop actions first!!!
//        self.loginActivityIndicatorView.startAnimating()
        
        database.login(withEmail: emailAddress, password: password, onCompletion: {
            self.loginActivityIndicatorView.startAnimating()
            // Dismiss the keyboard
            self.view.endEditing(true)
            
            // check if user already has any songs
            self.database.checkUserHasSongs { userHasSongs in
                self.loginActivityIndicatorView.stopAnimating()
                // Perform segue
                if !userHasSongs {
                    print("lets go to the store")
                    let storyboard = UIStoryboard(name: "Store", bundle: nil)
                    guard let navigationController = storyboard.instantiateViewController(withIdentifier: "storeNavCont") as? UINavigationController else { print("Couldn't find account navigation controller"); return }
                    selectedTabBarItemWithTitle = "Store"
                    UIApplication.shared.keyWindow?.rootViewController = navigationController
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Go to my music")
                    selectedTabBarItemWithTitle = "My music"
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
            }
            
            // If new user, save credentials to user defaults
            self.saveLoginToUserDefaults(email: emailAddress, password: password)
        })
    }
    
    private func saveLoginToUserDefaults(email: String, password: String) {
        userDefaults.set(email, forKey: kuserDefaultsEmailKey)
        userDefaults.set(password, forKey: kuserDefaultsPasswordKey)
        userDefaults.synchronize()
    }
    
    private func loadSavedLogin() -> (String, String) {
        let userEmail = userDefaults.object(forKey: kuserDefaultsEmailKey) as! String
        let userPassword = userDefaults.object(forKey: kuserDefaultsPasswordKey) as! String
        return (userEmail, userPassword)
    }
}
