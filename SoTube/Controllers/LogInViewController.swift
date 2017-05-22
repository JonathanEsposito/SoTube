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
    
    var database = DatabaseViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weak var weakSelf = self
        database.delegate = weakSelf
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginAsUser" {
            
        }
    }
    
    // MARK: - IBActions
    @IBAction func logIn(_ sender: UIButton) {
        guard let emailAddress = emailAddressTextField.text, emailAddress != "", let password = passwordTextField.text, password != "" else {
            showAlert(withTitle: "Login Error", message: "Both email and password must be filled out")
            return
        }
        
        database.login(withEmail: emailAddress, password: password, onCompletion: {
            
            // Dismiss the keyboard
            self.view.endEditing(true)
            
            // check if user already has any songs
            self.database.checkUserHasSongs { userHasSongs in
                // Perform segue
                if !userHasSongs {
                    print("lets go to the store")
                    let storyboard = UIStoryboard(name: "Store", bundle: nil)
                    guard let navigationController = storyboard.instantiateViewController(withIdentifier: "storeNavCont") as? UINavigationController else { print("Couldn't find account navigation controller"); return }
                    selectedTabBarItemWithTitle = "Store"
                    UIApplication.shared.keyWindow?.rootViewController = navigationController
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("go to my music")
                    selectedTabBarItemWithTitle = "My music"
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
            }
        })
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
}
