//
//  ChangeUsernameViewController.swift
//  SoTube
//
//  Created by .jsber on 22/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class ChangeUsernameViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var currentUsernameTextField: UITextField!
    @IBOutlet weak var newUsernameTextField: UITextField!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    let transitioner = CAVTransitioner()
    var username: String?
    var database: DatabaseViewModel?
    var delegate: userInfoDelegate?
    
    // MARK: - Initialization
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitioner
    }
    
    override func viewDidLoad() {
        buttonsView.addBorder(side: .top, thickness: 1, color: UIColor.groupTableViewBackground)
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
    
    @IBAction func changeAction(_ sender: UIButton) {
        guard let currentUsername = currentUsernameTextField.text, username == currentUsername else {
            showAlert(withTitle: "Username error", message: "Current username is not correctly filled out!")
            return
        }
        
        guard let newUsername = newUsernameTextField.text, username != "" else {
            showAlert(withTitle: "Username error", message: "Please choose a new username")
            return
        }
        
        self.delegate?.reloadUserInfoActivityIndicatorView.startAnimating()
        
        database?.changeUsername(to: newUsername) { error in
            if let error = error {
                self.delegate?.reloadUserInfoActivityIndicatorView.stopAnimating()
                self.showAlert(withTitle: "Username error", message: "Failed to change the display name: \(error.localizedDescription)")
            } else {
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
