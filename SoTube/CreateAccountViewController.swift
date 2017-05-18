//
//  CreateAccountViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 08/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, DatabaseDelegate {
    // MARK: - Properties
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
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
    
    // MARK: - IBAction
    @IBAction func createNewAccount(_ sender: UIButton) {
        // Checking the input
        guard let userName = userNameTextField.text, userName != "",
            let emailAddress = emailAddressTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "" else {
                showAlert(withTitle: "Insufficient information", message: "You must fill out all the fields to complete the registration successfully.")
                return
        }
        
        guard passwordTextField.text == verifyPasswordTextField.text else {
            self.showAlert(withTitle: "Passwordverification failed!", message: "Your Password and verify password are not the same")
            verifyPasswordTextField.text = nil
            return
        }
        
        database.createNewAccount(withUserName: userName, emailAddress: emailAddress, password: password)
    }
    
    @IBAction func backToLogin(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func createAccount() {
        
    }
    
   

}
