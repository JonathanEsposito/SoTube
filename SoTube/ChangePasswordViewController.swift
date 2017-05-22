//
//  ChangePasswordViewController.swift
//  SoTube
//
//  Created by .jsber on 22/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmationPasswordTextField: UITextField!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    let transitioner = CAVTransitioner()
    var database: DatabaseViewModel?
    var delegate: userInfoDelegate?
    var email: String?
    
    // MARK: - Initialization
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitioner
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsView?.addBorder(side: .top, thickness: 1, color: UIColor.groupTableViewBackground)
        cancelButton.addBorder(side: .right, thickness: 1, color: UIColor.groupTableViewBackground)
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // MARK: - IBActions
    @IBAction func doDismiss(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        guard let currentPassword = currentPasswordTextField.text, currentPassword != "" else {
            showAlert(withTitle: "Password error", message: "Please fill out the current password first.")
            return
        }
        
        guard let newPassword = self.newPasswordTextField.text, newPassword != "",
            let confirmationPassword = self.confirmationPasswordTextField.text, confirmationPassword != "",
            newPassword == confirmationPassword else {
                self.showAlert(withTitle: "Password error", message: "The confirmation password is not the same as the new password. Please try agian.")
                return
        }
        
        guard let email = self.email else {
            print("Email not passed?")
            return
        }
        
        self.delegate?.reloadUserInfoActivityIndicatorView.startAnimating()
        
        // change password
        database?.change(currentPassword, with: newPassword, for: email, on: delegate!) { error in
            if let error = error {
                self.showAlert(withTitle: "Error reauthenticating user" , message: error.localizedDescription)
                self.delegate?.reloadUserInfoActivityIndicatorView.stopAnimating()
            } else {
                // do something
                self.delegate?.updateUserDefaults(password: newPassword, orEmail: nil)
                self.delegate?.updateTextFields()
                self.presentingViewController?.dismiss(animated: true)
            }
        }
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
