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
        
        if database.succesfullLogin(withEmail: emailAddress, password: password) {
            self.view.endEditing(true)
            
            // Perform segue
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
    @IBAction func requestPasswordReset(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Password reset", message: "Enter the email address of the account to reset", preferredStyle: .alert)
        alertController.addTextField { (emailTextField) in
            emailTextField.placeholder = "Email Address"
        }
        let okAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
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
